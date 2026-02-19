import 'package:cluck_scout/model/enums.dart';

class PitData {
  // Scout Specifications
  final int teamNumber;
  final String scouterName;

  // Drivetrain Specifications
  final Drivetrain drivetrain;

  // Abilitiesczx
  final int cannotClimbAuto;
  final int climbAutoL1;

  final int cannotClimbL1;
  final int climbL1;
  final int climbL2;
  final int climbL3;


  final int bump;
  final int trench;

  // Preferred Coral
  final int prefersAutoClimbLevel;
  final int prefersClimbLevel;

  // Preferred Starting Zone and End Status
  final StartingZone preferredStartingZone;
  final EndStatus preferredEndStatus;

  final String notes;

  // Constructor
  PitData({
    required this.teamNumber,
    required this.scouterName,
    required this.drivetrain,
    
    required this.cannotClimbAuto,
    required this.climbAutoL1,
    
    required this.cannotClimbL1,
    required this.climbL1,
    required this.climbL2,
    required this.climbL3,
    
    required this.bump,
    required this.trench,

    required this.prefersAutoClimbLevel,
    required this.prefersClimbLevel,

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
      'cannot_climb_auto': cannotClimbAuto,
      'climb_auto_L1': climbAutoL1,
      'cannot_climb_L1': cannotClimbL1,
      'climb_L1': climbL1,
      'climb_L2': climbL2,
      'climb_L3': climbL3,
      'bump': bump,
      'trench': trench,
      'prefers_auto_climb_level': prefersAutoClimbLevel,
      'prefers_climb_level': prefersClimbLevel,
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
      cannotClimbAuto: map['cannot_climb_auto'] ?? 0,
      climbAutoL1: map['climb_auto_L1'] ?? 0,
      cannotClimbL1: map['cannot_climb_L1'] ?? 0,
      climbL1: map['climb_L1'] ?? 0,
      climbL2: map['climb_L2'] ?? 0,
      climbL3: map['climb_L3'] ?? 0,
      bump: map['bump'] ?? 0,
      trench: map['trench'] ?? 0,
      prefersAutoClimbLevel: map['prefers_auto_climb_level'] ?? 0,
      prefersClimbLevel: map['prefers_climb_level'] ?? 0,
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
