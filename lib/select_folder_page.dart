import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:stabletexture_applier/state_provider.dart';

class SelectModFolder extends ConsumerStatefulWidget {
  const SelectModFolder({super.key});

  @override
  ConsumerState<SelectModFolder> createState() => _SelectModFolderState();
}

class _SelectModFolderState extends ConsumerState<SelectModFolder> {
  Future<bool> isFolderAndExistAndValid(File f) async {
    final selectedDirectory = Directory(f.path);
    if (await selectedDirectory.exists()) {
      final texturePath = p.join(selectedDirectory.path, "Textures");
      final meshPath = p.join(selectedDirectory.path, "Meshes");

      if (await Directory(texturePath).exists() &&
          await Directory(meshPath).exists()) {
        final iniFiles = await findIniFilesRecursiveExcludeDisabled(
          selectedDirectory.path,
        );
        if (iniFiles.isNotEmpty) {
          ref.read(iniPathsProvider.notifier).state = iniFiles;
          ref.read(modFolderPathProvider.notifier).state =
              selectedDirectory.path;
          ref.read(appStateProvider.notifier).state = AppState.editing;
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14191F),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: const Color(0xFF222C38),
          strokeAlign: BorderSide.strokeAlignInside,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          ModDropZone(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select a valid mod folder",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Container(height: 5),
                Text(
                  "Choose a folder that contains both the 'Textures' and 'Meshes' folders.\nYou can also drag and drop here.",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(height: 30),
                SizedBox(
                  height: 45,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (ref.read(selectingFolderProvider)) return;

                      final messenger = ScaffoldMessenger.of(context);
                      String? selectedDirectory;

                      ref.read(selectingFolderProvider.notifier).state = true;
                      selectedDirectory = await FilePicker.platform
                          .getDirectoryPath(lockParentWindow: true);
                      ref.read(selectingFolderProvider.notifier).state = false;

                      if (selectedDirectory != null) {
                        if (!await isFolderAndExistAndValid(
                          File(selectedDirectory),
                        )) {
                          messenger.showSnackBar(
                            SnackBar(
                              margin: EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 100,
                              ),
                              content: Text(
                                'Please select a valid folder',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFFFB454),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF0F1419),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(99999),
                                ),
                                side: BorderSide(
                                  color: Color(0xFF222C38),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color(0xFFFFB454),
                      ),
                    ),
                    child: Text(
                      "Select a folder",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModDropZone extends ConsumerStatefulWidget {
  const ModDropZone({super.key});

  @override
  ConsumerState<ModDropZone> createState() => _ModDropZoneState();
}

class _ModDropZoneState extends ConsumerState<ModDropZone> {
  bool _dragging = false;

  Future<bool> isFolderAndExistAndValid(File f) async {
    final selectedDirectory = Directory(f.path);
    if (await selectedDirectory.exists()) {
      final texturePath = p.join(selectedDirectory.path, "Textures");
      final meshPath = p.join(selectedDirectory.path, "Meshes");

      if (await Directory(texturePath).exists() &&
          await Directory(meshPath).exists()) {
        final iniFiles = await findIniFilesRecursiveExcludeDisabled(
          selectedDirectory.path,
        );
        if (iniFiles.isNotEmpty) {
          ref.read(iniPathsProvider.notifier).state = iniFiles;
          ref.read(modFolderPathProvider.notifier).state =
              selectedDirectory.path;
          ref.read(appStateProvider.notifier).state = AppState.editing;
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) async {
        final messenger = ScaffoldMessenger.of(context);
        if (details.files.isNotEmpty) {
          final mod = details.files[0];
          final isValid = await isFolderAndExistAndValid(File(mod.path));

          if (!isValid) {
            messenger.showSnackBar(
              SnackBar(
                margin: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
                content: Text(
                  'Please select a valid folder',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFFB454),
                  ),
                  textAlign: TextAlign.center,
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                backgroundColor: const Color(0xFF0F1419),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(
                    Radius.circular(99999),
                  ),
                  side: BorderSide(
                    color: Color(0xFF222C38),
                    strokeAlign: BorderSide.strokeAlignInside,
                    width: 2,
                  ),
                ),
              ),
            );
          }
        }
      },
      onDragEntered: (details) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (details) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _dragging
              ? const Color.fromARGB(20, 255, 181, 84)
              : Colors.transparent,
        ),
      ),
    );
  }
}

Future<List<String>> findIniFilesRecursiveExcludeDisabled(
  String mainFolder,
) async {
  final directory = Directory(mainFolder);
  if (!await directory.exists()) return [];

  return await directory
      .list(recursive: true)
      .where((file) => file is File)
      .map((file) => file.path)
      .where((path) => path.toLowerCase().endsWith('.ini'))
      .where((path) => !path.toLowerCase().endsWith('desktop.ini'))
      .where((path) => !p.basename(path).toLowerCase().startsWith('disabled'))
      .toList();
}
