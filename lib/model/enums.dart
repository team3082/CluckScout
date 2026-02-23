enum ActionType {
  coralL1,
  coralL2,
  coralL3,
  coralL4,
  netAlgae,
  processorAlgae,
  removeAlgae,
  dropped,
  hubShooting,
}

enum EndStatus {
  none,
  park,
  shallowCage,
  deepCage,
}

enum Position {
  redTop,
  redMiddle,
  redBottom,
  blueTop,
  blueMiddle,
  blueBottom,
}

enum Drivetrain {
  swerve,
  tank,
  mecanum,
  other,
}

enum StartingZone {
  top,
  middle,
  bottom,
}

enum Disabled {
  // ignore: constant_identifier_names
  None,
  off,
  on
}