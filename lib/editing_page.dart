import 'dart:async';
import 'dart:ui';

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
        size: 200,
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
        min: 260,
        size: 260,
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
        min: 550,
        size: 550,

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
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
                scrollbars: false,
              ),
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
            return const Color(0xFF0096cf);
          } else if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF0096cf);
          }

          return ref.watch(selectedIniPathProvider) == widget.iniFilePath
              ? const Color(0xFF0096cf)
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
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
                scrollbars: false,
              ),
              child: ListView(
                children: [
                  TextureOverrideTextureWidget(),
                  Container(height: 10),

                  TextureOverrideTextureWidget(),

                  Container(height: 10),
                  TextureOverrideTextureWidget(),

                  Container(height: 10),
                  TextureOverrideTextureWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final isDraggingItemProvider = StateProvider<bool>((ref) => false);

class TextureOverrideTextureWidget extends ConsumerStatefulWidget {
  const TextureOverrideTextureWidget({super.key});

  @override
  ConsumerState<TextureOverrideTextureWidget> createState() =>
      _TextureOverrideTextureWidgetState();
}

class _TextureOverrideTextureWidgetState
    extends ConsumerState<TextureOverrideTextureWidget> {
  bool _isHovered = false;
  int _childrenHoverCount = 0;

  Color get _borderColor {
    final isDragging = ref.watch(isDraggingItemProvider);
    if (isDragging) return const Color(0xFF222C38);
    return (_isHovered && _childrenHoverCount == 0)
        ? const Color(0xFF0096cf)
        : const Color(0xFF222C38);
  }

  void _onChildHoverChanged(bool isHovering) {
    setState(() {
      _childrenHoverCount += isHovering ? 1 : -1;
      if (_childrenHoverCount < 0) _childrenHoverCount = 0;
    });
  }

  Widget _buildContainer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14191F),
        border: Border.all(width: 2, color: _borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "TextureOverrideTexture1",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 13,
              runSpacing: 13,
              children: [
                TextureWidget(onHoverChanged: _onChildHoverChanged),
                TextureWidget(onHoverChanged: _onChildHoverChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDragging = ref.watch(isDraggingItemProvider);

    return MouseRegion(
      opaque: false,
      onEnter: (_) {
        if (!isDragging) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDragging) {
          setState(() {
            _isHovered = false;
            _childrenHoverCount = 0;
          });
        }
      },
      child: Listener(
        onPointerDown: (_) =>
            ref.read(isDraggingItemProvider.notifier).state = true,
        onPointerUp: (_) {
          ref.read(isDraggingItemProvider.notifier).state = false;
          setState(() {
            _isHovered = false;
          });
        },
        behavior: HitTestBehavior.deferToChild,
        child: Draggable(
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: Opacity(opacity: .8, child: _buildContainer()),
          childWhenDragging: Opacity(opacity: 0.3, child: _buildContainer()),
          child: _buildContainer(),
        ),
      ),
    );
  }
}

class TextureWidget extends ConsumerStatefulWidget {
  //optional callback parent can provide, to be notified of child's hover state
  final ValueChanged<bool>? onHoverChanged;

  const TextureWidget({super.key, this.onHoverChanged});

  @override
  ConsumerState<TextureWidget> createState() => _TextureWidgetState();
}

class _TextureWidgetState extends ConsumerState<TextureWidget> {
  bool _isHovered = false;

  Color get _borderColor {
    final isDragging = ref.watch(isDraggingItemProvider);
    if (isDragging) return const Color(0xFF222C38);
    return _isHovered ? const Color(0xFF0096cf) : const Color(0xFF222C38);
  }

  void _notifyParent(bool hovering) {
    if (widget.onHoverChanged != null) widget.onHoverChanged!(hovering);
  }

  Widget _buildContainer() {
    return Column(
      children: [
        BouncingText(
          text: 'ResourceTexture1',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
          width: 180,
        ),
        BouncingText(
          text: 'Components-0 t=40e95d0b.dds',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.none,
          ),
          width: 180,
        ),
        const SizedBox(height: 5),
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF14191F),
            border: Border.all(width: 2, color: _borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDragging = ref.watch(isDraggingItemProvider);

    return MouseRegion(
      onEnter: (_) {
        if (!isDragging) {
          setState(() => _isHovered = true);
          _notifyParent(true);
        }
      },
      onExit: (_) {
        if (!isDragging) {
          setState(() => _isHovered = false);
          _notifyParent(false);
        }
      },
      child: Listener(
        onPointerDown: (_) {
          if (!mounted) return;
          _notifyParent(false);
        },
        onPointerUp: (_) {
          if (!mounted) return;
          //schedule to next frame to make sure widget still mounted
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() => _isHovered = false);
            _notifyParent(false);
          });
        },
        behavior: HitTestBehavior.opaque,
        child: _buildContainer(),
      ),
    );
  }
}

class TextureEmptyWidget extends StatelessWidget {
  const TextureEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BouncingText(
          text: '',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
          width: 180,
        ),
        BouncingText(
          text: '',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.none,
          ),
          width: 180,
        ),
        const SizedBox(height: 5),
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF14191F),
            border: Border.all(width: 2, color: Colors.transparent),
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
            "Components",
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
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
                scrollbars: false,
              ),
              child: ListView(
                children: [
                  TextureOverrideComponentWidget(),
                  Container(height: 10),

                  TextureOverrideComponentWidget(),

                  Container(height: 10),
                  TextureOverrideComponentWidget(),

                  Container(height: 10),
                  TextureOverrideComponentWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextureOverrideComponentWidget extends StatelessWidget {
  const TextureOverrideComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: const Color(0xFF222C38)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "TextureOverrideComponent1",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 13,
              runSpacing: 13,
              children: [
                TextureSlotWidget(slotName: "Diffuse"),
                TextureSlotWidget(slotName: "Light map"),
                TextureSlotWidget(slotName: "Normal map"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextureSlotWidget extends ConsumerStatefulWidget {
  final String slotName;
  const TextureSlotWidget({super.key, required this.slotName});

  @override
  ConsumerState<TextureSlotWidget> createState() => _TextureSlotWidgetState();
}

class _TextureSlotWidgetState extends ConsumerState<TextureSlotWidget> {
  bool _blinkOn = false;
  Timer? _blinkTimer;

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    super.dispose();
  }

  void _startBlinking() {
    if (_blinkTimer != null) return;
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (!mounted) return;
      setState(() => _blinkOn = !_blinkOn);
    });
  }

  void _stopBlinking() {
    if (_blinkTimer == null) return;
    _blinkTimer!.cancel();
    _blinkTimer = null; //important: clear reference so can be restarted later
    if (mounted) setState(() => _blinkOn = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDragging = ref.watch(isDraggingItemProvider);
    const idleColor = Color(0xFF222C38);
    const blinkColor = Color(0xFF0096CF);
    const dropColor = Color(0xFFFFB454);

    if (isDragging) {
      _startBlinking();
    } else {
      _stopBlinking();
    }

    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;
        final color = isHovering
            ? dropColor //static orange if hovering to drop
            : (isDragging ? (_blinkOn ? blinkColor : idleColor) : idleColor);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: color),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF14191F),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  widget.slotName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 13,
                  runSpacing: 13,
                  children: isHovering
                      ? [TextureWidget()]
                      : const [TextureEmptyWidget()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

////////////OTHER///////////
////////////OTHER///////////
////////////OTHER///////////
