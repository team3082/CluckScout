import 'package:cluck_scout/model/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late String scouterName;
  static late Position scoutingPosition;
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    
    // Load values during initialization
    scouterName = preferences?.getString('scouterName') ?? 'No Name';
    scoutingPosition = Position.values[preferences?.getInt('position') ?? 0];
  }

  static Future<void> saveScoutingPosition(Position value) async {
    scoutingPosition = value;
    await preferences?.setInt('position', value.index);
  }

  static Future<void> saveScouterName(String value) async {
    scouterName = value;
    await preferences?.setString('scouterName', value);
  }
}
