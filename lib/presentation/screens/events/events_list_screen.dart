import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../providers/event_provider.dart';
import '../../widgets/common/app_chip.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/home/event_card.dart';

final _eventCategoryProvider = StateProvider.autoDispose<String>(
  (ref) => 'All',
);

class EventsListScreen extends ConsumerWidget {
  /// When rendered as a bottom-nav tab root there is nothing to pop, so the
  /// back button is hidden. When pushed from elsewhere it shows normally.
  final bool isTab;

  EventsListScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final category = ref.watch(_eventCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isTab
            ? null
            : IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_rounded),
              ),
        title: Text(context.tr('Events')),
      ),
      body: eventsAsync.when(
        loading: () => ListView(
          children: [
            ShimmerTicketCard(),
            ShimmerTicketCard(),
            ShimmerTicketCard(),
          ],
        ),
        error: (_, _) =>
            AppErrorWidget(onRetry: () => ref.invalidate(eventsProvider)),
        data: (events) {
          final categories = [
            'All',
            ...{for (final e in events) e.category},
          ];
          final filtered = category == 'All'
              ? events
              : events.where((e) => e.category == category).toList();
          return Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                  ),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemBuilder: (_, i) => AppChip(
                    label: categories[i],
                    accentColor: AppColors.accentEvent,
                    isSelected: category == categories[i],
                    onTap: () =>
                        ref.read(_eventCategoryProvider.notifier).state =
                            categories[i],
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? AppEmptyState(
                        icon: Icons.event_busy_rounded,
                        title: context.tr('No events found'),
                      )
                    : RefreshIndicator(
                        color: AppColors.accentEvent,
                        onRefresh: () async {
                          ref.invalidate(eventsProvider);
                          await Future.delayed(Duration(milliseconds: 500));
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            AppDimensions.paddingMedium,
                            AppDimensions.paddingSmall,
                            AppDimensions.paddingMedium,
                            AppDimensions.bottomPadding,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: AppDimensions.paddingMedium),
                          itemBuilder: (_, i) =>
                              _EventListTile(event: filtered[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EventListTile extends StatelessWidget {
  final EventModel event;

  _EventListTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: EventCard(event: event, width: double.infinity),
    );
  }
}
