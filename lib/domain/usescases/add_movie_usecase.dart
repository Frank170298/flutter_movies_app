import 'package:frank_salazar/domain/respositories/movie_repository.dart';
import 'package:frank_salazar/model/movie.dart';

class AddMovieUseCase {
  final MovieRepository repository;

  AddMovieUseCase(this.repository);

  Future<void> call(Movie movie) async {
    return await repository.addMovie(movie);
  }

  Future<List<Movie>> callMovies() async {
    return await repository.fetchMovies();
  }
}
