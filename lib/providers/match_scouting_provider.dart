import 'package:flutter/material.dart';
import 'package:cluck_scout/model/app_preferences.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/model/data/match_data.dart';
import 'package:cluck_scout/services/database_service.dart';

class MatchScoutingProvider extends ChangeNotifier {
  //Current Tab
  int tabIndex;

  // Round Specifications
  int matchNumber;
  int teamNumber;
  Position position;
  String scouterName;

  // Auto Actions
  List<ActionType> autoActions = List<ActionType>.empty(growable: true);
  int autoScore;
  List<double> autoHubDuration = List<double>.empty(growable: true);
  List<double> autoHubTimeStamp = List<double>.empty(growable: true);
  bool isShooting = false;
  DateTime? _autoHubStartTime;

  // Teleop Actions
  List<ActionType> teleopActions = List<ActionType>.empty(growable: true);
  int teleopScore;
  List<double> teleopHubDuration = List<double>.empty(growable: true);
  List<double> teleopHubTimeStamp = List<double>.empty(growable: true);
  bool isTeleopShooting = false;
  DateTime? _teleopHubStartTime;
  EndStatus endStatus;
  bool autoLeave;

  // Final Fields
  Disabled disabled;
  int defenseRank;
  int drivingRank;
  int defenseTeamNumber;
  String notes;
  RobotType robotType;

  MatchScoutingProvider({
    this.tabIndex = 0,
    this.matchNumber = 0,
    this.teamNumber = 0,
    required this.position,
    required this.scouterName,
    this.autoScore = 0,
    this.teleopScore = 0,
    this.endStatus = EndStatus.none,
    this.disabled = Disabled.None,
    this.defenseRank = 0,
    this.drivingRank = 0,
    this.notes = '',
    this.defenseTeamNumber = 0,
    this.robotType = RobotType.Unknown,
    this.autoLeave = false,
  });

  void submitMatchData() {
    scouterName = AppPreferences.scouterName;
    final matchData = _createMatchData();
    DatabaseService.instance.insertMatchData(matchData);
    
    resetFields();
    notifyListeners();
  }

