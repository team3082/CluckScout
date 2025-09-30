import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cluck_scout/model/app_preferences.dart';
import 'package:cluck_scout/providers/match_scouting_provider.dart';
import 'package:cluck_scout/screens/settings_screen/widgets/name_search_dialog.dart';
import 'package:cluck_scout/screens/settings_screen/widgets/position_selector.dart';
import 'package:cluck_scout/widgets/navigation_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final String _correctPassword = "2149";
  bool _isContentUnlocked = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _scouterName = TextEditingController();

  void _checkPassword() {
    if (_passwordController.text == _correctPassword) {
      setState(() {
        _isContentUnlocked = true;
      });
    } else {
      _passwordController.text = "";
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect Password. If you are trying to break in, do not :(',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color.fromRGBO(50, 50, 124, 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const NavBar(selectedIndex: 3),
            // Bottom box filling the remainder of the screen
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 50.0, left: 50.0, right: 50.0, top: 20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings, size: 30),
                          Text(
                            " Settings Page",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!_isContentUnlocked) // Show password input if content is locked
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.lock,
                              size: 300,
                              color: Color.fromRGBO(50, 50, 124, 1),
                            ),
                            Container(
                              width: double.infinity,
                            ),
                            SizedBox(
                              width: 400,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true, // Hide the password
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(50, 50, 124, 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: _checkPassword,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (_isContentUnlocked) // Show settings content if unlocked
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap:() => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            NameSearchDialog()),
                                    child: AbsorbPointer(
                                      child:
                                          Selector<MatchScoutingProvider, String>(
                                        selector: (_, provider) =>
                                            provider.scouterName,
                                        builder: (_, name, __) {
                                          _scouterName.text =
                                              AppPreferences.scouterName;
                                          return TextField(
                                            controller: _scouterName,
                                            readOnly: true,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: const InputDecoration(
                                              labelText: 'Scouter Name',
                                              border: OutlineInputBorder(),
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 9, horizontal: 9),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            PositionSelector(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
