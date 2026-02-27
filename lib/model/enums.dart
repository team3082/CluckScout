enum ActionType {
  // Climb actions
  L1climb,
  L2climb,
  L3climb,
  attemptedClimb,
  // Mobility actions
  usedDepot,
  usedOutpost,
  bump,
  trench,
  // Shooting actions
  hubShooting,
}

enum EndStatus {
  none,
  climb,
  shooting,
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
  None,
  off,
  on
}