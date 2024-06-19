import 'package:flutter/material.dart';
import '../constants/color-constants.dart';
import '../components/featured-card.dart';
import '../models/game.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';


class FeaturedRow extends StatefulWidget {
  FeaturedRow({Key key, this.games, this.title}) : super(key: key);

  final List<Game> games;
  final String title;

  @override
  _FeaturedRowState createState() => _FeaturedRowState();
}

class _FeaturedRowState extends State<FeaturedRow> {
  static ColorConstants colorConstants = new ColorConstants();
  List<Widget> _gameCards = [];

  setGames(){
    var index = 0;

    while(index<this.widget.games.length){
      _gameCards.add(
        Column(
          children: [
            FeaturedCard(game: this.widget.games[index]),
            index+1 < this.widget.games.length ? FeaturedCard(game: this.widget.games[++index]) : Container(),
          ],
        ),
      );
      ++index;
    }

    this.setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.widget.games.length != 0){
      setGames();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    this.widget.title,
                    style: TextStyle(color: colorConstants.tertiary, fontSize: 30, fontWeight: FontWeight.w500),
                  )
              )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                  (_gameCards.length == 0)?
                  [Loading(indicator: BallPulseIndicator(), size: 100.0,color: colorConstants.primary)]:
                  _gameCards
              ),
            )
          )
        ],
      )
    );
  }
}


