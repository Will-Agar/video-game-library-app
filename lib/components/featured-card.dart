import 'package:flutter/material.dart';
import 'package:the_video_game_library/constants/color-constants.dart';
import '../models/game.dart';


class FeaturedCard extends StatefulWidget {
  FeaturedCard({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  static ColorConstants colorConstants = new ColorConstants();
  Widget _loader = Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(colorConstants.primary)
      )
  );

  onSelectGame(int gamedId){
    Navigator.pushNamed(
      context,
      '/game',
      arguments: gamedId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () => onSelectGame(this.widget.game.id),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Card(
            color: colorConstants.secondary,
            child: Container(
                height: 120,
                width: 120,
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: colorConstants.tertiary,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
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
                      padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child: Opacity(
                        opacity: 0.55,
                        child: Container(
                          height: 60,
                          width: 120,
                          decoration: BoxDecoration(
                              color: colorConstants.secondary,
                              borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 65, 5, 0),
                        child: Text(
                          this.widget.game.name,
                          style: TextStyle(color: colorConstants.tertiary),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                )
            )
        ),
      )
    );
  }
}