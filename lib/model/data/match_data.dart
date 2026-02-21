// 

// References enums.dart (which stores info about what is included in types of actions, ways to be disabled...)
import 'package:cluck_scout/model/enums.dart';

class MatchData {
  // Declares the type of each variable (Ex. int)

  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto Coral
  final int autoL1climb;
  final int autoAttemptedClimb;
  final int intialTime;
  final int finalTime;

  // Auto Algae
  final int autoUsedDepot;
  final int autoUsedOutpost;
  final int autoBump;
  final int autoTrench;

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

  // Teleop Booleans
  // final EndStatus endStatus;

  // Final Round Fields
  final Disabled disabled;
  final int defenseRank;
  final int drivingRank;
  final String notes;

  // Requires that some value is passed along for each of the variables
  MatchData({
    required this.matchNumber,
    required this.teamNumber,
    required this.position,
    required this.scouterName,
    required this.autoL1climb,
    required this.autoAttemptedClimb,
    required this.autoUsedOutpost,
    required this.autoUsedDepot, 
    required this.autoBump,
    required this.autoTrench, 
    required this.intialTime,
    required this.finalTime,
    required this.teleopL1climb,
    required this.teleopL2climb,
    required this.teleopL3climb,
    required this.teleopAttemptedClimb,
    required this.teleopUsedDepot,
    required this.teleopUsedOutpost,
    required this.teleopBump,
    required this.teleopTrench,
    required this.disabled,
    required this.defenseRank,
    required this.drivingRank,
    required this.notes, 
  });

  Map<String, dynamic> toMap() {
    return {
      // Sets the values on the left (Ex. 'match_number') to the values on the right (Ex. matchNumber)
      'match_number': matchNumber,
      'team_number': teamNumber,
      'position': position.name, 
      'scouter_name': scouterName,
      // Auto Climb
      'auto_climb_L1': autoL1climb,
      'auto_attempted_climb': autoAttemptedClimb,
      // Auto Actions
      'auto_used_outpost': autoUsedOutpost,
      'auto_used_depot': autoUsedDepot,
      'auto_bump': autoBump,
      'auto_trench': autoTrench,
      // Teleop Climb
      'teleop_climb_L1': teleopL1climb,
      'teleop_climb_L2': teleopL2climb,
      'teleop_climb_L3': teleopL3climb,
      'teleop_attempted_climb': teleopAttemptedClimb,
      // Teleop Actions
      'teleop_Used_Depot': teleopUsedDepot,
      'teleop_Used_Outpost': teleopUsedOutpost,
      'teleop_bump': teleopBump,
      'teleop_trench': teleopTrench,
      // Teleop Booleans
      // Examples below
      // 'end_none': endStatus == EndStatus.none ? 1 : 0,
      // 'end_park': endStatus == EndStatus.park ? 1 : 0,
      // 'end_shallow': endStatus == EndStatus.shallowCage ? 1 : 0,
      // 'end_deep': endStatus == EndStatus.deepCage ? 1 : 0,
      // Final Fields
      'disabled': disabled.toString().split(".").last,
      'defense_rank': defenseRank,
      'driving_rank': drivingRank,
      'notes': notes,
    };
  }

  factory MatchData.fromMap(Map<String, dynamic> map) {
    return MatchData(
      matchNumber: map['match_number'],
      teamNumber: map['team_number'],
      position: Position.values.firstWhere((e) => e.name == map['position']),
      scouterName: map['scouter_name'],
      // Auto Climb
      autoL1climb: map['auto_climb_L1'],
      autoAttemptedClimb: map['auto_attempted_climbAttempted_Climb'],
      intialTime: map['intial_time'],
      finalTime: map['final_time'],
      // Auto Actions
      autoUsedOutpost: map['auto_Used_Outpost'],
      autoUsedDepot: map['auto_Used_Depot'],
      autoBump: map['auto_Bump'],
      autoTrench: map['auto_Trench'],
      // Teleop Climb
      teleopL1climb: map['teleop_L1_climb'],
      teleopL2climb: map['teleop_L2_climb'],
      teleopL3climb: map['teleop_L3_climb'],
      teleopAttemptedClimb: map['teleop_Attempted_Climb'],
      // Teleop Actions
      teleopUsedOutpost: map['teleop_Used_Outpost'],
      teleopUsedDepot: map['teleop_Used_Depot'],
      teleopBump: map['teleop_Bump'],
      teleopTrench: map['teleop_Trench'],
      // Teleop Booleans
      // Example of boolean code
      // endStatus: map['end_deep'] == 1
      //     ? EndStatus.deepCage
      //     : map['end_shallow'] == 1
      //         ? EndStatus.shallowCage
      //         : map['end_park'] == 1
      //             ? EndStatus.park
      //             : EndStatus.none,
      // Final Fields
      disabled: Disabled.values
          .firstWhere((e) => e.toString().split('.').last == map['disabled']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      notes: map['notes'],
    );
  }
}
