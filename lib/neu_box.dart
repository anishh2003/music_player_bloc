import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/cubit/theme_cubit.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  const NeuBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // darker shadow on the bottom right
              BoxShadow(
                color: state == false
                    ? Colors.black
                    : Theme.of(context).colorScheme.secondary,
                blurRadius: 15,
                offset: const Offset(4, 4),
              ),

              // lighter shadow on the top left
              BoxShadow(
                color: state == false ? Colors.white : Colors.black,
                blurRadius: 15,
                offset: const Offset(-4, -4),
              ),
            ],
          ),
          child: Center(child: child),
        );
      },
    );
  }
}
