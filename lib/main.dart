import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stabletexture_applier/editing_page.dart';
import 'package:stabletexture_applier/select_folder_page.dart';
import 'package:stabletexture_applier/state_provider.dart';
import 'package:stabletexture_applier/top_bar.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAsFrameless();
    await windowManager.setResizable(true);
    await windowManager.setTitle("StableTextureApplier");
  });

  runApp(ProviderScope(child: const MyApp()));

  doWhenWindowReady(() {
    appWindow.minSize = Size(1010, 500);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB454)),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: const Color(0xFF14191F),
            ),
          ),
          ref.watch(appStateProvider) == AppState.selectFolder
              ? SelectModFolder()
              : EditingMod(),
          WindowTopBar(),
        ],
      ),
    );
  }
}
