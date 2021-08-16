import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/movie_bloc/movie_bloc.dart';
import 'package:movi/blocs/movie_bloc/movie_event.dart';
import 'package:movi/models/movie.dart';
import 'package:movi/pages/movie_info_page.dart/components/edit_movie_popup.dart';
import 'package:movi/utils/Loading.dart';
import 'package:movi/utils/custom_page_route.dart';

class MovieInfoPage extends StatefulWidget {
  final int index;
  const MovieInfoPage({Key? key, required this.index}) : super(key: key);

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  Movie? movie;
  final _authBloc = new AuthBloc();
  final _movieBloc = new MovieBloc();

  @override
  void initState() {
    movie = Hive.box<Movie>("movies-${_authBloc.currentUser!.uid}")
        .getAt(widget.index) as Movie;
    super.initState();
  }

  _handleDeleteMovie() {
    _movieBloc.movieEventSink.add(
      DeleteMovie(movie: movie!, index: widget.index),
    );

    // Show success message
    final snackBar = SnackBar(content: Text('Movie deleted successfully!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Pop out of this page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Movie Info"),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF4E5B60),
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
            size: 35.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _handleDeleteMovie();
            },
            child: Icon(
              Icons.delete,
              color: Colors.grey[700],
              size: 35.0,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: movie != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 10.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.74,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: movie!.moviePoster == null
                            ? Image.asset(
                                'assets/no-image.png',
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                new File(movie!.moviePoster!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      movie!.movieName,
                      textScaleFactor: 2.5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      movie!.movieDirector,
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            )
          : Loading(),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          heroTag: "edit-movie",
          backgroundColor: Colors.red.shade400,
          onPressed: () {
            Navigator.of(context).push(
              CustomPageRoute(
                builder: (context) {
                  return EditMoviePopup(movie: movie!, index: widget.index);
                },
              ),
            ).then((_) {
              //Reload page
              setState(() {
                movie = Hive.box<Movie>("movies-${_authBloc.currentUser!.uid}")
                    .getAt(widget.index) as Movie;
              });
            });
          },
          child: Icon(
            Icons.edit,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    _movieBloc.dispose();
    super.dispose();
  }
}
