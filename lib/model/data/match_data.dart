import 'package:cluck_scout/model/enums.dart';

class MatchData {
  // Round Specifications
  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto
  final int autoL1;
  final int autoL2;
  final int autoL3;
  final int autoHub;
  final int autoDropped;

  // Teleop
  final int teleopHub;
  final int teleopDropped;

  // Teleop Booleans
  final EndStatus endStatus;

  // Final Round Fields
  final Disabled disabled;
  final int defenseRank;
  final int drivingRank;
  final String notes;

  MatchData({
    required this.matchNumber,
    required this.teamNumber,
    required this.position,
    required this.scouterName,
    required this.autoL1,
    required this.autoL2,
    required this.autoL3,
    required this.autoHub,
    required this.autoDropped,
    required this.teleopHub,
    required this.teleopDropped,
    required this.endStatus,
    required this.disabled,
    required this.defenseRank,
    required this.drivingRank,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      // Round Specifications
      'match_number': matchNumber,
      'team_number': teamNumber,
      'position': position.toString().split('.').last,
      'scouter_name': scouterName,
      // Auto
      'auto_L1': autoL1,
      'auto_L2': autoL2,
      'auto_L3': autoL3,
      'auto_Hub': autoHub,
      'auto_dropped': autoDropped,
      // Teleop
      'teleop_Hub': teleopHub,
      'teleop_dropped': teleopDropped,
      // Endgame Booleans
      'end_none': endStatus == EndStatus.none ? 1 : 0,
      'end_L1': endStatus == EndStatus.L1 ? 1 : 0,
      'end_L2': endStatus == EndStatus.L2 ? 1 : 0,
      'end_L3': endStatus == EndStatus.L3 ? 1 : 0,
      // Final Field
      'disabled': disabled.toString().split(".").last,
      'defense_rank': defenseRank,
      'driving_rank': drivingRank,
      'notes': notes,
    };
  }

  factory MatchData.fromMap(Map<String, dynamic> map) {
    return MatchData(
      // Round Specifications
      matchNumber: map['match_number'],
      teamNumber: map['team_number'],
      position: Position.values
          .firstWhere((e) => e.toString().split('.').last == map['position']),
      scouterName: map['scouter_name'],
      // Auto
      autoL1: map['auto_L1'],
      autoL2: map['auto_L2'],
      autoL3: map['auto_L3'],
      autoHub: map['auto_Hub'],
      autoDropped: map['auto_dropped'],
      // Teleop
      teleopHub: map['teleop_Hub'],
      teleopDropped: map['teleop_dropped'],
      // Teleop Booleans
      endStatus: map['end_L1'] == 1
          ? EndStatus.endL1
          : map['end_L2'] == 1
              ? EndStatus.L2
              : map['end_L3'] == 1
                  ? EndStatus.L3
                  : EndStatus.none,
      // Final Field
      disabled: Disabled.values
          .firstWhere((e) => e.toString().split('.').last == map['disabled']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      notes: map['notes'],
    );
  }
}
