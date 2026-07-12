// lib/core/widgets/app_loader.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/navigation_service.dart';

class AppLoader {
  AppLoader._();

  static OverlayEntry? _overlayEntry;
  static bool get isShowing => _overlayEntry != null;

  /// إظهار اللودر — تقدر تناديها من أي مكان: Cubit, Screen, Repository
  static void show({String? message}) {
    if (_overlayEntry != null) return; // منع التكرار لو اتنادت مرتين

    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoaderWidget(message: message),
    );

    overlayState.insert(_overlayEntry!);
  }

  /// إخفاء اللودر
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _LoaderWidget extends StatefulWidget {
  final String? message;
  const _LoaderWidget({this.message});

  @override
  State<_LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<_LoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      child: PopScope(
        canPop: false, // يمنع المستخدم يقفل اللودر بزر الرجوع
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Color(0xFFE0F2F1),
                            Color(0xFF006D5B),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.message ?? 'جاري التحميل...',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}