import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movi/blocs/auth_bloc/auth_bloc.dart';
import 'package:movi/blocs/movie_bloc/movie_bloc.dart';
import 'package:movi/blocs/movie_bloc/movie_event.dart';
import 'package:movi/models/movie.dart';
import 'package:path_provider/path_provider.dart';

class AddNewMoviePage extends StatefulWidget {
  @override
  _AddNewMoviePageState createState() => _AddNewMoviePageState();
}

class _AddNewMoviePageState extends State<AddNewMoviePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _authBloc = new AuthBloc();
  final _movieBloc = new MovieBloc();

  String? _movieName;
  String? _movieDirector;
  String? _moviePoster;

  /// Get Image using [FilePicker] and transfer that image from cache to Applications Directory
  Future<void> _getImage() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    Directory _movieImageDir = Directory(_directory.path + "/.images");

    if (!(await _movieImageDir.exists())) {
      await _movieImageDir.create();
    }

    // Pick an image from the user
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File oldFile = File(result.files.single.path!);
      String fileName = result.files.single.name; // With Extension

      // Move file from cache to Application Directory.
      final newFile = await oldFile.copy(_movieImageDir.path + "/" + fileName);
      setState(() {
        _moviePoster = newFile.path;
      });
    }
  }

  /// Validate the form, then add the data to the database.
  void _handleOnSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Movie movie = new Movie(
        id: _authBloc.currentUser!.uid,
        movieName: _movieName!,
        movieDirector: _movieDirector!,
        moviePoster: _moviePoster,
      );

      // Add [movie] to the database
      _movieBloc.movieEventSink.add(AddNewMovie(movie: movie));

      // Show success message
      final snackBar = SnackBar(content: Text('New movie added successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Pop back to home screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key:
                    _formKey, // Hero inside Form is a workaround for: https://github.com/flutter/flutter/issues/49952
                child: Hero(
                  tag: "add-new-movie",
                  child: Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () {
                              _getImage();
                            },
                            child: Container(
                              width: 160.0,
                              height: 230.0,
                              child: _moviePoster == null
                                  ? Image.asset(
                                      'assets/no-image.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      new File(_moviePoster!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          TextFormField(
                            maxLength: 100,
                            style: TextStyle(fontSize: 22.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Movie Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This is required';
                              }
                              return null;
                            },
                            onSaved: (movieName) => _movieName = movieName,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            maxLength: 80,
                            style: TextStyle(fontSize: 22.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Movie Director',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This is required';
                              }
                              return null;
                            },
                            onSaved: (movieDirector) =>
                                _movieDirector = movieDirector,
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              _handleOnSubmit();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green.shade700,
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
