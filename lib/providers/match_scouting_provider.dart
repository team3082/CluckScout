import 'package:flutter/material.dart';
import 'package:cluck_scout/model/app_preferences.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/model/data/match_data.dart';
import 'package:cluck_scout/services/database_service.dart';
List<int> date = [];

class MatchScoutingProvider extends ChangeNotifier {
  // Current Tab
  int tabIndex;

  // Round Specifications
  int matchNumber;
  int teamNumber;
  Position position;
  String scouterName;

  // Auto Actions
  List<ActionType> autoActions;
  AutoStatus autoStatus;
  int autoScore;
  // store durations (seconds) for each hub visit during auto
  List<double> autoHubDurations;
  List<double> autoHubTimeStamp;

  // Teleop Actions
  List<ActionType> teleopActions;
  int teleopScore;
  // store durations (seconds) for each hub visit during teleop
  List<double> teleopHubDurations;
  List<double> teleopHubTimeStamp;
  EndStatus endStatus;

  // Final Fields
  Disabled disabled;
  RobotGoal robotGoal;
  int defenseRank;
  int drivingRank;
  int defenseTeamNumber;
  String notes;

  MatchScoutingProvider({
    this.tabIndex = 0,
    this.matchNumber = 0,
    this.teamNumber = 0,
    required this.position,
    required this.scouterName,
    this.autoScore = 0,
    this.teleopScore = 0,
    this.autoStatus = AutoStatus.none,
    this.endStatus = EndStatus.none,
    this.disabled = Disabled.None,
    this.robotGoal = RobotGoal.other,
    this.defenseRank = 0,
    this.drivingRank = 0,
    this.notes = '',
    this.defenseTeamNumber = 0,
    List<ActionType>? autoActions,
    List<ActionType>? teleopActions,
    List<double>? autoHubDurations,
    List<double>? teleopHubDurations,
    List<double>? autoHubTimeStamp,
    List<double>? teleopHubTimeStamp,
  })  : autoActions = autoActions ?? <ActionType>[],
        teleopActions = teleopActions ?? <ActionType>[],
        autoHubDurations = autoHubDurations ?? <double>[],
        autoHubTimeStamp = autoHubTimeStamp ?? <double>[],
        teleopHubTimeStamp = teleopHubTimeStamp ?? <double>[],
        teleopHubDurations = teleopHubDurations ?? <double>[];

  void submitMatchData() {
    scouterName = AppPreferences.scouterName;
    final matchData = _createMatchData();
    DatabaseService.instance.insertMatchData(matchData);

    resetFields();
    notifyListeners();
  }

  MatchData _createMatchData() {

    return MatchData(
      matchNumber: matchNumber,
      teamNumber: teamNumber,
      position: position,
      scouterName: scouterName,
      autoStatus: autoStatus,
      // pass totals (or lists) depending on MatchData definition
      autoHubDurations: autoHubDurations,
      autoHubTimeStamp: autoHubTimeStamp,
      teleopHubDurations: teleopHubDurations,
      teleopHubTimeStamp: teleopHubTimeStamp,
      endStatus: endStatus,
      disabled: disabled,
      defenseRank: defenseRank,
      drivingRank: drivingRank,
      notes: notes,
    );
  }

  int _countOccurrences(List<ActionType> actions, ActionType action) {
    return actions.where((currentAction) => currentAction == action).length;
  }

  // Calculates Auto Score
  void _updateAutoScore() {
    int autoL1Points = _countOccurrences(autoActions, ActionType.L1) * 15;
    int autoL2Points = _countOccurrences(autoActions, ActionType.L2) * 15;
    int autoL3Points = _countOccurrences(autoActions, ActionType.L3) * 15;

    // Sum durations and convert to points (example: 5 points per second)
    final double autoHubTotal = autoHubDurations.fold(0.0, (sum, item) => sum + item);
    int autoHubPoints = (autoHubTotal* 5).toInt();

    autoScore = autoL1Points + autoL2Points + autoL3Points + autoHubPoints;
  }

