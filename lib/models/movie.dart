import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final String movieName;

  @HiveField(1)
  final String movieDirector;

  @HiveField(2)
  final String moviePoster;

  Movie(this.movieName, this.movieDirector, this.moviePoster);
}
