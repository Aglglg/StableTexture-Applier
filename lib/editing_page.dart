import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:path/path.dart' as p;
import 'package:stabletexture_applier/bouncing_text.dart';
import 'package:stabletexture_applier/state_provider.dart';

////////////MAIN//////////////
////////////MAIN//////////////
////////////MAIN//////////////
class EditingMod extends ConsumerStatefulWidget {
  const EditingMod({super.key});

  @override
  ConsumerState<EditingMod> createState() => _EditingModState();
}

class _EditingModState extends ConsumerState<EditingMod> {
  MultiSplitViewController multiSplitViewController = MultiSplitViewController(
    areas: [
      Area(
        min: 200,
        size: 300,
        builder: (context, area) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14191F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            border: Border(
              left: BorderSide(
                color: const Color(0xFF222C38),
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
              ),
              bottom: BorderSide(
                color: const Color(0xFF222C38),
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
              ),
            ),
          ),
          child: IniFilesSection(),
        ),
      ),
      Area(
        flex: 1,
        builder: (context, area) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14191F),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF222C38),
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
              ),
            ),
          ),
          child: TexturesSection(),
        ),
      ),
      Area(
        flex: 1,

        builder: (context, area) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14191F),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            border: Border(
              right: BorderSide(
                color: const Color(0xFF222C38),
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
              ),
              bottom: BorderSide(
                color: const Color(0xFF222C38),
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
              ),
            ),
          ),
          child: ComponentsSection(),
        ),
      ),
    ],
  );

  MultiSplitView? multiSplitView;
  MultiSplitViewTheme? multiSplitViewTheme;

  @override
  void initState() {
    super.initState();
    multiSplitView = MultiSplitView(
      axis: Axis.horizontal,
      controller: multiSplitViewController,
      dividerBuilder:
          (axis, index, resizable, dragging, highlighted, themeData) {
            return Row(
              children: [
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 2,
                        color: const Color(0xFF222C38),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 2,
                        color: const Color(0xFF222C38),
                      ),
                    ),
                  ),
                ),
                Container(color: const Color(0xFF222C38), width: 2),
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 2,
                        color: const Color(0xFF222C38),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 2,
                        color: const Color(0xFF222C38),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
    );

    if (multiSplitView != null) {
      multiSplitViewTheme = MultiSplitViewTheme(
        data: MultiSplitViewThemeData(dividerThickness: 10),
        child: multiSplitView!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return multiSplitViewTheme!;
  }
}

////////////SECTION_1//////////////
////////////SECTION_1//////////////
////////////SECTION_1//////////////
class IniFilesSection extends ConsumerWidget {
  const IniFilesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 45 + 30,
        left: 30,
        right: 30,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ini Files",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(height: 15),

          //INI FILES
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: (ref.watch(iniPathsProvider).map((e) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: IniFileTextButton(iniFilePath: e)),
                  ],
                );
              }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class IniFileTextButton extends ConsumerStatefulWidget {
  final String iniFilePath;
  const IniFileTextButton({super.key, required this.iniFilePath});

  @override
  ConsumerState<IniFileTextButton> createState() => _IniFileTextButtonState();
}

class _IniFileTextButtonState extends ConsumerState<IniFileTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ref.read(selectedIniPathProvider.notifier).state = widget.iniFilePath;
      },
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        animationDuration: Duration.zero,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return const Color(0xFFFFB454);
          } else if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF0096cf);
          }

          return ref.watch(selectedIniPathProvider) == widget.iniFilePath
              ? const Color(0xFFFFB454)
              : Colors.white;
        }),
      ),
      child: Text(
        p.relative(widget.iniFilePath, from: ref.watch(modFolderPathProvider)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300),
        textAlign: TextAlign.start,
      ),
    );
  }
}

////////////SECTION_2//////////////
////////////SECTION_2//////////////
////////////SECTION_2//////////////
class TexturesSection extends StatelessWidget {
  const TexturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 45 + 30,
        left: 30,
        right: 30,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Textures",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(height: 15),
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFF222C38),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(height: 15),
                      Text(
                        "TextureOverrideTexture1",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          spacing: 13,
                          runSpacing: 13,
                          children: [
                            TextureWidget(),
                            TextureWidget(),
                            TextureWidget(),
                            TextureWidget(),
                          ],
                        ),
                      ),
                    ],
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

class TextureWidget extends StatelessWidget {
  const TextureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BouncingText(
          text: 'ResourceTexture1',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          width: 130,
        ),
        BouncingText(
          text: 'Components-0 t=40e95d0b.dds',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          width: 130,
        ),
        SizedBox(height: 5),
        Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: const Color(0xFF222C38)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

////////////SECTION_3//////////////
////////////SECTION_3//////////////
////////////SECTION_3//////////////
class ComponentsSection extends StatelessWidget {
  const ComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45 + 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Components",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

////////////OTHER///////////
////////////OTHER///////////
////////////OTHER///////////
