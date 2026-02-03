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
              title: "Coral Preference",
              switches: [
                SwitchField(
                  text: "Prefers Coral",
                  getValue: () => provider.prefersCoral ? 1 : 0,
                  setValue: (value) => provider.setPrefersCoral(value == 1),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Coral L1",
                  getValue: () => provider.preferredCoralLevel == 1 ? 1 : 0,
                  setValue: (value) => value == 1 ? provider.setPreferredCoralLevel(1) : provider.setPreferredCoralLevel(0),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Coral L2",
                  getValue: () => provider.preferredCoralLevel == 2 ? 1 : 0,
                  setValue: (value) => value == 1 ? provider.setPreferredCoralLevel(2) : provider.setPreferredCoralLevel(0),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Coral L3",
                  getValue: () => provider.preferredCoralLevel == 3 ? 1 : 0,
                  setValue: (value) => value == 1 ? provider.setPreferredCoralLevel(3) : provider.setPreferredCoralLevel(0),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Coral L4",
                  getValue: () => provider.preferredCoralLevel == 4 ? 1 : 0,
                  setValue: (value) => value == 1 ? provider.setPreferredCoralLevel(4) : provider.setPreferredCoralLevel(0),
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
                  text: "Park",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.park ? 1 : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.park)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Shallow Climb",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.shallowCage
                          ? 1
                          : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.shallowCage)
                      : provider.setPreferredEndStatus(EndStatus.none),
                  height: height,
                  bottomMargin: bottomMargin,
                ),
                SwitchField(
                  text: "Deep Climb",
                  getValue: () =>
                      provider.preferredEndStatus == EndStatus.deepCage ? 1 : 0,
                  setValue: (value) => value == 1
                      ? provider.setPreferredEndStatus(EndStatus.deepCage)
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
