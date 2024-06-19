class Game {
  final int id;
  final String name;
  final String description;
  final String cover;
  final int release_date;
  int likes;
  final bool multiplayer;
  final int review_score;
  final genreData;
  final platformData;
  var platforms;
  var genres;
  var liked;
  final bool r_rated;

  Game({
    this.id,
    this.name,
    this.description = "",
    this.cover = "",
    this.release_date = 0,
    this.likes = 0,
    this.multiplayer = false,
    this.review_score = 0,
    this.platformData = null,
    this.genreData = null,
    this.liked = null,
    this.r_rated = false
  }){
    if(genreData != null){
      Map<String, dynamic> _genres = Map<String, dynamic>.from(genreData);
      genres = [];
      _genres.keys.forEach((genre) {
        genres.add(genre);
      });
    }

    if(platformData != null){
      Map<String, dynamic> _platforms = Map<String, dynamic>.from(platformData);
      platforms = [];
      _platforms.keys.forEach((platform) {
        platforms.add(platform);
      });
    }
  }
}
