import 'package:movi/models/movie.dart';

abstract class MovieEvent {}

class AddNewMovie extends MovieEvent {
  final Movie movie;

  /// movie - Object of type [Movie]
  AddNewMovie({required this.movie});

  Movie get props => this.movie;
}

class EditMovie extends MovieEvent {
  final Movie movie;
  final int index;

  /// movie - Object of type [Movie]
  ///
  /// index - Index at which the Movie is located in the Hive Box.
  EditMovie({required this.movie, required this.index});

  // Map containging movie and index of the movie in the box.
  Map<String, dynamic> get props => {"movie": this.movie, "index": this.index};
}

class DeleteMovie extends MovieEvent {
  final Movie movie;
  final int index;

  /// movie - Object of type [Movie]
  ///
  /// index - Index at which the Movie is located in the Hive Box.
  DeleteMovie({required this.movie, required this.index});

  // Map containging movie and index of the movie in the box.
  Map<String, dynamic> get props => {"movie": this.movie, "index": this.index};
}
