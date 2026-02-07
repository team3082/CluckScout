import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/providers/app_provider.dart';
import 'package:cluck_scout/providers/upload_provider.dart';
import 'package:cluck_scout/screens/data_screen/widgets/match_data.dart';
import 'package:cluck_scout/screens/data_screen/widgets/pit_data.dart';
import 'package:cluck_scout/screens/data_screen/widgets/tab_buttons.dart';
import 'package:cluck_scout/widgets/navigation_bar.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UploadProvider(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                const NavBar(selectedIndex: 2),
                const TabButtons(),
                const ContentContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 

class ContentContainer extends StatelessWidget {
  const ContentContainer({super.key});


  @override
  Widget build(BuildContext context) {
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
            children: const [MatchDataPage(), PitDataPage()],
          ),
        ),
      ),
    );
  }
}