// Sets up the Playstyle Screen of Pit Scouting for the scouting app

// Library of basic UI functions and other basics (Not specific to 3082)
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
// For sharing data between files and other basics (Not specific to 3082)
import 'package:provider/provider.dart';
// References enums.dart (which stores info about what is included in types of actions, ways to be disabled...)
import 'package:cluck_scout/model/enums.dart';
//
import 'package:cluck_scout/providers/pit_scouting_provider.dart';
// Sets up the Abilities Screen of Pit Scouting for the scouting app
import 'package:cluck_scout/screens/scouting_screen/pit_screen/screens/abilities_screen.dart';

class PlaystyleScreen extends StatelessWidget {
  const PlaystyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PitScoutingProvider>();
    final double height = 60;
    final double bottomMargin = 15;

    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchColumn(
              // Creates End Preference sub title and options (an only select one)
              title: "End Preference",
              switches: [
                SwitchField(
                  text: "L1",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.L1 ? 1 : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.L1)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L2",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.L2
                          ? 1
                          : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.L2)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L3",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.L3 ? 1 : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.L3)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
              ],
              // Creates Preferred sub title and options (Can only select one)
              secondTitle: "Preferred Starting",
              secondSwitches: [
                SwitchField(
                  text: "Top",
                  getValue: () =>
                      provider.preferredStartingZone == StartingZone.top
                          ? 1
                          : 0,
                  setValue: (value) =>
                      provider.setPreferredStartingZone(StartingZone.top),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Middle",
                  getValue: () =>
                      provider.preferredStartingZone == StartingZone.middle
                          ? 1
                          : 0,
                  setValue: (value) =>
                      provider.setPreferredStartingZone(StartingZone.middle),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Bottom",
                  getValue: () =>
                      provider.preferredStartingZone == StartingZone.bottom
                          ? 1
                          : 0,
                  setValue: (value) =>
                      provider.setPreferredStartingZone(StartingZone.bottom),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
