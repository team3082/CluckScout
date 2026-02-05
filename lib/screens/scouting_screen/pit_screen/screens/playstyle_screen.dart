import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              title: "Scoring Preference",
              switches: [
                SwitchField(
                  text: "L1",
                  getValue: () => provider.preferredClimbLevel == 1 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(1),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L2",
                  getValue: () => provider.preferredClimbLevel == 2 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(2),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "L3",
                  getValue: () => provider.preferredClimbLevel == 3 ? 1 : 0,
                  setValue: (value) => provider.setPreferredClimbLevel(3),
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
