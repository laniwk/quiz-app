import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/route_names.dart';
import 'core/helpers/screen_router.dart';
import 'singletons.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  initSingletons();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matematika Jago',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(brightness: Brightness.dark),
        fontFamily: 'Quicksand',
      ),
      initialRoute: RouteNames.home,
      onGenerateRoute: ScreenRouter.onGenerateRoute,
    );
  }
}
