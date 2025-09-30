import 'package:flutter/material.dart';
import 'package:cluck_scout/widgets/navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Top navigation bar
            const NavBar(selectedIndex: 0),
            // Bottom content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 50.0, left: 50.0, right: 50.0, top: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon and title
                      Row(
                        children: const [
                          Icon(Icons.home, size: 30),
                          Text(
                            " CluckScout 2025",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      // Description text
                      const Text(
                        "This is FRC team 3082’s scouting app.\n\nScouting is an extremely important role at competitions because the data will help us make the best decisions for who to bring onto our alliance in playoffs.\n\nWith quality scouting data, we will have more information about the other teams in order to create the strongest possible alliances.\n\nWe can also determine which other teams have strategies that will work with ours, so that our alliance will work well together in playoffs and increase our chances of winning.",
                        style: TextStyle(fontSize: 17),
                      ),

                      // Centered image
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(right: 30),
                            child: Image.asset("assets/bird.png"),
                          ),
                        ),
                      )
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
