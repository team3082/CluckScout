// Stores different options under a broader catagory like "ActionType"

// Sets up options for action types
enum ActionType {
  L1,
  L2,
  L3,
  Hub,
  Bump,
  Trench,
}

// Ways of being disabled
enum Disabled {
  None,
  off,
  on
}
// Different robot objectives
enum RobotGoal {
  shooter,
  passing,
  other
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
enum EndStatus {
  none,
  L1,
  L2,
  L3,
}
enum AutoStatus {
  none,
  L1,
  //L2,
  //L3,
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
