import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cluck_scout/model/app_preferences.dart';
import 'package:cluck_scout/model/team_reader.dart';
import 'package:cluck_scout/providers/app_provider.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/scouting_screen.dart';
import 'package:cluck_scout/screens/settings_screen/settings_screen.dart';
import 'package:cluck_scout/screens/data_screen/data_page.dart';
import 'package:cluck_scout/screens/home_screen/home_page.dart';
import 'package:provider/provider.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Run initialization tasks in parallel
  await Future.wait([
    TeamReader.readTeamsFromFiles(),
    NameReader.readNamesFromFiles(),
    AppPreferences.init(),
  ]);

  runApp(ChickenScout());
}

class ChickenScout extends StatelessWidget {
  // Define routes as a class field
  final Map<String, WidgetBuilder> routes = {
    "/homepage": (context) => const HomePage(),
    "/scoutpage": (context) => const ScoutPage(),
    "/datapage": (context) => const DataScreen(),
    "/settingspage": (context) => const SettingsScreen()
  };

  ChickenScout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MatchScoutingProvider(
              position: AppPreferences.scoutingPosition,
              scouterName: AppPreferences.scouterName),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              PitScoutingProvider(scouterName: AppPreferences.scouterName),
        ),
        ChangeNotifierProvider(create: (context) => AppProvider())
      ],
      child: MaterialApp(
        home: HomePage(),
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder? builder = routes[settings.name];
          if (builder != null) {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  builder(context),
            );
          }
          return null;
        },
      ),
    );
  }
}
