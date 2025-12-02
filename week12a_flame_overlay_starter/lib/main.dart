import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'overlay_title.dart';
import 'overlay_main.dart';
import 'overlay_pause.dart';
import 'overlay_info.dart';
import 'overlay_settings.dart';
import 'game.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'highscore_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentNavScreen = 0;

  final List<Widget> _bottomNavScreens = [
    const MainGame(),
    const HighScorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: const Text("Asteroid"),
            backgroundColor: Colors.deepPurple,
          ),
          body: IndexedStack(
            index: _currentNavScreen,
            children: _bottomNavScreens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentNavScreen,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: "High Scores",
              ),
            ],
            onTap: (value) {
              final gameProvider = Provider.of<GameProvider>(
                context,
                listen: false,
              );

              setState(() {
                _currentNavScreen = value;
                gameProvider.game?.paused = true;
                gameProvider.game?.overlays.add('pause');
              });
            },
          ),
        ),
      ),
    );
  }
}

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return GameWidget.controlled(
      gameFactory: () {
        final game = OverlayTutorial(context);
        game.paused = true;
        gameProvider.game = game;
        return game;
      },
      overlayBuilderMap: {
        'title': (context, game) {
          return OverlayTitle(game: game);
        },
        'main': (context, game) {
          return mainOverlay(context, game);
        },
        'pause': (context, game) {
          return pauseOverlay(context, game);
        },
        'info': (context, game) {
          return InfoOverlay(game: game as OverlayTutorial); // Cast required!
        },
        'settings': (context, game) {
          return settingsOverlay(context, game);
        },
      },
      initialActiveOverlays: const ['title'],
    );
  }
}
