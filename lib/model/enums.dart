enum ActionType {
  L1,
  L2,
  L3,
  Hub,
  coralL1,
  coralL2,
  coralL3,
  coralL4,
  dropped,
  removeAlgae,
  processorAlgae,
  netAlgae,
}

enum EndStatus {
  none,
  L1,
  L2,
  L3,
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

enum RobotType {
  Unknown,
  Small,
  Medium,
  Large,
}
