import 'dart:convert';

class SearchParameters {
  String searchTerm = "";
  FilterOptions filterOptions = new FilterOptions();
  String sortBy = "";

  bool isEmpty(){
    return searchTerm=="" && filterOptions.isEmpty() && sortBy=="";
  }

  void clear(){
    filterOptions.clear();
    sortBy = "";
  }

  Object getEncodedParameters(){
    String sort = "";

    if(sortBy == "") sort = "none";
    else if(sortBy == "Oldest First") sort = "oldest_first";
    else if(sortBy == "Newest First") sort = "newest_first";
    else if(sortBy == "Best Rated") sort = "best_rated";
    else sort = "most_popular";

    var jsonParameters = jsonEncode(<String, dynamic>{
      "searchTerm": searchTerm != ""? searchTerm: "none",
      "filterOptions": <String, dynamic>{
        "platform": filterOptions.platform != ""? filterOptions.platform: "none",
        "genres": filterOptions.genres,
        "multiplayer": filterOptions.multiplayer
      },
      "sortBy": sort
    });

    return jsonParameters;
  }
}

class FilterOptions {
  String platform = "";
  List<String> genres = [];
  bool multiplayer = false;

  bool isEmpty(){
    return platform=="" && genres.isEmpty && !multiplayer;
  }

  void clear(){
    platform = "";
    genres = [];
    multiplayer = false;
  }
}
