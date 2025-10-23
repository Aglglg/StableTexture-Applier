import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:stabletexture_applier/state_provider.dart';

////
////
////
////TOP BAR
class WindowTopBar extends StatelessWidget {
  const WindowTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1419),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          border: Border.all(
            color: const Color(0xFF222C38),
            strokeAlign: BorderSide.strokeAlignInside,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            MoveWindow(),
            Row(
              children: [
                Flexible(flex: 1, child: TitleAreaTopLeft()),
                Flexible(flex: 1, child: WindowButtonsTopRight()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WindowButtonsTopRight extends StatelessWidget {
  const WindowButtonsTopRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MinimizeWindowButton(
            colors: WindowButtonColors(
              normal: const Color.fromARGB(0, 0, 0, 0),
              mouseDown: const Color.fromARGB(2, 0, 0, 0),
              mouseOver: const Color.fromARGB(1, 0, 0, 0),
              iconNormal: Colors.white,
              iconMouseOver: const Color(0xFFFFB454),
              iconMouseDown: const Color(0xFFFFB454),
            ),
          ),
          MaximizeWindowButton(
            colors: WindowButtonColors(
              normal: const Color.fromARGB(0, 0, 0, 0),
              mouseDown: const Color.fromARGB(2, 0, 0, 0),
              mouseOver: const Color.fromARGB(1, 0, 0, 0),
              iconNormal: Colors.white,
              iconMouseOver: const Color(0xFF0096cf),
              iconMouseDown: const Color(0xFF0096cf),
            ),
          ),

          CloseWindowButton(
            colors: WindowButtonColors(
              normal: const Color.fromARGB(0, 0, 0, 0),
              mouseDown: const Color.fromARGB(2, 0, 0, 0),
              mouseOver: const Color.fromARGB(1, 0, 0, 0),
              iconNormal: Colors.white,
              iconMouseOver: const Color.fromARGB(255, 255, 84, 84),
              iconMouseDown: const Color.fromARGB(255, 255, 84, 84),
            ),
          ),
          // Icon(Icons.close, color: Colors.white, size: 20),
          // Icon(Icons.square_outlined, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

class TitleAreaTopLeft extends ConsumerWidget {
  const TitleAreaTopLeft({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (ref.watch(appStateProvider) == AppState.selectFolder)
            Container(width: 25),
          if (ref.watch(appStateProvider) == AppState.editing)
            TextButton(
              style: ButtonStyle(
                animationDuration: Duration.zero,
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xFFFFB454);
                  } else if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF0096cf);
                  }

                  return Colors.white;
                }),
              ),
              onPressed: () {
                //RESET ALL STATES
                ref.read(selectingFolderProvider.notifier).state = false;
                ref.read(modFolderPathProvider.notifier).state = "";
                ref.read(iniPathsProvider.notifier).state = [];
                ref.read(selectedIniPathProvider.notifier).state = "";
                //main app state
                ref.read(appStateProvider.notifier).state =
                    AppState.selectFolder;
              },
              child: Icon(Icons.arrow_back_ios_new, size: 14),
            ),
          Expanded(
            child: IgnorePointer(
              child: Text(
                ref.watch(appStateProvider) == AppState.editing
                    ? "${p.basename(ref.watch(modFolderPathProvider))}  -  StableTextureApplier"
                    : "StableTextureApplier",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
