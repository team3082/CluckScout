//

// Library of basic UI functions and other basics (Not specific to 3082)
import 'package:flutter/material.dart';
// For sharing data between files and other basics (Not specific to 3082)
import 'package:cluck_scout/model/data/pit_data.dart';
// References enums.dart where subcatagories of things like actionType are defined
import 'package:cluck_scout/model/enums.dart';
// Stores data as a CSV to later be analized
import 'package:cluck_scout/services/database_service.dart';

class PitScoutingProvider extends ChangeNotifier {
  // Declares the type of each variable (Ex. int)

  int tabIndex = 0;

  // Scout Specifications
  int teamNumber = 0;
  String scouterName = '';

  // Drivetrain Specifications
  Drivetrain drivetrain = Drivetrain.swerve;

  // Abilities
  int cannotClimbAuto = 0;
  int climbAutoL1 = 0;
  
  int cannotClimbL1 = 0;
  int climbL1 = 0;
  int climbL2 = 0;
  int climbL3 = 0;

  int bump = 0;
  int trench = 0;

  int swerve = 0;
  int tank = 0;
  int mecanum = 0;
  int other = 0;

  // Preferred Playstyle
  int preferredAutoClimbLevel = 1;
  int preferredClimbLevel = 1;
  
  

  StartingZone preferredStartingZone = StartingZone.top;
  EndStatus preferredEndStatus = EndStatus.none;

  // Notes
  String notes = '';

  // Requires that some value is passed along for each of the variables or sets it to a starting value
  PitScoutingProvider({
    this.tabIndex = 0,
    this.teamNumber = 0,
    required this.scouterName,
    this.drivetrain = Drivetrain.swerve,
    
    this.cannotClimbAuto = 0,
    this.climbAutoL1 = 0,

    this.cannotClimbL1 = 0,
    this.climbL1 = 0,
    this.climbL2 = 0,
    this.climbL3 = 0,
    
    this.bump = 0,
    this.trench = 0,
    
    this.swerve = 0,
    this.tank = 0,
    this.mecanum = 0,
    this.other = 0,

    this.preferredAutoClimbLevel = 0,
    this.preferredClimbLevel = 0,
    this.notes = '',
  });

  // Reset all fields to default values
  void reset() {
    tabIndex = 0;
    teamNumber = 0;
    drivetrain = Drivetrain.swerve;
    
    cannotClimbAuto = 0;
    climbAutoL1 = 0;
    
    cannotClimbL1 = 0;
    climbL1 = 0;
    climbL2 = 0;
    climbL3 = 0;

    bump = 0;
    trench = 0;

    swerve = 0;
    tank = 0;
    mecanum = 0;
    other = 0;

    preferredClimbLevel = 0;

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
      
      cannotClimbAuto: cannotClimbAuto,
      climbAutoL1: climbAutoL1,

      cannotClimbL1: cannotClimbL1,
      climbL1: climbL1,
      climbL2: climbL2,
      climbL3: climbL3,

      bump: bump,
      trench: trench,

      prefersAutoClimbLevel: preferredClimbLevel,
      prefersClimbLevel: preferredClimbLevel,
      
      preferredStartingZone: preferredStartingZone,
      preferredEndStatus: preferredEndStatus,

      notes: notes,
    ));
    reset();
  }

  // Setters for various fields
  void setCannotClimbAuto(int value) {
    cannotClimbAuto = value;
    notifyListeners();
  }

  void setAutoClimbL1(int value) {
    climbAutoL1 = value;
    notifyListeners();
  }

  void setCannotClimbL1(int value) {
    cannotClimbL1 = value;
    notifyListeners();
  }

  void setClimbL1(int value) {
    climbL1 = value;
    notifyListeners();
  }

  void setClimbL2(int value) {
    climbL2 = value;
    notifyListeners();
  }

  void setClimbL3(int value) {
    climbL3 = value;
    notifyListeners();
  }

  void setBump(int value) {
    bump = value;
    notifyListeners();
  }

  void setTrench(int value) {
    trench = value;
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

  void setPreferredAutoClimbLevel(int value) {
    preferredAutoClimbLevel = value;
    notifyListeners();
  }

  void setPreferredClimbLevel(int value) {
    preferredClimbLevel = value;
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
