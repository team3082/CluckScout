import 'package:cluck_scout/model/enums.dart';

class PitData {
  // Scout Specifications
  final int teamNumber;
  final String scouterName;

  // Drivetrain Specifications
  final Drivetrain drivetrain;

  // Abilities
  final int Hub;
  final int Capacity;
  final int Bump;
  final int Trench;

  // Preferred Climb
  final ClimbLevel preferredClimbLevel;

  // End status
  final int L1;
  final int L2;
  final int L3;

  // Preferred Starting Zone and End Status
  final StartingZone preferredStartingZone;
  final EndStatus preferredEndStatus;

  final String notes;

  // Constructor
  PitData({
    required this.teamNumber,
    required this.scouterName,
    required this.drivetrain,
    required this.Hub,
    required this.Capacity,
    required this.preferredClimbLevel,
    required this.L1,
    required this.L2,
    required this.L3,
    required this.Bump,
    required this.Trench,
    required this.preferredStartingZone,
    required this.preferredEndStatus,
    required this.notes,
  });

  // Convert PitData to Map
  Map<String, dynamic> toMap() {
    return {
      'team_number': teamNumber,
      'scouter_name': scouterName,
      'preferred_climb_level': preferredClimbLevel.toString().split('.').last,  
      'drivetrain': drivetrain.toString().split('.').last,
      'Hub': Hub,
      'Capacity': Capacity,
      //'preferred_climb_level': preferredClimbLevel,
      'L1': L1,
      'L2': L2,
      'L3': L3,
      'Bump': Bump,
      'Trench': Trench,
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
      Hub: map['Hub'] ?? 0,
      Capacity: map['Capacity'] ?? 0,
      preferredClimbLevel: map['preferred_climb_level'] ?? 0,
      L1: map['L1'] ?? 0,
      L2: map['L2'] ?? 0,
      L3: map['L3'] ?? 0,
      Bump: map['Bump'] ?? 0,
      Trench: map['Trench'] ?? 0,
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
