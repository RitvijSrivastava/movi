import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/auth_bloc/auth_event.dart';
import 'package:movi/models/movie.dart';
import 'package:movi/pages/add_new_movie_page/add_new_movie_page.dart';
import 'package:movi/pages/movie_info_page.dart/movie_info_page.dart';
import 'package:movi/utils/Loading.dart';
import 'package:movi/utils/custom_page_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: Hive.openBox<Movie>("movies-${_authBloc.currentUser!.uid}"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return ValueListenableBuilder(
                valueListenable:
                    Hive.box<Movie>("movies-${_authBloc.currentUser!.uid}")
                        .listenable(),
                builder: (context, Box<Movie> box, _) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 120.0,
                        toolbarHeight: 100.0,
                        floating: true,
                        shadowColor: Colors.transparent,
                        title: Text("Movies List"),
                        textTheme: TextTheme(
                          headline6: TextStyle(
                            color: Color(0xFF4E5B60),
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        actions: [
                          TextButton(
                            onPressed: () =>
                                _authBloc.authEventSink.add(SignOut()),
                            child: Icon(
                              Icons.logout,
                              color: Colors.grey[700],
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                      box.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "No Movies found!",
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Add a new movie by clicking on the '+' icon at the bottom right.",
                                        textScaleFactor: 1.2,
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverFixedExtentList(
                              itemExtent: 200.0,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  Movie movie = box.getAt(index) as Movie;
                                  return _buildListItem(movie, index);
                                },
                                childCount: box.values.length,
                              ),
                            ),
                    ],
                  );
                },
              );
            }
          } else {
            return Loading();
          }
        },
      ),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          heroTag: "add-new-movie",
          backgroundColor: Colors.red.shade400,
          onPressed: () {
            Navigator.of(context).push(
              CustomPageRoute(
                builder: (context) {
                  return AddNewMoviePage();
                },
              ),
            );
          },
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Movie movie, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieInfoPage(index: index),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 120,
                  height: MediaQuery.of(context).size.height,
                  child: movie.moviePoster == null
                      ? Image.asset(
                          'assets/no-image.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          new File(movie.moviePoster!),
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 25.0, 8.0, 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.movieName,
                          textScaleFactor: 2.2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          movie.movieDirector,
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey.shade700),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    _authBloc.dispose();
    super.dispose();
  }
}
