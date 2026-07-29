import 'package:flutter/material.dart';

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.controller,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 42,
  });

  final ScrollController controller;
  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _opacity = CurvedAnimation(parent: _animation, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animation, curve: Curves.easeOutCubic),
    );
    widget.controller.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (_revealed || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top < viewport * 0.92) {
      _revealed = true;
      Future<void>.delayed(widget.delay, () {
        if (mounted) _animation.forward();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkVisibility);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: AnimatedBuilder(
        animation: _slide,
        builder: (context, child) {
          return Transform.translate(offset: _slide.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
