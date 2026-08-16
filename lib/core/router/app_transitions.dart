import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralised page transitions so every pushed route uses a consistent,
/// subtle motion language instead of the default platform slide.
class AppTransitions {
  AppTransitions._();

  static const Duration _duration = Duration(milliseconds: 220);
  static const Duration _reverse = Duration(milliseconds: 180);

  /// Shared-axis (X) style: incoming slides in slightly from the right while
  /// fading; outgoing fades away. Used for forward drill-down navigation.
  static CustomTransitionPage<void> sharedAxis(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: _duration,
      reverseTransitionDuration: _reverse,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade-through: outgoing fades out, incoming fades in with a gentle scale.
  /// Used for terminal / celebratory screens (e.g. booking confirmation).
  static CustomTransitionPage<void> fadeThrough(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: _duration,
      reverseTransitionDuration: _reverse,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
