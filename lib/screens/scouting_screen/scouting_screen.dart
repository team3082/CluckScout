import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/app_provider.dart';
import 'package:cluck_scout/screens/scouting_screen/match_screen/match_screen.dart';
import 'package:cluck_scout/screens/scouting_screen/pit_screen/pit_screen.dart';
import 'package:cluck_scout/widgets/navigation_bar.dart';

class ScoutPage extends StatelessWidget {
  const ScoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //dismisses the keyboard
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NavBar(selectedIndex: 1),
              _buildTabButtons(context),
              _buildContentContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the tab selection buttons
  Widget _buildTabButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton(context, "Match Scouting", 0),
        const SizedBox(width: 10),
        _buildTabButton(context, "Pit Scouting", 1),
      ],
    );
  }

  /// Creates a tab button with dynamic styling
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

  /// Uses IndexedStack to keep both pages alive and avoid unnecessary rebuilds
  Widget _buildContentContainer(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 50.0, left: 50.0, right: 50.0, top: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IndexedStack(
            index: context.select<AppProvider, int>(
              (provider) => provider.scoutingTabIndex,
            ),
            children: [
              MatchScreen(),
              PitScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
