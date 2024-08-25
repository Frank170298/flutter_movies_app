// lib/data/repositories/movie_repository_impl.dart

// ignore_for_file: unused_local_variable

import 'package:frank_salazar/domain/respositories/movie_repository.dart';
import 'package:frank_salazar/model/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieRepositoryImpl implements MovieRepository {
  final http.Client client;

  MovieRepositoryImpl(this.client);

  final String apiUrl =
      'https://repository-delfosti-aws-prueba-11.onrender.com/movies';

  @override
  Future<void> addMovie(Movie movie) async {
    final response = await client.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': movie.title,
        'description': movie.description,
        'genre': movie.genre,
      }),
    );
  }

  @override
  Future<List<Movie>> fetchMovies() async {
    final response = await client.get(Uri.parse(apiUrl));
    print("response: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('');
    }
  }
}
