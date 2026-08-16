import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/booking_model.dart';
import '../data/models/ticket_model.dart';
import 'booking_provider.dart';

final ticketTabIndexProvider = StateProvider<int>((ref) => 0);

const List<TicketStatus> ticketTabs = [
  TicketStatus.upcoming,
  TicketStatus.completed,
  TicketStatus.cancelled,
  TicketStatus.expired,
];

final ticketsForTabProvider = Provider<AsyncValue<List<BookingModel>>>((ref) {
  final tabIndex = ref.watch(ticketTabIndexProvider);
  final status = ticketTabs[tabIndex];
  final allBookings = ref.watch(allBookingsProvider);
  return allBookings.whenData(
    (bookings) => bookings.where((b) => b.status == status).toList(),
  );
});
