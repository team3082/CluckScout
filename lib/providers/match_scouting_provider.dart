import 'dart:async';
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
  List<double?> autoActionTimes = List<double?>.empty(growable: true);
  bool autoLeave;
  int autoScore;

  // Teleop Actions
  List<ActionType> teleopActions = List<ActionType>.empty(growable: true);
  List<double?> teleopActionTimes = List<double?>.empty(growable: true);
  int teleopScore;
  EndStatus endStatus;

  // Final Fields
  Disabled disabled;
  int defenseRank;
  int drivingRank;
  int defenseTeamNumber;
  String notes;

  // Auto Hub Shooting Fields
  Timer? autoTicker;
  bool autoHubShooting = false;
  DateTime autoLastTime = DateTime.now();

  // Teleop Hub Shooting Fields
  Timer? teleopTicker;
  bool teleopHubShooting = false;
  DateTime teleopLastTime = DateTime.now();

  /// current auto hub shooting time to display (includes running segment)
  double get autoDisplayedTime {
    if (autoHubShooting) {
      final elapsed =
          DateTime.now().difference(autoLastTime).inMilliseconds / 1000;
      return elapsed;
    }
    return 0.0;
  }

  /// current teleop hub shooting time to display (includes running segment)
  double get teleopDisplayedTime {
    if (teleopHubShooting) {
      final elapsed =
          DateTime.now().difference(teleopLastTime).inMilliseconds / 1000;
      return elapsed;
    }
    return 0.0;
  }

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
      autoHubShootingTime: _calculateHubShootingTime(autoActions, autoActionTimes),
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
      teleopHubShootingTime: _calculateHubShootingTime(teleopActions, teleopActionTimes),
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

  double _calculateHubShootingTime(List<ActionType> actions, List<double?> times) {
    double total = 0;
    for (int i = 0; i < actions.length; i++) {
      if (actions[i] == ActionType.hubShooting && times[i] != null) {
        total += times[i]!;
      }
    }
    return total;
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
    autoActionTimes.clear();
    autoLeave = false;
    autoScore = 0;
    
    // Reset auto hub shooting
    autoTicker?.cancel();
    autoHubShooting = false;

    teleopActions.clear();
    teleopActionTimes.clear();
    endStatus = EndStatus.none;
    teleopScore = 0;
    
    // Reset teleop hub shooting
    teleopTicker?.cancel();
    teleopHubShooting = false;

    disabled = Disabled.None;
    defenseRank = 0;
    drivingRank = 5;
    notes = '';
  }

  void addAutoAction(ActionType action, [double? time]) {
    autoActions.add(action);
    autoActionTimes.add(time);
    _updateAutoScore();
    notifyListeners();
  }

  void addTeleopAction(ActionType action, [double? time]) {
    teleopActions.add(action);
    teleopActionTimes.add(time);
    _updateTeleopScore();
    notifyListeners();
  }

  String getAutoActionString() {
    return _getActionString(autoActions);
  }

  String getTeleopActionString() {
    return _getActionString(teleopActions);
  }

  String getAutoActionWithHubString() {
    List<String> items = [];
    for (int i = 0; i < autoActions.length; i++) {
      if (autoActions[i] == ActionType.hubShooting && autoActionTimes[i] != null) {
        items.add("Hub ${autoActionTimes[i]!.toStringAsFixed(1)}s");
      } else {
        items.add(_getActionName(autoActions[i]));
      }
    }
    return items.join(', ');
  }

  String getTeleopActionWithHubString() {
    List<String> items = [];
    for (int i = 0; i < teleopActions.length; i++) {
      if (teleopActions[i] == ActionType.hubShooting && teleopActionTimes[i] != null) {
        items.add("Hub ${teleopActionTimes[i]!.toStringAsFixed(1)}s");
      } else {
        items.add(_getActionName(teleopActions[i]));
      }
    }
    return items.join(', ');
  }

  String _getActionName(ActionType action) {
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
      case ActionType.hubShooting:
        return "Hub Shooting";
    }
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
            case ActionType.hubShooting:
              return "Hub Shooting";
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
      autoActionTimes.removeLast();
      _updateAutoScore();
      notifyListeners();
    }
  }

  // Tracks deleted actions for undo
  List<ActionType> _deletedAutoActions = [];
  List<double?> _deletedAutoActionTimes = [];

  void removeLastAutoItem() {
    if (autoActions.isNotEmpty) {
      _deletedAutoActions.add(autoActions.removeLast());
      _deletedAutoActionTimes.add(autoActionTimes.removeLast());
      _updateAutoScore();
      notifyListeners();
    }
  }

  void undoLastAutoDelete() {
    if (_deletedAutoActions.isNotEmpty) {
      autoActions.add(_deletedAutoActions.removeLast());
      autoActionTimes.add(_deletedAutoActionTimes.removeLast());
      _updateAutoScore();
      notifyListeners();
    }
  }

  bool get hasAutoDeletedItems => _deletedAutoActions.isNotEmpty;

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
      teleopActionTimes.removeLast();
      _updateTeleopScore();
      notifyListeners();
    }
  }

  // Tracks deleted actions for undo
  List<ActionType> _deletedTeleopActions = [];
  List<double?> _deletedTeleopActionTimes = [];

  void removeLastTeleopItem() {
    if (teleopActions.isNotEmpty) {
      _deletedTeleopActions.add(teleopActions.removeLast());
      _deletedTeleopActionTimes.add(teleopActionTimes.removeLast());
      _updateTeleopScore();
      notifyListeners();
    }
  }

  void undoLastTeleopDelete() {
    if (_deletedTeleopActions.isNotEmpty) {
      teleopActions.add(_deletedTeleopActions.removeLast());
      teleopActionTimes.add(_deletedTeleopActionTimes.removeLast());
      _updateTeleopScore();
      notifyListeners();
    }
  }

  bool get hasTeleopDeletedItems => _deletedTeleopActions.isNotEmpty;

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

  @override
  void dispose() {
    autoTicker?.cancel();
    teleopTicker?.cancel();
    super.dispose();
  }

  // Auto Hub Shooting Controls
  void toggleAutoHubShooting() {
    if (autoHubShooting) {
      // stopping - add the hub shooting action with elapsed time
      autoHubShooting = false;
      autoTicker?.cancel();
      final elapsedTime = DateTime.now().difference(autoLastTime);
      final sessionTime = elapsedTime.inMilliseconds / 1000;
      addAutoAction(ActionType.hubShooting, sessionTime);
      _deletedAutoActions.clear(); // Clear undo when completing a new session
      _deletedAutoActionTimes.clear();
    } else {
      // starting
      autoHubShooting = true;
      autoLastTime = DateTime.now();
      autoTicker = Timer.periodic(const Duration(milliseconds: 100), (_) {
        notifyListeners();
      });
    }
    notifyListeners();
  }

  // Teleop Hub Shooting Controls
  void toggleTeleopHubShooting() {
    if (teleopHubShooting) {
      // stopping - add the hub shooting action with elapsed time
      teleopHubShooting = false;
      teleopTicker?.cancel();
      final elapsedTime = DateTime.now().difference(teleopLastTime);
      final sessionTime = elapsedTime.inMilliseconds / 1000;
      addTeleopAction(ActionType.hubShooting, sessionTime);
      _deletedTeleopActions.clear(); // Clear undo when completing a new session
      _deletedTeleopActionTimes.clear();
    } else {
      // starting
      teleopHubShooting = true;
      teleopLastTime = DateTime.now();
      teleopTicker = Timer.periodic(const Duration(milliseconds: 100), (_) {
        notifyListeners();
      });
    }
    notifyListeners();
  }
}
