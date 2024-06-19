import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/color-constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/game.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/game-card.dart';

class Suggestions extends StatefulWidget {
  Suggestions({Key key}) : super(key: key);
  @override
  SuggestionsState createState() => SuggestionsState();
}

class SuggestionsState extends State<Suggestions> {
  static ColorConstants colorConstants = new ColorConstants();
  var _authorised = true;
  List<Game> games = [];
  bool displayGames = false;

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  refresh() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("suggestionData");
    if (!mounted) return;
    setState(() {
      games = [];
    });
    fetchData();
  }

  fetchData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.get('authToken');
    List<Game> _games = [];

    if (!mounted) return;
    if(token == null){
      setState(() {
        _authorised = false;
      });

      return;
    }

    var suggestionData = await preferences.get("suggestionData");
    if(suggestionData == null){
      var response = await http.post(
          'https://the-video-game-library.herokuapp.com/suggestions',
          headers:{
            'Accept': 'application/json',
            'Authorization': token
          }
      );

      if(response.statusCode == 200){
        suggestionData = response.body;
        preferences.setString("suggestionData", response.body);
      }

      else{
        if (!mounted) return;
        setState(() {
          _authorised = false;
        });
        return;
      }
    }

    final extractedData = json.decode(suggestionData);
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

  login(){
    Navigator.pushReplacementNamed(context, '/');
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
    if(!_authorised){
      return SafeArea(
        child: Center(
          child: MaterialButton(
              height: 50.0,
              minWidth: 200.0,
              color: colorConstants.primary,
              textColor: colorConstants.secondary,
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              onPressed: login,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              )
          ),
        ),
      );
    }

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


