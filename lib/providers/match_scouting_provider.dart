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
      autoL1climb: _countOccurrences(
        autoActions,
        ActionType.L1climb,
      ),
      autoAttemptedClimb: _countOccurrences(
        autoActions,
        ActionType.attemptedClimb,
      ),
      autoUsedDepot: _countOccurrences(
        autoActions,
        ActionType.usedDepot,
      ),
      autoUsedOutpost: _countOccurrences(
        autoActions,
        ActionType.usedOutpost,
      ),
      autoBump: _countOccurrences(
        autoActions,
        ActionType.bump,
      ),
      autoTrench: _countOccurrences(
        autoActions,
        ActionType.trench,
      ),
      autoShootingTimes: _extractShootingTimes(autoActions, autoActionTimes),
      autoLeave: autoLeave,
      teleopL1climb: _countOccurrences(
        teleopActions,
        ActionType.L1climb,
      ),
      teleopL2climb: _countOccurrences(
        teleopActions,
        ActionType.L2climb,
      ),
      teleopL3climb: _countOccurrences(
        teleopActions,
        ActionType.L3climb,
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
      teleopShootingTimes: _extractShootingTimes(teleopActions, teleopActionTimes),
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

  List<double> _extractShootingTimes(List<ActionType> actions, List<double?> times) {
    List<double> shootingTimes = [];
    for (int i = 0; i < actions.length; i++) {
      if (actions[i] == ActionType.hubShooting && times[i] != null) {
        shootingTimes.add(times[i]!);
      }
    }
    return shootingTimes;
  }

  void _updateAutoScore() {
    int autoL1climbPoints =
        _countOccurrences(autoActions, ActionType.L1climb) * 3;
    int autoUsedDepotPoints =
        _countOccurrences(autoActions, ActionType.usedDepot) * 4;
    int autoUsedOutpostPoints =
        _countOccurrences(autoActions, ActionType.usedOutpost) * 6;
    int autoBumpPoints =
        _countOccurrences(autoActions, ActionType.bump) * 2;
    int autoTrenchPoints =
        _countOccurrences(autoActions, ActionType.trench) * 2;
    int autoLeavePoints = autoLeave ? 3 : 0;

    autoScore = autoL1climbPoints +
        autoUsedDepotPoints +
        autoUsedOutpostPoints +
        autoBumpPoints +
        autoTrenchPoints +
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
      case ActionType.L1climb:
        return "L1 Climb";
      case ActionType.L2climb:
        return "L2 Climb";
      case ActionType.L3climb:
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
      case ActionType.hubShooting:
        return "Hub Shooting";
    }
  }

  String _getActionString(List<ActionType> actionTypes) {
    return actionTypes
        .map((action) {
          switch (action) {
            case ActionType.L1climb:
              return "L1 Climb";
            case ActionType.L2climb:
              return "L2 Climb";
            case ActionType.L3climb:
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
    int teleopL1climbPoints =
        _countOccurrences(teleopActions, ActionType.L1climb) * 2;
    int teleopL2climbPoints =
        _countOccurrences(teleopActions, ActionType.L2climb) * 3;
    int teleopL3climbPoints =
        _countOccurrences(teleopActions, ActionType.L3climb) * 4;
    int teleopUsedDepotPoints =
        _countOccurrences(teleopActions, ActionType.usedDepot) * 4;
    int teleopUsedOutpostPoints =
        _countOccurrences(teleopActions, ActionType.usedOutpost) * 6;
    int teleopBumpPoints =
        _countOccurrences(teleopActions, ActionType.bump) * 2;
    int teleopTrenchPoints =
        _countOccurrences(teleopActions, ActionType.trench) * 2;

    int endStatusPoints = endStatus == EndStatus.none
        ? 0
        : endStatus == EndStatus.park
            ? 2
            : endStatus == EndStatus.shallowCage
                ? 6
                : 12;

    teleopScore = teleopL1climbPoints +
        teleopL2climbPoints +
        teleopL3climbPoints +
        teleopUsedDepotPoints +
        teleopUsedOutpostPoints +
        teleopBumpPoints +
        teleopTrenchPoints +
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
