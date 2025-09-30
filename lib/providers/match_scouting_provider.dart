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
      autoCoralL1: _countOccurrences(
        autoActions,
        ActionType.coralL1,
      ),
      autoCoralL2: _countOccurrences(
        autoActions,
        ActionType.coralL2,
      ),
      autoCoralL3: _countOccurrences(
        autoActions,
        ActionType.coralL3,
      ),
      autoCoralL4: _countOccurrences(
        autoActions,
        ActionType.coralL4,
      ),
      autoDropped: _countOccurrences(
        autoActions,
        ActionType.dropped,
      ),
      autoNetAlgae: _countOccurrences(
        autoActions,
        ActionType.netAlgae,
      ),
      autoAlgaeRemoved: _countOccurrences(
        autoActions,
        ActionType.removeAlgae,
      ),
      autoProcessorAlgae: _countOccurrences(
        autoActions,
        ActionType.processorAlgae,
      ),
      autoLeave: autoLeave,
      teleopCoralL1: _countOccurrences(
        teleopActions,
        ActionType.coralL1,
      ),
      teleopCoralL2: _countOccurrences(
        teleopActions,
        ActionType.coralL2,
      ),
      teleopCoralL3: _countOccurrences(
        teleopActions,
        ActionType.coralL3,
      ),
      teleopCoralL4: _countOccurrences(
        teleopActions,
        ActionType.coralL4,
      ),
      teleopDropped: _countOccurrences(
        teleopActions,
        ActionType.dropped,
      ),
      teleopNetAlgae: _countOccurrences(
        teleopActions,
        ActionType.netAlgae,
      ),
      teleopProcessorAlgae: _countOccurrences(
        teleopActions,
        ActionType.processorAlgae,
      ),
      teleopAlgaeRemoved: _countOccurrences(
        teleopActions,
        ActionType.removeAlgae,
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
    int autoCoralL1Points =
        _countOccurrences(autoActions, ActionType.coralL1) * 3;
    int autoCoralL2Points =
        _countOccurrences(autoActions, ActionType.coralL2) * 4;
    int autoCoralL3Points =
        _countOccurrences(autoActions, ActionType.coralL3) * 6;
    int autoCoralL4Points =
        _countOccurrences(autoActions, ActionType.coralL4) * 7;
    int autoNetAlgaePoints =
        _countOccurrences(autoActions, ActionType.netAlgae) * 4;
    int autoProcessorAlgaePoints =
        _countOccurrences(autoActions, ActionType.processorAlgae) * 6;
    int autoLeavePoints = autoLeave ? 3 : 0;

    autoScore = autoCoralL1Points +
        autoCoralL2Points +
        autoCoralL3Points +
        autoCoralL4Points +
        autoNetAlgaePoints +
        autoProcessorAlgaePoints +
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
          switch (action) {
            case ActionType.coralL1:
              return "Coral L1";
            case ActionType.coralL2:
              return "Coral L2";
            case ActionType.coralL3:
              return "Coral L3";
            case ActionType.coralL4:
              return "Coral L4";
            case ActionType.dropped:
              return "Dropped";
            case ActionType.netAlgae:
              return "Net Algae";
            case ActionType.processorAlgae:
              return "Processor Algae";
            case ActionType.removeAlgae:
              return "Removed Algae";
          }
        })
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
    this.notes = value;
    notifyListeners();
  }

  void _updateTeleopScore() {
    int teleopCoralL1Points =
        _countOccurrences(teleopActions, ActionType.coralL1) * 2;
    int teleopCoralL2Points =
        _countOccurrences(teleopActions, ActionType.coralL2) * 3;
    int teleopCoralL3Points =
        _countOccurrences(teleopActions, ActionType.coralL3) * 4;
    int teleopCoralL4Points =
        _countOccurrences(teleopActions, ActionType.coralL4) * 5;
    int teleopNetAlgaePoints =
        _countOccurrences(teleopActions, ActionType.netAlgae) * 4;
    int teleopProcessorAlgaePoints =
        _countOccurrences(teleopActions, ActionType.processorAlgae) * 6;

    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.park
            ? 2
            : endStatus == EndStatus.shallowCage
                ? 6
                : 12;

    teleopScore = teleopCoralL1Points +
        teleopCoralL2Points +
        teleopCoralL3Points +
        teleopCoralL4Points +
        teleopNetAlgaePoints +
        teleopProcessorAlgaePoints +
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
