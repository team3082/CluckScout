enum ActionType {
  // Coral (Climb) actions
  L1climb,
  L2climb,
  L3climb,
  attemptedClimb,
  // Algae actions
  usedDepot,
  usedOutpost,
  bump,
  trench,
  // Hub shooting
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
  None,
  off,
  on
}