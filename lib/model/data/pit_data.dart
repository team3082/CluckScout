import 'package:cluck_scout/model/enums.dart';

class PitData {
  // Scout Specifications
  final int teamNumber;
  final String scouterName;

  // Drivetrain Specifications
  final Drivetrain drivetrain;

  // Abilities
  final int coralL1;
  final int coralL2;
  final int coralL3;
  final int coralL4;

  final int removeAlgae;
  final int processorAlgae;
  final int netAlgae;

  // Preferred Coral
  final int prefersCoral;
  final int preferredCoralLevel;

  // End status
  final int park;
  final int shallowClimb;
  final int deepClimb;

  // Preferred Starting Zone and End Status
  final StartingZone preferredStartingZone;
  final EndStatus preferredEndStatus;

  final String notes;

  // Constructor
  PitData({
    required this.teamNumber,
    required this.scouterName,
    required this.drivetrain,
    required this.coralL1,
    required this.coralL2,
    required this.coralL3,
    required this.coralL4,
    required this.removeAlgae,
    required this.processorAlgae,
    required this.netAlgae,
    required this.prefersCoral,
    required this.preferredCoralLevel,
    required this.park,
    required this.shallowClimb,
    required this.deepClimb,
    required this.preferredStartingZone,
    required this.preferredEndStatus,
    required this.notes,
  });

  // Convert PitData to Map
  Map<String, dynamic> toMap() {
    return {
      'team_number': teamNumber,
      'scouter_name': scouterName,
      'drivetrain': drivetrain.toString().split('.').last,
      'coral_L1': coralL1,
      'coral_L2': coralL2,
      'coral_L3': coralL3,
      'coral_L4': coralL4,
      'remove_algae': removeAlgae,
      'processor_algae': processorAlgae,
      'net_algae': netAlgae,
      'prefers_coral': prefersCoral,
      'preferred_coral_level': preferredCoralLevel,
      'park': park,
      'shallow_climb': shallowClimb,
      'deep_climb': deepClimb,
      'preferred_starting_zone':
          preferredStartingZone.toString().split('.').last,
      'preferred_end_status': preferredEndStatus.toString().split('.').last,
      'notes': notes,
    };
  }

  // Convert Map to PitData
  static PitData fromMap(Map<String, dynamic> map) {
    return PitData(
      teamNumber: map['team_number'] ?? 0,
      scouterName: map['scouter_name'] ?? 'Unknown',
      drivetrain: Drivetrain.values.firstWhere(
        (e) => e.toString().split('.').last == map['drivetrain'],
        orElse: () => Drivetrain.swerve,
      ),
      coralL1: map['coral_L1'] ?? 0,
      coralL2: map['coral_L2'] ?? 0,
      coralL3: map['coral_L3'] ?? 0,
      coralL4: map['coral_L4'] ?? 0,
      removeAlgae: map['remove_algae'] ?? 0,
      processorAlgae: map['processor_algae'] ?? 0,
      netAlgae: map['net_algae'] ?? 0,
      prefersCoral: map['prefers_coral'] ?? 0,
      preferredCoralLevel: map['preferred_coral_level'] ?? 0,
      park: map['park'] ?? 0,
      shallowClimb: map['shallow_climb'] ?? 0,
      deepClimb: map['deep_climb'] ?? 0,
      preferredStartingZone: StartingZone.values.firstWhere(
        (e) => e.toString().split('.').last == map['preferred_starting_zone'],
        orElse: () => StartingZone.top,
      ),
      preferredEndStatus: EndStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['preferred_end_status'],
        orElse: () => EndStatus.none,
      ),
      notes: map['notes'] ?? '',
    );
  }
}
