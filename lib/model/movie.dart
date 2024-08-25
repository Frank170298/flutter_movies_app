import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Movie> movies;

  Welcome({
    required this.movies,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        movies: List<Movie>.from(json["movies"].map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
      };
}

class Movie {
  int id;
  String title;
  String description;
  String genre;
  String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"] ?? 0,
        title: json["title"] ?? 'No title', // Valor por defecto
        description:
            json["description"] ?? 'No description', // Valor por defecto
        genre: json["genre"] ?? 'No genre', // Valor por defecto
        imageUrl: json["imageUrl"] ??
            'https://media.licdn.com/dms/image/v2/D4E0BAQHiLAiGTCWEbA/company-logo_200_200/company-logo_200_200/0/1666121959498/delfosti_logo?e=2147483647&v=beta&t=EJ9f6FXk_zg9ehkolUe5RgLeLgFIcQ-6MJu--JinL0k', // Imagen por defecto si es null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "genre": genre,
        "imageUrl": imageUrl,
      };
}

final movies = {
  "1": Movie(
      id: 1,
      title: "The Shawshank Redemption",
      description:
          "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency..",
      genre: "Drama",
      imageUrl:
          "https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg"),
  "2": Movie(
      id: 2,
      title: "Inception",
      description:
          "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
      genre: "Action",
      imageUrl:
          "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjJV7SnxCwRhYQU6bWHqjg1kq6gu6kwhB4I07iSShWvNGEKoZB9UrbAU73UyeExUW0V7pkDT4opAu89_5tVHQuPPfIzTeHKs_TJ2hLyd3Q8IAXYG5Fx47VkSfq13VPW2lGjDlRaScUcO5xq/s1600/inception_ver13_xlg.jpg"),
  "3": Movie(
      id: 3,
      title: "The Dark Knight",
      description:
          "When the menace known as The Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
      genre: "Action",
      imageUrl: "https://static.posters.cz/image/750webp/197743.webp"),
  "4": Movie(
      id: 4,
      title: "Pulp Fiction",
      description:
          "The lives of two mob hitmen, a boxer, a gangster's wife, and a pair of diner bandits intertwine in four tales of violence and redemption.",
      genre: "Crime",
      imageUrl:
          "https://musicart.xboxlive.com/7/292c0b00-0000-0000-0000-000000000002/504/image.jpg?w=1920&h=1080"),
  "5": Movie(
      id: 5,
      title: "The Godfather",
      description:
          "he aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
      genre: "Crime",
      imageUrl:
          "https://static.wikia.nocookie.net/doblaje/images/9/9a/Elpadrino.jpg/revision/latest?cb=20211023042804&path-prefix=es"),
  "6": Movie(
      id: 6,
      title: "Fight Club",
      description:
          "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
      genre: "Drama",
      imageUrl:
          "https://m.media-amazon.com/images/M/MV5BMmEzNTkxYjQtZTc0MC00YTVjLTg5ZTEtZWMwOWVlYzY0NWIwXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_FMjpg_UX1000_.jpg"),
};
