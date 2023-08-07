import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/model/favorite/fav_model.dart';
import 'package:musicnation/model/playlist/playlist_model.dart';
import 'package:musicnation/screens/splash_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(FavModelAdapter().typeId)) {
    Hive.registerAdapter(FavModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModelAdapter());
  }
  // if(!Hive.isAdapterRegistered())
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DenkOne',
      ),
      // home: SplashScreen(),
      home: const SplashScreen(),
    );
  }
}