  void resetFields() {
    matchNumber++;
    teamNumber = 0;

    autoActions.clear();
    autoHubDurations.clear();
    autoScore = 0;

    teleopActions.clear();
    teleopHubDurations.clear();
    endStatus = EndStatus.none;
    teleopScore = 0;

    disabled = Disabled.None;
    defenseRank = 0;
    drivingRank = 5;
    notes = '';
  }

  void addAutoAction(ActionType action) {
    autoActions.add(action);
    _updateAutoScore();
    notifyListeners();
  }

  /// Add a hub duration (in seconds) recorded during auto
  void addAutoHubDurations(double seconds) {
    autoHubDurations.add(seconds);
    _updateAutoScore();
    notifyListeners();
  }

  void addTeleopAction(ActionType action) {
    teleopActions.add(action);
    _updateTeleopScore();
    notifyListeners();
  }

  /// Add a hub duration (in seconds) recorded during teleop
  void addTeleopHubDurations(double seconds) {
    teleopHubDurations.add(seconds);
    _updateTeleopScore();
    notifyListeners();
  }

  String getAutoActionString() {
    return _getActionString(autoActions);
  }

  String getTeleopActionString() {
    return _getActionString(teleopActions);
  }
  
  String _getActionString(List<ActionType> actionTypes) {
    return actionTypes.map((action) {
      switch (action) {
        case ActionType.Hub:
          date.add(DateTime.now().millisecondsSinceEpoch);
          return  date;
        case ActionType.L1:
          date.remove(DateTime.now().millisecondsSinceEpoch);
          //return "L1";
        case ActionType.L2:
          date.remove(DateTime.now().millisecondsSinceEpoch);
          //return "L2";
        case ActionType.L3:
          date.remove(DateTime.now().millisecondsSinceEpoch);
          //return "L3";
        case ActionType.Bump:
          date.remove(DateTime.now().millisecondsSinceEpoch);
          return "Bump";
        case ActionType.Trench:
          date.remove(DateTime.now().millisecondsSinceEpoch);
          return "Trench";
        // add other ActionType cases here as needed
        //default:
          //return action.toString();
      }
    }).toList().join(', ');
  }

  void setPosition(Position position) {
    this.position = position;
    AppPreferences.saveScoutingPosition(position);
    notifyListeners();
  }

  void removeAutoAction() {
    if (autoActions.isNotEmpty) {
      autoActions.removeLast();
      date.remove(DateTime.now().millisecondsSinceEpoch);
      _updateAutoScore();
      notifyListeners();
    }
  }

  void setTabIndex(int tabIndex) {
    this.tabIndex = tabIndex;
    notifyListeners();
  }

  void setMatchNumber(int matchNumber) {
    this.matchNumber = matchNumber;
    notifyListeners();
  }

  void setTeamNumber(int teamNumber) {
    this.teamNumber = teamNumber;
    notifyListeners();
  }

  void setScouterName(String scouterName) {
    this.scouterName = scouterName;
    AppPreferences.saveScouterName(scouterName);
    notifyListeners();
  }

  void setMatchNotes(String value) {
    notes = value;
    notifyListeners();
  }

  void _updateTeleopScore() {
    final double teleopHubTotal = teleopHubDurations.fold(0.0, (sum, item) => sum + item);
    int teleopHubPoints = (teleopHubTotal * 5).toInt();

    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.L1
            ? 10
            : endStatus == EndStatus.L2
                ? 20
                : 30;

    teleopScore = teleopHubPoints + endStatusPoints;
  }

  void removeTeleopAction() {
    if (teleopActions.isNotEmpty) {
      teleopActions.removeLast();
      date.remove(DateTime.now().millisecondsSinceEpoch);
      _updateTeleopScore();
      notifyListeners();
    }
  }

  void setEndStatus(EndStatus endStatus) {
    this.endStatus = endStatus;
    _updateTeleopScore();
    notifyListeners();
  }

  void setDisabled(Disabled value) {
    disabled = value;
    notifyListeners();
  }

  void setRobotGoal(RobotGoal value) {
    robotGoal = value;
    notifyListeners();
  }
  
  void setDefense(int value) {
    defenseRank = value;
    notifyListeners();
  }

  void setDefenseTeam(int teamNumber) {
    defenseTeamNumber = teamNumber;
  }

  void setDrivingRank(int value) {
    drivingRank = value;
    notifyListeners();
  }
}
