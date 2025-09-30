import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/app_provider.dart';

class TabButtons extends StatelessWidget {
  const TabButtons({super.key});

  Widget _buildTabButton(BuildContext context, String text, int index) {
    final provider = context.read<AppProvider>();
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            left: index == 0 ? 50.0 : 0, right: index == 1 ? 50.0 : 0, top: 20),
        child: SizedBox(
          height: 50,
          child: Selector<AppProvider, int>(
            selector: (context, provider) => provider.scoutingTabIndex,
            builder: (context, tabIndex, child) {
              return ElevatedButton(
                onPressed: () {
                  provider.setTabIndex(index);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: index == tabIndex
                      ? const Color.fromRGBO(50, 50, 124, 1)
                      : const Color.fromRGBO(233, 233, 233, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: index == tabIndex
                        ? const Color.fromRGBO(247, 247, 247, 1)
                        : const Color.fromRGBO(28, 27, 31, 1),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton(context, "Match Records", 0),
        const SizedBox(width: 10),
        _buildTabButton(context, "Pit Records", 1),
      ],
    );
  }
}