import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/services/connectivity_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final isConnectedProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(isConnectedProvider);
    final isOffline = connected.maybeWhen(data: (v) => !v, orElse: () => false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: isOffline ? 32 : 0,
      color: AppColors.warning,
      alignment: Alignment.center,
      child: isOffline
          ? Text(
              'No internet connection',
              style: AppTypography.caption.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}
