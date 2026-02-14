import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/enums.dart';
import 'package:cluck_scout/providers/pit_scouting_provider.dart';

class AbilitiesScreen extends StatelessWidget {
  const AbilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PitScoutingProvider>();

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
              title: "Climb Abilities",
              switches: [
                SwitchField(
                  text: "Cannot Climb",
                  getValue: () => provider.coralL1,
                  setValue: (value) => provider.setCoralL1(value),
                ),
                SwitchField(
                  text: "L1 Climb",
                  getValue: () => provider.coralL2,
                  setValue: (value) => provider.setCoralL2(value),
                ),
                SwitchField(
                  text: "L2 Climb",
                  getValue: () => provider.coralL3,
                  setValue: (value) => provider.setCoralL3(value),
                ),
                SwitchField(
                  text: "L3 Climb",
                  getValue: () => provider.coralL4,
                  setValue: (value) => provider.setCoralL4(value),
                ),
              ],
              secondTitle: "Can Use",
              secondSwitches: [
                SwitchField(
                  text: "Bump",
                  getValue: () => provider.netAlgae,
                  setValue: (value) => provider.setNetAlgae(value),
                ),
                SwitchField(
                  text: "Trench",
                  getValue: () => provider.processorAlgae,
                  setValue: (value) => provider.setProcessorAlgae(value),
                ),
             
              ],
            ),
            const SizedBox(width: 15),
            SwitchColumn(
              title: "Drivetrain",
              switches: [
                SwitchField(
                  text: "Swerve",
                  getValue: () =>
                      provider.drivetrain == Drivetrain.swerve ? 1 : 0,
                  setValue: (_) => provider.setDriveTrain(Drivetrain.swerve),
                ),
                SwitchField(
                  text: "Tank",
                  getValue: () =>
                      provider.drivetrain == Drivetrain.tank ? 1 : 0,
                  setValue: (_) => provider.setDriveTrain(Drivetrain.tank),
                ),
                SwitchField(
                  text: "Mecanum",
                  getValue: () =>
                      provider.drivetrain == Drivetrain.mecanum ? 1 : 0,
                  setValue: (_) => provider.setDriveTrain(Drivetrain.mecanum),
                ),
                SwitchField(
                  text: "Other",
                  getValue: () =>
                      provider.drivetrain == Drivetrain.other ? 1 : 0,
                  setValue: (_) => provider.setDriveTrain(Drivetrain.other),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SwitchColumn extends StatelessWidget {
  final String title;
  final List<SwitchField> switches;
  final String? secondTitle;
  final List<SwitchField>? secondSwitches;

  const SwitchColumn({
    super.key,
    required this.title,
    required this.switches,
    this.secondTitle,
    this.secondSwitches,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        ...switches,
        if (secondTitle != null && secondSwitches != null) ...[
          Container(
            width: 220,
            height: 2,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            secondTitle!,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          ...secondSwitches!,
        ],
      ],
    );
  }
}

class SwitchField extends StatelessWidget {
  final String text;
  final int Function() getValue;
  final Function(int) setValue;
  final double height;
  final double bottomMargin;

  const SwitchField({
    super.key,
    required this.text,
    required this.getValue,
    required this.setValue,
    this.height = 54.3,
    this.bottomMargin = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<PitScoutingProvider, int>(
      selector: (context, provider) => getValue(),
      builder: (context, value, child) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setValue(value == 1 ? 0 : 1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: value == 1
                    ? const Color.fromRGBO(50, 50, 124, 1)
                    : const Color.fromRGBO(233, 233, 233, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                height: height,
                width: 170,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: value == 1
                          ? const Color.fromRGBO(233, 233, 233, 1)
                          : const Color.fromRGBO(28, 27, 31, 1),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: bottomMargin),
          ],
        );
      },
    );
  }
}
