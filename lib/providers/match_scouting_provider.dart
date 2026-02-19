// 

//import 'package:cluck_scout/screens/scouting_screen/match_screen/screens/auto_screen.dart';
// Library of basic UI functions and other basics (Not specific to 3082)
import 'package:flutter/material.dart';
// For sharing data between files and other basics (Not specific to 3082)
import 'package:cluck_scout/model/app_preferences.dart';
// References enums.dart where subcatagories of things like actionType are defined
import 'package:cluck_scout/model/enums.dart';
// 
import 'package:cluck_scout/model/data/match_data.dart';
// Stores data as a CSV to later be analized
import 'package:cluck_scout/services/database_service.dart';
int counter =0;
double duration = 0;
int page = 0; // 0 will be auto and 1 teleop

class MatchScoutingProvider extends ChangeNotifier {
  // Declares the type of each variable (Ex. int)
  
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
  List<int> autoHubTimeStamp;
  double autoHub;
  int autoBump;
  int autoTrench;

  // Teleop Actions
  List<ActionType> teleopActions;
  int teleopScore;
  // store durations (seconds) for each hub visit during teleop
  List<double> teleopHubDurations;
  List<int> teleopHubTimeStamp;
  EndStatus endStatus;
  double teleopHub;
  int teleopBump;
  int teleopTrench;

  // Final Fields
  Disabled disabled;
  RobotGoal robotGoal;
  int defenseRank;
  int drivingRank;
  int defenseTeamNumber;
  String notes;

  // Requires that some value is passed along for each of the variables or sets it to a starting value
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
    this.autoBump = 0,
    this.autoTrench = 0,
    this.teleopBump = 0,
    this.teleopTrench = 0,
    this.autoHub = 0.0,
    this.teleopHub = 0.0,
    List<double>? autoHubDurations,
    List<double>? teleopHubDurations,
    List<int>? autoHubTimeStamp,
    List<int>? teleopHubTimeStamp,
  })  : autoActions = autoActions ?? <ActionType>[],
        teleopActions = teleopActions ?? <ActionType>[],
        autoHubDurations = autoHubDurations ?? <double>[],
        autoHubTimeStamp = autoHubTimeStamp ?? <int>[],
        teleopHubTimeStamp = teleopHubTimeStamp ?? <int>[],
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
      autoHub: autoHub,
      teleopHub: teleopHub,
      autoBump: autoBump,
      autoTrench: autoTrench,
      teleopBump: teleopBump,
      teleopTrench: teleopTrench,
      autoHubDurations: autoHubDurations,
      autoHubTimeStamp: autoHubTimeStamp,
      teleopHubDurations: teleopHubDurations,
      teleopHubTimeStamp: teleopHubTimeStamp,
      endStatus: endStatus,
      disabled: disabled,
      robotGoal: robotGoal,
      defenseRank: defenseRank,
      drivingRank: drivingRank,
      notes: notes,
    );
  }

  // Calculates Auto Score
  void _updateAutoScore() {
    
    // Gets points from auto climb (using: if, else if, else)
    int autoStatusPoints = autoStatus == AutoStatus.none
        ? 0
        : 15;
        /*: endStatus == AutoStatus.L1
            ? 15
            : endStatus == AutoStatus.L2
                ? 15
                : 15;*/

    // Adds up the time scoring and converts to points (example: 5 points per second)
    //final double autoHubTotal = autoHubDurations.fold(0.0, (sum, item) => sum + item);
    autoHub = autoHubDurations.fold(0.0, (sum, item) => sum + item);
    int autoHubPoints = (autoHub* 5).toInt();

    // Auto score is points from climbing + points from hub
    autoScore = autoStatusPoints + autoHubPoints;
  }

