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
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  double _textWidth = 0;
  bool _userScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addStatusListener((status) async {
            if (_userScrolling) return;
            if (status == AnimationStatus.completed) {
              await Future.delayed(const Duration(seconds: 1));
              if (!_userScrolling) _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              await Future.delayed(const Duration(seconds: 1));
              if (!_userScrolling) _animationController.forward();
            }
          });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
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
        if (_scrollController.hasClients && !_userScrolling) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(_animationController.value * maxScroll);
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController.forward();
      });
    }
  }

  void _pauseAutoScroll() {
    if (_userScrolling) return;
    _userScrolling = true;
    _animationController.stop();
  }

  void _resumeAutoScroll() {
    if (!_userScrolling) return;
    _userScrolling = false;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_userScrolling) {
        if (_animationController.status == AnimationStatus.forward ||
            _animationController.status == AnimationStatus.reverse) {
          _animationController.forward();
        } else {
          _animationController.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      widget.text,
      style: widget.style,
      overflow: TextOverflow.visible,
      softWrap: false,
      textAlign: TextAlign.center,
    );

    if (_textWidth <= widget.width) {
      //center text if it fits
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
