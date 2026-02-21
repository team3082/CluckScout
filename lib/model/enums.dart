// Stores different options under a broader catagory like "ActionType"

// Sets up options for action types
enum ActionType {
  climbAutoL1,
  climbL1,
  climbL2,
  climbL3,
  attemptedClimb,
  bump,
  Hub,
  trench,
  usedDepot,
  usedOutpost,
  timeIntial,
  timeFinal,
}

enum EndStatus {
  none,
  climb,
  shooting,
}
// Starting position at beginning of match
enum Position {
  redTop,
  redMiddle,
  redBottom,
  blueTop,
  blueMiddle,
  blueBottom,
}

// Possible end status and auto status options like climbing
enum Disabled {
  None,
  off,
  on
}
enum AutoStatus {
  none,
  L1,
/*  L2,
  L3,*/
}

// Pit Scouting...
// Options for preferred climb level
enum ClimbLevel {
  none,
  L1,
  L2,
  L3,
}
// Types of drive train
enum Drivetrain {
  swerve,
  tank,
  mecanum,
  other,
}
// Preferred starting zone
enum StartingZone {
  top,
  middle,
  bottom,
}
