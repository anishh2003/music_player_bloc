import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubit/theme_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var darkThemeCubit = BlocProvider.of<ThemeCubit>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 30.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "User Email : ",
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
                // Text('${FirebaseAuth.instance.currentUser!.email}',
                //     style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark theme : ",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, state) {
                    return Switch(
                      // This bool value toggles the switch.
                      value: state,

                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (bool value) {
                        darkThemeCubit.changeTheme();
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
