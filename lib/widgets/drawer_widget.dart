import 'package:flutter/material.dart';
import 'package:music_player/screens/settings_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Stack(children: [
        ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: const Icon(
                Icons.music_note,
                size: 80.0,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child:
            //   ListTile(
            //     leading: Image.asset(
            //       'lib/images/logo.png',
            //       scale: 20,
            //     ),
            //     title: Text(
            //       'About Us',
            //       style: Theme.of(context).textTheme.headlineSmall,
            //     ),
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => const AboutUs(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 30.0,
              ),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
            ),
            // ListTile(
            //   leading: Icon(Icons.logout,
            //       color: Theme.of(context).colorScheme.primary),
            //   title: Text(
            //     'Log Out',
            //     style: Theme.of(context).textTheme.headlineSmall,
            //   ),
            //   onTap: () => FirebaseAuth.instance.signOut(),
            // ),
          ],
        ),
      ]),
    );
  }
}
