import 'package:cluck_scout/model/enums.dart';

class MatchData {
  // Round Specifications
  final int matchNumber;
  final int teamNumber;
  final Position position;
  final String scouterName;

  // Auto Coral
  final int autoL1;
  final int autoCoralL2;
  final int autoCoralL3;
  final int autoCoralL4;
  final int autoDropped;

  // Auto Algae
  final int autoNetAlgae;
  final int autoProcessorAlgae;
  final int autoAlgaeRemoved;

  // Auto Booleans
  final bool autoLeave;

  // Teleop Coral
  final int teleopCoralL1;
  final int teleopCoralL2;
  final int teleopCoralL3;
  final int teleopCoralL4;
  final int teleopDropped;

  // Teleop Algae
  final int teleopProcessorAlgae;
  final int teleopNetAlgae;
  final int teleopAlgaeRemoved;

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
    required this.autoCoralL1,
    required this.autoCoralL2,
    required this.autoCoralL3,
    required this.autoCoralL4,
    required this.autoDropped,
    required this.autoNetAlgae,
    required this.autoProcessorAlgae,
    required this.autoAlgaeRemoved,
    required this.autoLeave,
    required this.teleopCoralL1,
    required this.teleopCoralL2,
    required this.teleopCoralL3,
    required this.teleopCoralL4,
    required this.teleopDropped,
    required this.teleopNetAlgae,
    required this.teleopProcessorAlgae,
    required this.teleopAlgaeRemoved,
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
      // Auto Coral
      'auto_coral_L1': autoCoralL1,
      'auto_coral_L2': autoCoralL2,
      'auto_coral_L3': autoCoralL3,
      'auto_coral_L4': autoCoralL4,
      'auto_dropped': autoDropped,
      // Auto Algae
      'auto_net_algae': autoNetAlgae,
      'auto_processor_algae': autoProcessorAlgae,
      'auto_algae_removed': autoAlgaeRemoved,
      // Auto Booleans
      'auto_leave': autoLeave ? 1 : 0,
      // Teleop Coral
      'teleop_coral_L1': teleopCoralL1,
      'teleop_coral_L2': teleopCoralL2,
      'teleop_coral_L3': teleopCoralL3,
      'teleop_coral_L4': teleopCoralL4,
      'teleop_dropped': teleopDropped,
      // Teleop Algae
      'teleop_processor_algae': teleopProcessorAlgae,
      'teleop_net_algae': teleopNetAlgae,
      'teleop_algae_removed': teleopAlgaeRemoved,
      // Teleop Booleans
      'end_none': endStatus == EndStatus.none ? 1 : 0,
      'end_park': endStatus == EndStatus.park ? 1 : 0,
      'end_shallow': endStatus == EndStatus.shallowCage ? 1 : 0,
      'end_deep': endStatus == EndStatus.deepCage ? 1 : 0,
      // Final Fields
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
      // Auto Coral
      autoCoralL1: map['auto_coral_L1'],
      autoCoralL2: map['auto_coral_L2'],
      autoCoralL3: map['auto_coral_L3'],
      autoCoralL4: map['auto_coral_L4'],
      autoDropped: map['auto_dropped'],
      // Auto Algae
      autoNetAlgae: map['auto_net_algae'],
      autoProcessorAlgae: map['auto_processor_algae'],
      autoAlgaeRemoved: map['auto_algae_removed'],
      // Auto Booleans
      autoLeave: map['auto_leave'] == 1,
      // Teleop Coral
      teleopCoralL1: map['teleop_coral_L1'],
      teleopCoralL2: map['teleop_coral_L2'],
      teleopCoralL3: map['teleop_coral_L3'],
      teleopCoralL4: map['teleop_coral_L4'],
      teleopDropped: map['teleop_dropped'],
      // Teleop Algae
      teleopNetAlgae: map['teleop_net_algae'],
      teleopProcessorAlgae: map['teleop_processor_algae'],
      teleopAlgaeRemoved: map['teleop_algae_removed'],
      // Teleop Booleans
      endStatus: map['end_deep'] == 1
          ? EndStatus.deepCage
          : map['end_shallow'] == 1
              ? EndStatus.shallowCage
              : map['end_park'] == 1
                  ? EndStatus.park
                  : EndStatus.none,
      // Final Fields
      disabled: Disabled.values
          .firstWhere((e) => e.toString().split('.').last == map['disabled']),
      defenseRank: map['defense_rank'],
      drivingRank: map['driving_rank'],
      notes: map['notes'],
    );
  }
}