  //------Start Edits-------------------------------------------------------------------
  MatchData _createMatchData() {
    return MatchData(
      matchNumber: matchNumber,
      teamNumber: teamNumber,
      position: position,
      scouterName: scouterName,
      autoL1: _countOccurrences(
        autoActions,
        ActionType.L1,
      ),
      autoL2: _countOccurrences(
        autoActions,
        ActionType.L2,
      ),
      autoL3: _countOccurrences(
        autoActions,
        ActionType.L3,
      ),
      autoHubDuration: autoHubDuration,
      autoHubTimeStamp: autoHubTimeStamp,
      teleopHubDuration: teleopHubDuration,
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

  // Calculates Auto Score... hopefully
  void _updateAutoScore() {
    int autoL1Points =
        _countOccurrences(autoActions, ActionType.L1) * 15;
    int autoL2Points =
        _countOccurrences(autoActions, ActionType.L2) * 15;
    int autoL3Points =
        _countOccurrences(autoActions, ActionType.L3) * 15;

    // still need something instead of count occurrences
    int autoHubPoints = 0; // Hub-based points not implemented yet

    autoScore = autoL1Points +
      autoL2Points +
      autoL3Points +
      autoHubPoints;
  }

  void resetFields() {
    matchNumber++;
    teamNumber = 0;

    autoActions.clear();
    autoScore = 0;
    autoHubDuration.clear();
    autoHubTimeStamp.clear();
    isShooting = false;
    _autoHubStartTime = null;

    teleopHubDuration.clear();
    teleopHubTimeStamp.clear();
    isTeleopShooting = false;
    _teleopHubStartTime = null;

    teleopActions.clear();
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

  void removeAutoActionOfType(ActionType action) {
    final idx = autoActions.lastIndexOf(action);
    if (idx != -1) {
      autoActions.removeAt(idx);
      _updateAutoScore();
      notifyListeners();
    }
  }

  void startAutoHub() {
    if (isShooting) return;
    isShooting = true;
    _autoHubStartTime = DateTime.now();
    notifyListeners();
  }

  void stopAutoHub() {
    if (!isShooting || _autoHubStartTime == null) return;
    final end = DateTime.now();
    final duration = end.difference(_autoHubStartTime!).inMilliseconds / 1000.0;
    autoHubDuration.add(duration);
    autoHubTimeStamp.add(_autoHubStartTime!.millisecondsSinceEpoch / 1000.0);
    isShooting = false;
    _autoHubStartTime = null;
    notifyListeners();
  }

  void startTeleopHub() {
    if (isTeleopShooting) return;
    isTeleopShooting = true;
    _teleopHubStartTime = DateTime.now();
    notifyListeners();
  }

  void stopTeleopHub() {
    if (!isTeleopShooting || _teleopHubStartTime == null) return;
    final end = DateTime.now();
    final duration = end.difference(_teleopHubStartTime!).inMilliseconds / 1000.0;
    teleopHubDuration.add(duration);
    teleopHubTimeStamp.add(_teleopHubStartTime!.millisecondsSinceEpoch / 1000.0);
    isTeleopShooting = false;
    _teleopHubStartTime = null;
    notifyListeners();
  }

  void addTeleopAction(ActionType action) {
    teleopActions.add(action);
    _updateTeleopScore();
    notifyListeners();
  }

  void removeTeleopActionOfType(ActionType action) {
    final idx = teleopActions.lastIndexOf(action);
    if (idx != -1) {
      teleopActions.removeAt(idx);
      _updateTeleopScore();
      notifyListeners();
    }
  }

  String getAutoActionString() {
    return _getActionString(autoActions);
  }

  String getTeleopActionString() {
    return _getActionString(teleopActions);
  }

  String _getActionString(List<ActionType> actionTypes) {
    return actionTypes
        .map((action) {
          switch (action) {
            case ActionType.L1:
              return "L1";
            case ActionType.L2:
              return "L2";
            case ActionType.L3:
              return "L3";
            case ActionType.coralL1:
              return "L1";
            case ActionType.coralL2:
              return "L2";
            case ActionType.coralL3:
              return "L3";
            case ActionType.coralL4:
              return "L4";
            case ActionType.dropped:
              return "Attempted Climb";
            case ActionType.usedOutpost:
              return "Used Outpost";
            case ActionType.usedBump:
              return "Used Bump";
            case ActionType.usedTrench:
              return "Used Trench";
            case ActionType.removeAlgae:
              return "Removed Algae";
            case ActionType.processorAlgae:
              return "Used Depot";
            case ActionType.processorAlgae:
              return "Processor Algae";
            case ActionType.netAlgae:
              return "Net Algae";
            case ActionType.Hub:
              return "Hub";
            default:
              return '';
          }
        })
        .where((s) => s.isNotEmpty)
        .toList()
        .join(', ');
  }

  void setPosition(Position position) {
    this.position = position;
    AppPreferences.saveScoutingPosition(position);
    notifyListeners();
  }

  void removeAutoAction() {
    if (autoActions.isNotEmpty) {
      autoActions.removeLast();
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
    this.notes = value;
    notifyListeners();
  }

  void _updateTeleopScore() {
    // Hub-based teleop points not implemented yet
    int teleopHubPoints = 0; // placeholder
    
    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.L1
            ? 10
            : endStatus == EndStatus.L2
                ? 20
                : 30;

    teleopScore = teleopHubPoints +
        endStatusPoints;
  }

  void removeTeleopAction() {
    if (teleopActions.isNotEmpty) {
      teleopActions.removeLast();
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

  void setAutoLeave(bool value) {
    autoLeave = value;
    notifyListeners();
  }

  void setRobotType(RobotType value) {
    robotType = value;
    notifyListeners();
  }
}
