import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String movieName;

  @HiveField(2)
  final String movieDirector;

  @HiveField(3)
  final String? moviePoster;

  Movie({
    required this.id,
    required this.movieName,
    required this.movieDirector,
    this.moviePoster,
  });
}
