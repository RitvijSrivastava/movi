import 'dart:async';

import 'package:hive/hive.dart';
import 'package:movi/blocs/movie_bloc/movie_event.dart';
import 'package:movi/models/movie.dart';

class MovieBloc {
  final _movieEventController = StreamController<MovieEvent>();
  Sink<MovieEvent> get movieEventSink => _movieEventController.sink;

  MovieBloc() {
    _movieEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MovieEvent event) {
    if (event is AddNewMovie) {
      _handleAddNewMovie(event.props);
    } else if (event is EditMovie) {
      _handleEditMovie(event.props);
    } else if (event is DeleteMovie) {
      _handleDeleteMovie(event.props);
    }
  }

  /// Add new movie to the user's movie box.
  /// The [key] is the [movie.name] in lowercase.
  Future<void> _handleAddNewMovie(Movie movie) async {
    final box = Hive.box<Movie>("movies-${movie.id}");
    if (!box.containsKey(movie.movieName.toLowerCase())) {
      await box.put(movie.movieName.toLowerCase(), movie);
    }
  }

  /// Update an existing movie.
  /// Uses index to find and update the movie.
  Future<void> _handleEditMovie(Map<String, dynamic> props) async {
    Movie movie = props['movie'];
    int index = props['index'];

    final box = Hive.box<Movie>("movies-${movie.id}");
    await box.putAt(index, movie);
  }

  /// Delete an existing movie by key.
  Future<void> _handleDeleteMovie(Map<String, dynamic> props) async {
    Movie movie = props['movie'];
    int index = props['index'];

    final box = Hive.box<Movie>("movies-${movie.id}");
    await box.deleteAt(index);
  }

  void dispose() {
    _movieEventController.close();
  }
}
