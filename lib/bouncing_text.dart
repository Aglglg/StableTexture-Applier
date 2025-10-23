import 'dart:ui';

import 'package:flutter/material.dart';

class BouncingText extends StatefulWidget {
  final String text;
  final double width;
  final TextStyle style;

  const BouncingText({
    super.key,
    required this.text,
    required this.width,
    required this.style,
  });

  @override
  State<BouncingText> createState() => _BouncingTextState();
}

class _BouncingTextState extends State<BouncingText>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  double _textWidth = 0;
  bool _userScrolling = false;
  bool _mounted = true;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addStatusListener((status) async {
            if (!_mounted || _userScrolling) return;

            if (status == AnimationStatus.completed) {
              await Future.delayed(const Duration(seconds: 1));
              if (_mounted && !_userScrolling) _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              await Future.delayed(const Duration(seconds: 1));
              if (_mounted && !_userScrolling) _animationController.forward();
            }
          });
  }

  @override
  void dispose() {
    _mounted = false;
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tp = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    _textWidth = tp.size.width;

    if (_textWidth > widget.width) {
      _animationController.addListener(() {
        if (_mounted &&
            _scrollController.hasClients &&
            !_userScrolling &&
            _scrollController.position.hasContentDimensions) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(_animationController.value * maxScroll);
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_mounted) _animationController.forward();
      });
    }
  }

  void _pauseAutoScroll() {
    if (!_mounted) return;
    _userScrolling = true;
    _animationController.stop();
  }

  void _resumeAutoScroll() {
    if (!_mounted) return;
    Future.delayed(const Duration(seconds: 2), () {
      if (_mounted && !_userScrolling) {
        _animationController.forward();
      }
    });
    _userScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final textWidget = Text(
      widget.text,
      style: widget.style,
      overflow: TextOverflow.visible,
      softWrap: false,
      textAlign: TextAlign.center,
    );

    if (_textWidth <= widget.width) {
      return SizedBox(
        width: widget.width,
        child: Center(child: textWidget),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.style.fontSize! * 1.6,
      child: Listener(
        onPointerDown: (_) => _pauseAutoScroll(),
        onPointerUp: (_) => _resumeAutoScroll(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
            scrollbars: false,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: textWidget,
          ),
        ),
      ),
    );
  }
}
