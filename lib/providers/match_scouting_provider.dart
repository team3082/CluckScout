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
  bool autoLeave;
  int autoScore;

  // Teleop Actions
  List<ActionType> teleopActions = List<ActionType>.empty(growable: true);
  int teleopScore;
  EndStatus endStatus;

  // Final Fields
  Disabled disabled;
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
    this.autoLeave = false,
    this.autoScore = 0,
    this.teleopScore = 0,
    this.endStatus = EndStatus.none,
    this.disabled = Disabled.None,
    this.defenseRank = 0,
    this.drivingRank = 0,
    this.notes = '',
    this.defenseTeamNumber = 0,
  });

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
      
      //count occurances of auto buttons
      autoL1climb: _countOccurrences(
        autoActions,
        ActionType.climbAutoL1,
      ),
      autoAttemptedClimb: _countOccurrences(
        teleopActions,
        ActionType.attemptedClimb,
      ), 
      autoUsedDepot: _countOccurrences(
        teleopActions,
        ActionType.usedDepot,
      ),
      autoUsedOutpost: _countOccurrences(
        teleopActions,
        ActionType.usedOutpost,
      ),
      autoBump: _countOccurrences(
        teleopActions,
        ActionType.bump,
      ),
      autoTrench: _countOccurrences(
        teleopActions,
        ActionType.trench,
      ),
      intialTime: _countOccurrences(
        autoActions,
        ActionType.timeIntial,
      ),
      finalTime: _countOccurrences(
        autoActions,
        ActionType.timeFinal,
      ),

      //count occurances of teleop actions
      teleopL1climb: _countOccurrences(
        teleopActions,
        ActionType.climbL1,
      ),
      teleopL2climb: _countOccurrences(
        teleopActions,
        ActionType.climbL2,
      ),
      teleopL3climb: _countOccurrences(
        teleopActions,
        ActionType.climbL3,
      ),
      teleopAttemptedClimb: _countOccurrences(
        teleopActions,
        ActionType.attemptedClimb,
      ),
      teleopUsedDepot: _countOccurrences(        
        teleopActions,
        ActionType.usedDepot,
      ),
      teleopUsedOutpost: _countOccurrences(
        teleopActions,
        ActionType.usedOutpost,
      ),
      teleopBump: _countOccurrences(
        teleopActions,
        ActionType.bump,
      ),
      teleopTrench: _countOccurrences(
        teleopActions,
        ActionType.trench,
      ),
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

  void _updateAutoScore() {
    int autoL1climb =
        _countOccurrences(autoActions, ActionType.climbAutoL1) * 3;
    int autoLeavePoints = autoLeave ? 3 : 0;

    autoScore = autoL1climb +
//shooting count 
        autoLeavePoints;
          }

  void resetFields() {
    matchNumber++;
    teamNumber = 0;

    autoActions.clear();
    autoLeave = false;
    autoScore = 0;

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

  void addTeleopAction(ActionType action) {
    teleopActions.add(action);
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
    return actionTypes
        .map((action) {
          switch ( action) {
           case ActionType.climbAutoL1:
              return "Auto L1 Climb";
            case ActionType.climbL1:
              return "L1 Climb";
            case ActionType.climbL2:
              return "L2 Climb";
            case ActionType.climbL3:
              return "L3 Climb";
            case ActionType.attemptedClimb:
              return "Attempted Climb";
            case ActionType.usedDepot:
              return "Used Depot";  
            case ActionType.usedOutpost:
              return "Used Outpost";
            case ActionType.bump:
              return "Bump";
            case ActionType.trench:
              return "Trench";
            case ActionType.timeIntial:
              return "";
            case ActionType.timeFinal:
              return "";
          }
        })
        .toList()
        .join(', ');
  }

  void setPosition(Position position) {
    this.position = position;
    AppPreferences.saveScoutingPosition(position);;
    notifyListeners();
  }

  void removeAutoAction() {
    if (autoActions.isNotEmpty) {
      autoActions.removeLast();
      _updateAutoScore();
      notifyListeners();
    }
  }

  void setAutoLeave(bool bool) {
    autoLeave = bool;
    _updateAutoScore();
    notifyListeners();
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
    int teleopL1climb =
        _countOccurrences(teleopActions, ActionType.climbL1) * 10;
    int teleopL2climb =
        _countOccurrences(teleopActions, ActionType.climbL2) * 20;
    int teleopL3climb =
        _countOccurrences(teleopActions, ActionType.climbL3) * 30;
    int teleopAttemptedClimb =
        _countOccurrences(teleopActions, ActionType.attemptedClimb) * 0;
    int teleopUsedDepot =
        _countOccurrences(teleopActions, ActionType.attemptedClimb) * 0;

    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.park
            ? 2
            : endStatus == EndStatus.shallowCage
                ? 6
                : 12;

    teleopScore = teleopL1climb +
        teleopL2climb +
        teleopL3climb +
        teleopAttemptedClimb +
        //shooting points
        teleopUsedDepot +
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
}
