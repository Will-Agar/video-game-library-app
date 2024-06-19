import 'package:flutter/material.dart';
import 'components/login.dart';
import 'components/signup.dart';
import 'components/app-container.dart';
import 'components/game-display.dart';
import 'package:flutter/services.dart';

void main() {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.black, // status bar color
    statusBarBrightness: Brightness.dark,//status bar brigtness
    statusBarIconBrightness: Brightness.light , //status barIcon Brightness
    systemNavigationBarDividerColor: Colors.black,//Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        highlightColor: Colors.greenAccent
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/signup': (context) => Signup(),
        '/app': (context) => AppContainer(selectedItemPosition: ModalRoute.of(context).settings.arguments != null? ModalRoute.of(context).settings.arguments: 0),
        '/game': (context) => GameDisplay(gameId:  ModalRoute.of(context).settings.arguments)
      },
    );
  }
}


