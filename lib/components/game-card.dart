import 'package:flutter/material.dart';
import 'package:the_video_game_library/constants/color-constants.dart';
import '../models/game.dart';

class GameCard extends StatefulWidget {
  GameCard({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  static ColorConstants colorConstants = new ColorConstants();
  Widget _loader = Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(colorConstants.tertiary)
      )
  );

  String generateGenreString(){
    var genres = "";

    for(int x=0; x<this.widget.game.genres.length; x++){
      if(x==0) genres += this.widget.game.genres[x];
      else genres += ', ' + this.widget.game.genres[x];
    }

    return genres;
  }

  onSelectGame(int gamedId){
    Navigator.pushNamed(
      context,
      '/game',
      arguments: gamedId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectGame(this.widget.game.id),
      child: Card(
        color: colorConstants.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            height: 270,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(color: colorConstants.primary, width: 2),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: colorConstants.primary,
                      blurRadius: 10.0,
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(2.0, 2.0)
                  )
                ]
            ),
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.zero)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.zero),
                    child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_cover_big/${this.widget.game.cover}.jpg",
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _loader;
                        }
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 115, 0, 0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: colorConstants.secondary
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 120, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.favorite, color: colorConstants.tertiary, size: 20),
                              Text(
                                this.widget.game.likes.toString(),
                                style: TextStyle(color: colorConstants.tertiary, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.star, color: colorConstants.tertiary, size: 20),
                              Text(
                                '${((this.widget.game.review_score/100)*10).floor().toString()}/10',
                                style: TextStyle(color: colorConstants.tertiary, fontSize: 15),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: Container(
                    height: 120,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(15))
                    ),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                                height: 40,
                                child: Text(
                                  this.widget.game.name,
                                  style: TextStyle(color: colorConstants.primary, fontSize: 16, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 40,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  generateGenreString(),
                                  style: TextStyle(color: colorConstants.tertiary),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        )
      )
    );
  }
}
