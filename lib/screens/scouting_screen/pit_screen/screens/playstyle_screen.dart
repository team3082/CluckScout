import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';
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
              title: "Auto Climb Pref.",
              switches: [
                SwitchField(
                  text: "Cannot Climb",
                  getValue: () => provider.preferredAutoClimbLevel == 1 ? 1 : 0,
                  setValue: (value) => provider.setPreferredAutoClimbLevel(1),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L1 Climb",
                  getValue: () => provider.preferredAutoClimbLevel == 3 ? 1 : 0,
                  setValue: (value) => provider.setPreferredAutoClimbLevel(3),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
              ],
              secondTitle: "End Climb Pref.",
              secondSwitches: [
                SwitchField(
                  text: "Cannot Climb",
                  getValue: () => provider.preferredClimbLevel == 1 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(1),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L1 Climb",
                  getValue: () => provider.preferredClimbLevel == 3 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(3),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L2 Climb",
                  getValue: () => provider.preferredClimbLevel == 4 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(4),
                  height: height,
                  bottomMargin: bottomMargin, 
                ),
                SwitchField(
                  text: "L3 Climb",
                  getValue: () => provider.preferredClimbLevel == 5 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(5),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
              ],
            ),
            const SizedBox(width: 15),
            SwitchColumn(
              title: "End Preference",
              switches: [
                SwitchField(
                  text: "Climbing @ End",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.climb ? 1 : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.climb)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Shooting @ End",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.shooting
                          ? 1
                          : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.shooting)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "No Preference",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.none ? 1 : 0,
                  setValue: (value) => value == 1
                      // TODO: This is a hacky fix, it should be addressed in the future
                      ? provider.setPreferredEndStatus(EndStatus.none)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
              ],
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