import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/ticket_model.dart';
import '../../../providers/booking_provider.dart';

class TicketReportScreen extends ConsumerWidget {
  const TicketReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(allBookingsProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Report'),
        actions: [
          IconButton(
            tooltip: 'Refresh report',
            onPressed: () => ref.invalidate(allBookingsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: bookings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load ticket data.\n$error', textAlign: TextAlign.center),
          ),
        ),
        data: (items) => _ReportBody(bookings: items, colors: colors),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  final List<BookingModel> bookings;
  final ColorScheme colors;

  const _ReportBody({required this.bookings, required this.colors});

  @override
  Widget build(BuildContext context) {
    final completed = bookings.where((b) => b.status == TicketStatus.completed).length;
    final upcoming = bookings.where((b) => b.status == TicketStatus.upcoming).length;
    final cancelled = bookings.where((b) => b.status == TicketStatus.cancelled).length;
    final expired = bookings.where((b) => b.status == TicketStatus.expired).length;
    final totalSpend = bookings.fold<double>(0, (sum, booking) => sum + booking.totalAmount);
    final averageSpend = bookings.isEmpty ? 0.0 : totalSpend / bookings.length;
    final maxCount = [completed, upcoming, cancelled, expired].fold<int>(1, (max, value) => value > max ? value : max);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text('Your ticket activity', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('A live overview of bookings saved in this account.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Total bookings', value: '${bookings.length}', icon: Icons.confirmation_number_outlined, color: colors.primary)),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(label: 'Total spend', value: '₹${totalSpend.toStringAsFixed(0)}', icon: Icons.account_balance_wallet_outlined, color: colors.tertiary)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Completed', value: '$completed', icon: Icons.check_circle_outline_rounded, color: Colors.greenAccent.shade400)),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(label: 'Average spend', value: '₹${averageSpend.toStringAsFixed(0)}', icon: Icons.trending_up_rounded, color: colors.secondary)),
          ],
        ),
        const SizedBox(height: 28),
        Text('Booking status', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        _StatusBar(label: 'Upcoming', count: upcoming, total: maxCount, color: colors.primary),
        _StatusBar(label: 'Completed', count: completed, total: maxCount, color: Colors.greenAccent.shade400),
        _StatusBar(label: 'Cancelled', count: cancelled, total: maxCount, color: colors.error),
        _StatusBar(label: 'Expired', count: expired, total: maxCount, color: colors.onSurfaceVariant),
        const SizedBox(height: 28),
        Text('Recent activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        if (bookings.isEmpty)
          _EmptyState(colors: colors)
        else
          ...bookings.take(5).map((booking) => _BookingRow(booking: booking, colors: colors)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 14),
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusBar({required this.label, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(children: [
        Row(children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text('$count', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: count / total, minHeight: 8, backgroundColor: theme.colorScheme.surfaceContainerHighest, valueColor: AlwaysStoppedAnimation<Color>(color)),
        ),
      ]),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final BookingModel booking;
  final ColorScheme colors;

  const _BookingRow({required this.booking, required this.colors});

  @override
  Widget build(BuildContext context) {
    final statusColor = booking.status == TicketStatus.completed ? Colors.greenAccent.shade400 : booking.status == TicketStatus.cancelled ? colors.error : colors.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(color: colors.surfaceContainerHighest.withValues(alpha: 0.38), borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        CircleAvatar(radius: 18, backgroundColor: statusColor.withValues(alpha: 0.14), child: Icon(Icons.local_activity_outlined, size: 19, color: statusColor)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(booking.referenceId.isEmpty ? 'Ticket booking' : booking.referenceId, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text('${booking.type.name} • ${_formatDate(booking.createdAt)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
        ])),
        Text('₹${booking.totalAmount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      ]),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: colors.surfaceContainerHighest.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(16)),
    child: Column(children: [
      Icon(Icons.analytics_outlined, size: 36, color: colors.onSurfaceVariant),
      const SizedBox(height: 10),
      const Text('No ticket activity yet.'),
      const SizedBox(height: 4),
      Text('Your report will update after your first booking.', style: TextStyle(color: colors.onSurfaceVariant), textAlign: TextAlign.center),
    ]),
  );
}
