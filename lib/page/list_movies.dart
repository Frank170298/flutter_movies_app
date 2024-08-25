// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frank_salazar/domain/respositories/movie_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:frank_salazar/domain/usescases/add_movie_usecase.dart';
import 'package:frank_salazar/model/movie.dart';

class ListMovieScreen extends StatefulWidget {
  const ListMovieScreen({super.key});

  @override
  _ListMovieScreenState createState() => _ListMovieScreenState();
}

class _ListMovieScreenState extends State<ListMovieScreen> {
  final AddMovieUseCase addMovieUseCase =
      AddMovieUseCase(MovieRepositoryImpl(http.Client()));
  List<Movie> movies = [];
  List<Movie> filteredMovies = [];
  String filter = '';
  List<String> selectedGenres = [];
  bool isLoading = true;
  bool isLoadingMore = false; // Para manejar la carga de más datos
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreMovies();
      }
    });
  }

  Future<void> _loadMovies() async {
    try {
      final fetchedMovies = await addMovieUseCase.callMovies();
      setState(() {
        movies = fetchedMovies;
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMovies() async {
    if (isLoadingMore) return; // Evita que se cargue más si ya está en proceso
    setState(() {
      isLoadingMore = true;
    });
    try {
      final fetchedMovies = await addMovieUseCase
          .callMovies(); // Aquí deberías tener un método para cargar más datos
      setState(() {
        movies.addAll(fetchedMovies);
        _applyFilter();
        isLoadingMore = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      filteredMovies = movies.where((movie) {
        final lowerFilter = filter.toLowerCase();
        final genreMatch = selectedGenres.isEmpty ||
            selectedGenres.any((genre) =>
                movie.genre.toLowerCase().contains(genre.toLowerCase()));
        return (movie.title.toLowerCase().contains(lowerFilter) ||
                movie.description.toLowerCase().contains(lowerFilter)) &&
            genreMatch;
      }).toList();
    });
  }

  void _onGenreSelected(List<String> genres) {
    setState(() {
      selectedGenres = genres;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: 120,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filter = value;
                        _applyFilter();
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Buscar por título o descripción',
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black54),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenreFilter(
                      onGenreSelected: _onGenreSelected,
                      genres: _getAllGenres(),
                      selectedGenres: selectedGenres,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator()) // Indicador de carga
                : filteredMovies.isEmpty && filter.isNotEmpty
                    ? const Center(child: Text('No results found'))
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredMovies.length +
                              (isLoadingMore
                                  ? 1
                                  : 0), // Añadimos 1 para el indicador de carga
                          itemBuilder: (context, index) {
                            if (index == filteredMovies.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return MovieCard(movie: filteredMovies[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  List<String> _getAllGenres() {
    final genres = <String>{};
    for (var movie in movies) {
      genres.add(movie.genre);
    }
    return genres.toList();
  }
}

class GenreFilter extends StatefulWidget {
  final List<String> genres;
  final List<String> selectedGenres;
  final ValueChanged<List<String>> onGenreSelected;

  const GenreFilter({
    super.key,
    required this.genres,
    required this.selectedGenres,
    required this.onGenreSelected,
  });

  @override
  _GenreFilterState createState() => _GenreFilterState();
}

class _GenreFilterState extends State<GenreFilter> {
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    _selectedGenres = widget.selectedGenres;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.genres.map((genre) {
        final isSelected = _selectedGenres.contains(genre);
        return ChoiceChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.remove(genre);
              }
              widget.onGenreSelected(_selectedGenres);
            });
          },
        );
      }).toList(),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              movie.imageUrl.isNotEmpty
                  ? movie.imageUrl
                  : 'https://media.licdn.com/dms/image/v2/D4E0BAQHiLAiGTCWEbA/company-logo_200_200/company-logo_200_200/0/1666121959498/delfosti_logo?e=2147483647&v=beta&t=EJ9f6FXk_zg9ehkolUe5RgLeLgFIcQ-6MJu--JinL0k',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://media.licdn.com/dms/image/v2/D4E0BAQHiLAiGTCWEbA/company-logo_200_200/company-logo_200_200/0/1666121959498/delfosti_logo?e=2147483647&v=beta&t=EJ9f6FXk_zg9ehkolUe5RgLeLgFIcQ-6MJu--JinL0k',
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title.isNotEmpty ? movie.title : 'No title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
