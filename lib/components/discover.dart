import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/color-constants.dart';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import 'dart:convert';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import '../components/game-card.dart';
import '../models/search-parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Discover extends StatefulWidget {
  Discover({Key key}) : super(key: key);
  @override
  DiscoverState createState() => DiscoverState();
}

class DiscoverState extends State<Discover>{
  static ColorConstants colorConstants = new ColorConstants();
  List<Game> games = [];
  bool displayGames = false;

  @override
  void initState(){
    super.initState();
    fetchInitData(new SearchParameters());
  }

  fetchInitData(SearchParameters searchParameters) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var discoverData = await preferences.get("discoverData");

    if(discoverData == null){
      var body = searchParameters.getEncodedParameters();
      var token = preferences.get('authToken');
      var response = await http.post(
          'https://the-video-game-library.herokuapp.com/discover',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': token
          },
          body: body
      );

      if(response.statusCode == 200){
        discoverData = response.body;
        preferences.setString("discoverData", response.body);
      }

      else{
        return;
      }
    }

    List<Game> _games = [];
    final extractedData = json.decode(discoverData);
    List retrievedGames = extractedData['data'];
    for(var game in retrievedGames) {
      _games.add(Game(
          id: game["id"],
          name: game['name'],
          cover: game['cover'],
          likes: game['likes'],
          review_score: game['review_score'],
          genreData: game['genres']
      ));
    }

    if (!mounted) return;
    this.setState(() {
      games = _games;
      displayGames = true;
    });
  }

  fetchData(SearchParameters searchParameters) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.get('authToken');

    if (!mounted) return;
    this.setState(() {
      games = [];
    });

    List<Game> _games = [];
    var body = searchParameters.getEncodedParameters();
    var response = await http.post(
      'https://the-video-game-library.herokuapp.com/discover',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': token
      },
      body: body
    );

    if(response.statusCode == 200){
      preferences.setString("discoverData", response.body);
      final extractedData = json.decode(response.body);
      List retrievedGames = extractedData['data'];
      for(var game in retrievedGames) {
        _games.add(Game(
            id: game["id"],
            name: game['name'],
            cover: game['cover'],
            likes: game['likes'],
            review_score: game['review_score'],
            genreData: game['genres']
        ));
      }

      if (!mounted) return;
      this.setState(() {
        games = _games;
        displayGames = true;
      });
    }
  }

  List<Widget> getGameCards(){
    List<Widget> gameRows = [];

    gameRows.add(Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)));

    int index = 0;
    while(index<games.length){
      gameRows.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GameCard(game: games[index]),
              index+1 < games.length ?
              GameCard(game: games[++index]): Container(height: 250, width: 150),
            ],
          ),
        )
      );
      ++index;
    }

    return gameRows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Center(
          child: games.length != 0?
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getGameCards(),
              ),
            ):
            Loading(indicator: BallPulseIndicator(), size: 100.0,color: colorConstants.primary)
        )
    );
  }
}