// Adds 1 to the match number and clears all the starting values on the scouting app
  void resetFields() {
    matchNumber++;
    teamNumber = 0;

    autoActions.clear();
    autoHubDurations.clear();
    autoStatus = AutoStatus.none;
    autoScore = 0;

    teleopActions.clear();
    teleopHubDurations.clear();
    endStatus = EndStatus.none;
    teleopScore = 0;

    disabled = Disabled.None;
    robotGoal = RobotGoal.other;
    defenseRank = 0;
    drivingRank = 5;
    notes = '';
  }

  void addAutoAction(ActionType action) {
    
    // Check if the action is a Hub action, then add the timestamp here
    if (action == ActionType.Hub) {
      autoHubTimeStamp.add(DateTime.now().millisecondsSinceEpoch);
      if (page != 0){
        counter = 2;
      }
      page = 0;
      counter ++;
      if (autoHubTimeStamp.length >= 2){
        if (counter %2 ==0){
          removeAutoAction();
          notifyListeners();
          duration = (autoHubTimeStamp[autoHubTimeStamp.length-1]-autoHubTimeStamp[autoHubTimeStamp.length-2])/1000;
          autoHubDurations.add(duration);
        }  
      }
    }
    autoActions.add(action);
    notifyListeners();
  }

  void addTeleopAction(ActionType action) {
    
    // Check if the action is a Hub action, then add the timestamp here
    if (action == ActionType.Hub) {
      teleopHubTimeStamp.add(DateTime.now().millisecondsSinceEpoch);
      if (page != 1){
        counter = 2;
      }
      page = 1;
      counter ++;
      if (teleopHubTimeStamp.length >= 2){
        if (counter %2 ==0){
          removeTeleopAction();
          notifyListeners();
          duration = (teleopHubTimeStamp[teleopHubTimeStamp.length-1]-teleopHubTimeStamp[teleopHubTimeStamp.length-2])/1000;
          teleopHubDurations.add(duration);
        } 
      }
    }
    teleopActions.add(action);
    notifyListeners();
  }

  void setAutoStatus(AutoStatus autoStatus) {
    this.autoStatus = autoStatus;
    _updateAutoScore();
    notifyListeners();
  }

  String getAutoActionString() {
    return _getActionString(autoActions);
  }

  String getTeleopActionString() {
    return _getActionString(teleopActions);
  }
  
  // When the corresponding button is clicked, updates the list of actions that shows up on the right in the scouting app
  String _getActionString(List<ActionType> actionTypes) {
    return actionTypes.map((action) {
      switch (action) {
        case ActionType.Hub:
          if (counter % 2 == 0){
            if (page == 0){
              return autoHubDurations;
            } else {
              return teleopHubDurations;
            }
          } else {
            return "Start Shooting";
          }
        case ActionType.L1:
        case ActionType.L2:
        case ActionType.L3:
        case ActionType.Bump:
          return "Bump";
        case ActionType.Trench:
          return "Trench";
      }
    }).toList().join(', ');
  }

  void setPosition(Position position) {
    this.position = position;
    AppPreferences.saveScoutingPosition(position);
    notifyListeners();
  }

  void removeAutoAction() {
    page = 0;
    if (autoActions.isNotEmpty) {
      if (autoActions[autoActions.length-1] == ActionType.Hub){
        //autoHubDurations.removeLast();
      }
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
    notes = value;
    notifyListeners();
  }

  void _updateTeleopScore() {
    final double teleopHubTotal = teleopHubDurations.fold(0.0, (sum, item) => sum + item);
    int teleopHubPoints = (teleopHubTotal * 5).toInt();

    // Gets points from end game climb (using: if, else if, else)
    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.L1
            ? 10
            : endStatus == EndStatus.L2
                ? 20
                : 30;

    // Teleop score is points from climbing + points from hub
    teleopScore = teleopHubPoints + endStatusPoints;
  }

  void removeTeleopAction() {
    page = 1;
    if (teleopActions.isNotEmpty) {
      //if (_getActionString(autoActions)[_getActionString(autoActions).length-1] == ActionType.Hub){
        //teleopHubDurations.removeLast();
      //}
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
