import 'package:flutter/material.dart';
import 'package:cluck_scout/model/data/pit_data.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/services/database_service.dart';

class PitScoutingProvider extends ChangeNotifier {
  int tabIndex = 0;

  // Scout Specifications
  int teamNumber = 0;
  String scouterName = '';

  // Drivetrain Specifications
  Drivetrain drivetrain = Drivetrain.swerve;

  // Abilities
  int L1 = 0;
  int L2 = 0;
  int L3 = 0;
  int Hub = 0;
  int Capacity = 0;

  // Preferred Playstyle
  StartingZone preferredStartingZone = StartingZone.top;
  EndStatus preferredEndStatus = EndStatus.none;

  // Notes
  String notes = '';

  PitScoutingProvider({
    this.tabIndex = 0,
    this.teamNumber = 0,
    required this.scouterName,
    this.drivetrain = Drivetrain.swerve,
    this.L1 = 0,
    this.L2 = 0,
    this.L3 = 0,
    this.Hub = 0,
    this.Capacity = 0,
    this.preferredClimbLevel.L1,
    preferredStartingZone = StartingZone.top,
    this.preferredEndStatus = EndStatus.none,
    this.notes = '',
  });

  // Reset all fields to default values
  void reset() {
    tabIndex = 0;
    teamNumber = 0;
    drivetrain = Drivetrain.swerve;
    L1 = 0;
    L2 = 0;
    L3 = 0;
    Hub = 0;
    Capacity = 0;
    preferredClimbLevel.L1;
    preferredStartingZone = StartingZone.top;
    preferredEndStatus = EndStatus.none;
    notes = '';
    notifyListeners();
  }

  void submit() {
    DatabaseService.instance.insertPitData(PitData(
      teamNumber: teamNumber,
      scouterName: scouterName,
      drivetrain: drivetrain,
      L1: L1,
      L2: L2,
      L3: L3,
      Hub: Hub,
      Capacity: Capacity,
      preferredClimbLevel: preferredClimbLevel,
      preferredStartingZone: preferredStartingZone,
      preferredEndStatus: preferredEndStatus,
      notes: notes,
    ));
    reset();
  }

  // Setters for various fields
  void setL1(int value) {
    L1 = value;
    notifyListeners();
  }

  void setL2(int value) {
    L2 = value;
    notifyListeners();
  }

  void setL3(int value) {
    L3 = value;
    notifyListeners();
  }

  void setHub(int value) {
    Hub = value;
    notifyListeners();
  }

  void setCapacity(int value) {
    Capacity = value;
    notifyListeners();
  }

  void setTeamNumber(int value) {
    teamNumber = value;
    notifyListeners();
  }

  void setTabIndex(int value) {
    tabIndex = value;
    notifyListeners();
  }

  void setDriveTrain(Drivetrain value) {
    drivetrain = value;
    notifyListeners();
  }

  void setPreferredStartingZone(StartingZone zone) {
    preferredStartingZone = zone;
    notifyListeners();
  }

  void setPreferredEndStatus(EndStatus value) {
    preferredEndStatus = value;
    notifyListeners();
  }

  void setComments(String value) {
    notes = value;
    notifyListeners();
  }

  void setScouterName(String name) {
    scouterName = name;
  }
}
