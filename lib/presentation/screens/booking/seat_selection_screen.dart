import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/models/show_model.dart';
import '../../../data/models/ticket_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/movie_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_loader.dart';
import '../../widgets/seat/seat_legend.dart';
import '../../widgets/seat/seat_map_widget.dart';
import '../../widgets/seat/seat_timer_widget.dart';

class SeatSelectionScreen extends ConsumerWidget {
  final String movieId;
  final String showId;
  final String theatreName;

  SeatSelectionScreen({
    super.key,
    required this.movieId,
    required this.showId,
    required this.theatreName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));
    final showAsync = ref.watch(
      showByIdProvider((movieId: movieId, showId: showId)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: movieAsync.maybeWhen(
          data: (m) => Text(
            '${m.title} · $theatreName',
            overflow: TextOverflow.ellipsis,
          ),
          orElse: () => Text(context.tr('Select Seats')),
        ),
      ),
      body: movieAsync.when(
        loading: () => AppLoader(),
        error: (_, _) => Center(child: Text('Failed to load')),
        data: (movie) => showAsync.when(
          loading: () => AppLoader(),
          error: (_, _) => Center(child: Text('Failed to load show')),
          data: (show) {
            if (show == null) return Center(child: Text('Show not found'));
            return _SeatBody(
              movie: movie,
              show: show,
              theatreName: theatreName,
            );
          },
        ),
      ),
    );
  }
}

class _SeatBody extends ConsumerWidget {
  final MovieModel movie;
  final ShowModel show;
  final String theatreName;

  _SeatBody({
    required this.movie,
    required this.show,
    required this.theatreName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (
      show: show,
      movieTitle: movie.title,
      theatreName: theatreName,
    );
    final state = ref.watch(seatSelectionProvider(args));
    final notifier = ref.read(seatSelectionProvider(args).notifier);

    final selected = state.selectedSeats;
    final subtotal = state.subtotal;
    final convenienceFee = selected.length * 30.0;
    final total = subtotal + convenienceFee;

    return Column(
      children: [
        SeatTimerWidget(remaining: state.remaining),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
          child: Column(
            children: [
              Container(
                width: 220,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentMovie.withValues(alpha: 0.1),
                      AppColors.accentMovie,
                      AppColors.accentMovie.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'SCREEN',
                style: AppTypography.caption.copyWith(letterSpacing: 4),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.expired
              ? _expiredState(ref, args)
              : SingleChildScrollView(
                  child: SeatMapWidget(
                    seats: state.seats,
                    onSeatTap: (id) {
                      final error = notifier.toggleSeat(id);
                      if (error != null)
                        context.showSnack(error, isError: true);
                    },
                  ),
                ),
        ),
        SeatLegend(),
        SizedBox(height: AppDimensions.paddingSmall),
        _bottomPanel(context, ref, selected, subtotal, total, state.expired),
      ],
    );
  }

  Widget _expiredState(
    WidgetRef ref,
    ({ShowModel show, String movieTitle, String theatreName}) args,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_off_rounded, color: AppColors.error, size: 48),
          SizedBox(height: 12),
          Text('Your seat hold has expired', style: AppTypography.titleLarge),
          SizedBox(height: 16),
          AppButton(
            label: 'Start Over',
            fullWidth: false,
            onPressed: () => ref.invalidate(seatSelectionProvider(args)),
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> selected,
    double subtotal,
    double total,
    bool expired,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selected.map((s) => s.label as String).join(', '),
                      style: AppTypography.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    CurrencyUtils.format(total),
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.accentMovie,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingSmall),
            ],
            AppButton(
              label: selected.isEmpty
                  ? context.tr('Select Seats')
                  : 'Proceed to Checkout (${selected.length})',
              onPressed: selected.isEmpty || expired
                  ? null
                  : () {
                      ref
                          .read(bookingDraftProvider.notifier)
                          .set(
                            BookingDraft(
                              type: BookingType.movie,
                              referenceId: movie.id,
                              title: movie.title,
                              imageUrl: movie.posterUrl,
                              venue: theatreName,
                              date: show.date,
                              time: show.time,
                              seats: selected
                                  .map<String>((s) => s.label as String)
                                  .toList(),
                              quantity: selected.length,
                              subtotal: subtotal,
                              screen: show.screen,
                            ),
                          );
                      context.push('/booking/checkout');
                    },
            ),
          ],
        ),
      ),
    );
  }
}
