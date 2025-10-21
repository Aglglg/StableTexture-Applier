import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStateProvider = StateProvider<AppState>(
  (ref) => AppState.selectFolder,
);

final selectingFolderProvider = StateProvider<bool>((ref) => false);

//EDITING
final StateProvider<String> modFolderPathProvider = StateProvider((ref) => "");
final StateProvider<List<String>> iniPathsProvider =
    StateProvider<List<String>>((ref) => []);
final StateProvider<String> selectedIniPathProvider = StateProvider<String>(
  (ref) => "",
);

enum AppState { selectFolder, editing }
