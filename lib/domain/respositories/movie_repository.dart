import 'package:frank_salazar/model/movie.dart';

abstract class MovieRepository {
  Future<void> addMovie(Movie movie);

  Future<List<Movie>> fetchMovies();
}
