import '../../../core/localization/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/ticket_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/event_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/app_loader.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));
    final selectedCategory = ref.watch(selectedTicketCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: eventAsync.when(
        loading: () => AppLoader(color: AppColors.accentEvent),
        error: (_, _) => AppErrorWidget(
          onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
        ),
        data: (event) => _content(context, ref, event, selectedCategory),
      ),
      bottomNavigationBar: eventAsync.maybeWhen(
        data: (event) => SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: AppButton(
              label: context.tr('Book Tickets'),
              accentColor: AppColors.accentEvent,
              size: AppButtonSize.large,
              icon: Icons.confirmation_number_rounded,
              onPressed: () => _book(context, ref, event, selectedCategory),
            ),
          ),
        ),
        orElse: () => SizedBox.shrink(),
      ),
    );
  }

  void _book(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    String? selectedCategory,
  ) {
    final category = event.ticketCategories.firstWhere(
      (c) => c.name == selectedCategory,
      orElse: () => event.ticketCategories.first,
    );
    ref
        .read(bookingDraftProvider.notifier)
        .set(
          BookingDraft(
            type: BookingType.event,
            referenceId: event.id,
            title: event.title,
            imageUrl: event.bannerUrl,
            venue: '${event.venue}, ${event.city}',
            date: event.date,
            time: event.time,
            seats: [],
            quantity: 1,
            subtotal: category.price,
          ),
        );
    context.push('/booking/checkout');
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    String? selectedCategory,
  ) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.bannerUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                        stops: [0.5, 1],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentEvent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event.category,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(event.title, style: AppTypography.displaySmall),
                  SizedBox(height: 12),
                  _infoRow(
                    Icons.calendar_today_rounded,
                    AppDateUtils.formatFullDate(event.date),
                  ),
                  _infoRow(Icons.access_time_rounded, event.time),
                  _infoRow(
                    Icons.location_on_rounded,
                    '${event.venue}, ${event.city}',
                  ),
                  _infoRow(
                    Icons.person_rounded,
                    'Organized by ${event.organizer}',
                  ),
                  SizedBox(height: AppDimensions.paddingMedium),
                  Text(context.tr('About'), style: AppTypography.titleLarge),
                  SizedBox(height: 6),
                  Text(
                    event.description,
                    style: AppTypography.bodyMedium.copyWith(height: 1.5),
                  ),
                  SizedBox(height: AppDimensions.paddingLarge),
                  Text(
                    'Select Ticket Category',
                    style: AppTypography.titleLarge,
                  ),
                  SizedBox(height: AppDimensions.paddingSmall),
                  ...event.ticketCategories.map(
                    (c) => _ticketCategoryTile(ref, c, selectedCategory),
                  ),
                  SizedBox(height: AppDimensions.bottomPadding),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.accentEvent),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketCategoryTile(
    WidgetRef ref,
    TicketCategoryModel category,
    String? selected,
  ) {
    final isSelected = category.name == selected;
    return GestureDetector(
      onTap: () => ref.read(selectedTicketCategoryProvider.notifier).state =
          category.name,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentEvent.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.accentEvent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? AppColors.accentEvent
                  : AppColors.textSecondary,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: AppTypography.titleMedium),
                  Text(
                    '${category.available} available',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            Text(
              category.price == 0
                  ? 'Free'
                  : CurrencyUtils.format(category.price),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.accentEvent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
