import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color-constants.dart';
import '../components/featured.dart';
import '../components/suggestions.dart';
import '../components/favorites.dart';
import '../components/discover-appbar.dart';
import '../models/search-parameters.dart';
import '../components/discover.dart';

class AppContainer extends StatefulWidget {
  AppContainer({Key key, this.selectedItemPosition = 0}) : super(key: key);

  int selectedItemPosition;

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  static ColorConstants colorConstants = new ColorConstants();
  final GlobalKey<DiscoverState> _key = GlobalKey();
  final GlobalKey<SuggestionsState> _suggestionKey = GlobalKey();

  setSearchParameters(SearchParameters newSearchParameters){
    _key.currentState.fetchData(newSearchParameters);
  }

  refresh(){
    _suggestionKey.currentState.refresh();
  }

  logout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    Navigator.pushReplacementNamed(context, '/');
  }
  
  setPage(index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("index", index.toString());
    setState(() => this.widget.selectedItemPosition = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: colorConstants.secondary,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: this.widget.selectedItemPosition == 1?
                AppBar(
                    backgroundColor: colorConstants.secondary,
                    automaticallyImplyLeading: false,
                    title: DiscoverAppbar(setSearchParameters: setSearchParameters)
                ):
                AppBar(
                    backgroundColor: colorConstants.secondary,
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: this.widget.selectedItemPosition == 2?
                            IconButton(
                              icon: Icon(Icons.refresh, color: colorConstants.tertiary, size: 30),
                              onPressed: refresh,
                            ):
                            Container()
                        ),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Image.asset(
                                'lib/assets/logo4.png',
                                fit: BoxFit.fitWidth,
                              ),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                                icon: Icon(Icons.logout, color: colorConstants.tertiary, size: 30),
                                onPressed: logout
                            )
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
          body: Center(
            child: [
              Featured(),
              Discover(key: _key),
              Suggestions(key: _suggestionKey),
              Favorites()
            ].elementAt(this.widget.selectedItemPosition),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: SnakeNavigationBar.color(
              behaviour: SnakeBarBehaviour.pinned,
              snakeShape: SnakeShape.indicator,
              padding: EdgeInsets.all(0),
              backgroundColor: colorConstants.secondary,
              snakeViewColor: colorConstants.primary,
              selectedItemColor: colorConstants.primary,
              unselectedItemColor: colorConstants.tertiary,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              currentIndex: this.widget.selectedItemPosition,
              onTap: (index) => setPage(index),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Featured'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Suggestions'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            ),
          )
      ),
    );
  }
}