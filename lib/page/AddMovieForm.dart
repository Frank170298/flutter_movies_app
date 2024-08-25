// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frank_salazar/domain/respositories/movie_repository_impl.dart';
import 'package:frank_salazar/domain/usescases/add_movie_usecase.dart';
import 'package:frank_salazar/model/movie.dart';
import 'package:http/http.dart' as http;

class AddMovieForm extends StatefulWidget {
  final Function(Movie) onMovieAdded;

  const AddMovieForm({super.key, required this.onMovieAdded});

  @override
  _AddMovieFormState createState() => _AddMovieFormState();
}

class _AddMovieFormState extends State<AddMovieForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedGenre;
  bool _isSubmitting = false;

  AddMovieUseCase? _addMovieUseCase;

  @override
  void initState() {
    super.initState();
    final movieRepository = MovieRepositoryImpl(http.Client());
    _addMovieUseCase = AddMovieUseCase(movieRepository);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      final title = _titleController.text;
      final description = _descriptionController.text;
      final genre = _selectedGenre!;

      Movie newMovie = Movie(
        title: title,
        description: description,
        genre: genre,
        imageUrl: '',
        id: 0,
      );

      try {
        await _addMovieUseCase!.call(newMovie);
        widget.onMovieAdded(newMovie);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película agregada.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al agregar la película.')),
        );
      }

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedGenre = null;
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Añadir Nueva Película",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                // Campo de Título
                _buildTextField(
                    'Título', _titleController, Icons.movie_creation),
                const SizedBox(height: 16.0),
                // Campo de Descripción
                _buildTextField(
                    'Descripción', _descriptionController, Icons.description,
                    maxLines: 4),
                const SizedBox(height: 16.0),
                // Campo de Género
                _buildGenreDropdown(),
                const SizedBox(height: 30.0),
                // Botón de Agregar Película
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(color: Colors.black),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese $label.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGenre,
        decoration: const InputDecoration(
          labelText: 'Género',
          prefixIcon: Icon(Icons.category),
          border: OutlineInputBorder(),
        ),
        items: ['Drama', 'Action', 'Crime'].map((genre) {
          return DropdownMenuItem(
              value: genre,
              child: Text(genre, style: const TextStyle(color: Colors.black)));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedGenre = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, seleccione un género.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _isSubmitting ? null : _submitForm,
        child: _isSubmitting
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'Agregar Película',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}
