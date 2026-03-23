import 'dart:convert';
import 'package:cluck_scout/model/enums.dart';

class MatchData {
  // Round Specifications
  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto Coral
  final int autoL1climb;
  final int autoAttemptedClimb;

  // Auto Algae
  final int autoUsedDepot;
  final int autoUsedOutpost;
  final int autoBump;
  final int autoTrench;

  // Auto Hub Shooting
  final List<double> autoShootingTimes;

  // Auto Booleans
  final bool autoLeave;

  // Teleop Coral
  final int teleopL1climb;
  final int teleopL2climb;
  final int teleopL3climb;
  final int teleopAttemptedClimb;

  // Teleop Algae
  final int teleopUsedDepot;
  final int teleopUsedOutpost;
  final int teleopBump;
  final int teleopTrench;
  
  // Teleop Hub Shooting
  final List<double> teleopShootingTimes;

  // Teleop Booleans
  final EndStatus endNone;
  final EndStatus endClimb;
  final EndStatus endShooting;

  // Final Round Fields
  final Disabled disabled;
  final int defenseRank;
  final int drivingRank;
  final int accuracyRank;
  final bool noShooting;
  final String fuelPerSecond;
  final String notes;

  MatchData({
    required this.matchNumber,
    required this.teamNumber,
    required this.position,
    required this.scouterName,
    required this.autoL1climb,
    required this.autoAttemptedClimb,
    required this.autoUsedDepot,
    required this.autoUsedOutpost,
    required this.autoBump,
    required this.autoTrench,
    required this.autoShootingTimes,
    required this.autoLeave,
    required this.teleopL1climb,
    required this.teleopL2climb,
    required this.teleopL3climb,
    required this.teleopAttemptedClimb,
    required this.teleopUsedDepot,
    required this.teleopUsedOutpost,
    required this.teleopBump,
    required this.teleopTrench,
    required this.teleopShootingTimes,
    required this.endNone,  
    required this.endClimb,  
    required this.endShooting,
    required this.disabled,
    required this.defenseRank,
    required this.drivingRank,
    required this.accuracyRank,
    required this.noShooting,
    required this.fuelPerSecond,
    required this.notes, 
  });

  Map<String, dynamic> toMap() {
    return {
      // Round Specifications
      'match_number': matchNumber,
      'team_number': teamNumber,
      'position': position.toString().split('.').last,
      'scouter_name': scouterName,
      // Auto Coral
      'auto_L1_climb': autoL1climb,
      'auto_attempted_climb': autoAttemptedClimb,
      // Auto Algae
      'auto_used_depot': autoUsedDepot,
      'auto_used_outpost': autoUsedOutpost,
      'auto_bump': autoBump,
      'auto_trench': autoTrench,
      // Auto Hub Shooting
      'auto_shooting_times': jsonEncode(autoShootingTimes),
      // Auto Booleans
      'auto_leave': autoLeave ? 1 : 0,
      // Teleop Coral
      'teleop_L1_climb': teleopL1climb,
      'teleop_L2_climb': teleopL2climb,
      'teleop_L3_climb': teleopL3climb,
      'teleop_attempted_climb': teleopAttemptedClimb,
      // Teleop Algae
      'teleop_used_depot': teleopUsedDepot,
      'teleop_used_outpost': teleopUsedOutpost,
      'teleop_bump': teleopBump,
      'teleop_trench': teleopTrench,
      // Teleop Hub Shooting
      'teleop_shooting_times': jsonEncode(teleopShootingTimes),
      // Teleop Booleans
      'end_none': endNone == EndStatus.none ? 1 : 0,
      'end_climb': endClimb == EndStatus.climb ? 1 : 0,
      'end_shooting': endShooting == EndStatus.shooting ? 1 : 0,
      // Final Fields
      'disabled': disabled.toString().split(".").last,
      'defense_rank': defenseRank,
      'driving_rank': drivingRank,
      'accuracy_rank': accuracyRank,
      'no_shooting': noShooting,
      'fuel_per_second': fuelPerSecond,
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
      // Auto Coral
      autoL1climb: map['auto_L1_climb'] ?? 0,
      autoAttemptedClimb: map['auto_attempted_climb'] ?? 0,
      // Auto Algae
      autoUsedDepot: map['auto_used_depot'] ?? 0,
      autoUsedOutpost: map['auto_used_outpost'] ?? 0,
      autoBump: map['auto_bump'] ?? 0,
      autoTrench: map['auto_trench'] ?? 0,
      // Auto Hub Shooting
      autoShootingTimes: map['auto_shooting_times'] != null 
          ? List<double>.from(jsonDecode(map['auto_shooting_times']))
          : [],
      // Auto Booleans
      autoLeave: map['auto_leave'] == 1,
      // Teleop Coral
      teleopL1climb: map['teleop_L1_climb'] ?? 0,
      teleopL2climb: map['teleop_L2_climb'] ?? 0,
      teleopL3climb: map['teleop_L3_climb'] ?? 0,
      teleopAttemptedClimb: map['teleop_attempted_climb'] ?? 0,
      // Teleop Algae
      teleopUsedDepot: map['teleop_used_depot'] ?? 0,
      teleopUsedOutpost: map['teleop_used_outpost'] ?? 0,
      teleopBump: map['teleop_bump'] ?? 0,
      teleopTrench: map['teleop_trench'] ?? 0,
      // Teleop Hub Shooting
      teleopShootingTimes: map['teleop_shooting_times'] != null
          ? List<double>.from(jsonDecode(map['teleop_shooting_times']))
          : [],
      // Teleop Booleans
      endNone: map['end_none'] == 1 ? EndStatus.none : EndStatus.none,
      endClimb: map['end_climb'] == 1 ? EndStatus.climb : EndStatus.climb,
      endShooting: map['end_shooting'] == 1 ? EndStatus.shooting : EndStatus.shooting,
      // Final Fields
      disabled: Disabled.values
          .firstWhere((e) => e.toString().split('.').last == map['disabled']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      accuracyRank: map['accuracy_rank'],
      noShooting: map['no_shooting'],
      fuelPerSecond: map['fuel_per_second'],
      notes: map['notes'],
    );
  }
}
