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
  int coralL1 = 0;
  int coralL2 = 0;
  int coralL3 = 0;
  int coralL4 = 0;

  int removeAlgae = 0;
  int processorAlgae = 0;
  int netAlgae = 0;

  int park = 0;
  int shallowClimb = 0;
  int deepClimb = 0;

  // Preferred Playstyle
  int prefersCoral = 0;
  int preferredCoralLevel = 1;

  StartingZone preferredStartingZone = StartingZone.top;
  EndStatus preferredEndStatus = EndStatus.none;

  // Notes
  String notes = '';

  PitScoutingProvider({
    this.tabIndex = 0,
    this.teamNumber = 0,
    required this.scouterName,
    this.drivetrain = Drivetrain.swerve,
    this.coralL1 = 0,
    this.coralL2 = 0,
    this.coralL3 = 0,
    this.coralL4 = 0,
    this.removeAlgae = 0,
    this.processorAlgae = 0,
    this.netAlgae = 0,
    this.prefersCoral = 0,
    this.preferredCoralLevel = 1,
    this.park = 0,
    this.shallowClimb = 0,
    this.deepClimb = 0,
    this.notes = '',
  });

  // Reset all fields to default values
  void reset() {
    tabIndex = 0;
    teamNumber = 0;
    drivetrain = Drivetrain.swerve;
    coralL1 = 0;
    coralL2 = 0;
    coralL3 = 0;
    coralL4 = 0;
    removeAlgae = 0;
    processorAlgae = 0;
    netAlgae = 0;
    park = 0;
    shallowClimb = 0;
    deepClimb = 0;
    prefersCoral = 0;
    preferredCoralLevel = 1;
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
      coralL1: coralL1,
      coralL2: coralL2,
      coralL3: coralL3,
      coralL4: coralL4,
      removeAlgae: removeAlgae,
      processorAlgae: processorAlgae,
      netAlgae: netAlgae,
      prefersCoral: prefersCoral,
      preferredCoralLevel: preferredCoralLevel,
      park: park,
      shallowClimb: shallowClimb,
      deepClimb: deepClimb,
      preferredStartingZone: preferredStartingZone,
      preferredEndStatus: preferredEndStatus,
      notes: notes,
    ));
    reset();
  }

  // Setters for various fields
  void setPark(int value) {
    park = value;
    notifyListeners();
  }

  void setShallowClimb(int value) {
    shallowClimb = value;
    notifyListeners();
  }

  void setDeepClimb(int value) {
    deepClimb = value;
    notifyListeners();
  }

  void setCoralL1(int value) {
    coralL1 = value;
    notifyListeners();
  }

  void setCoralL2(int value) {
    coralL2 = value;
    notifyListeners();
  }

  void setCoralL3(int value) {
    coralL3 = value;
    notifyListeners();
  }

  void setCoralL4(int value) {
    coralL4 = value;
    notifyListeners();
  }

  void setRemoveAlgae(int value) {
    removeAlgae = value;
    notifyListeners();
  }

  void setProcessorAlgae(int value) {
    processorAlgae = value;
    notifyListeners();
  }

  void setNetAlgae(int value) {
    netAlgae = value;
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

  void setPrefersCoral(int value) {
    prefersCoral = value;
    notifyListeners();
  }

  void setPreferredCoralLevel(int value) {
    preferredCoralLevel = value;
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
