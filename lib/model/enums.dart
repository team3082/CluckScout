enum ActionType {
  climbL1,
  climbL2,
  climbL3,
  attemptedClimb,
  bump,
  trench,
  usedDepot,
  usedOutpost,
  timeIntial,
  timeFinal,
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