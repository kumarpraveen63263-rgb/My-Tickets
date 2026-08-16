import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../data/models/booking_model.dart';
import '../data/models/seat_model.dart';
import '../data/models/show_model.dart';
import '../data/models/ticket_model.dart';
import '../data/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(),
);

// ---------------- Seat selection ----------------

class SeatSelectionState {
  final ShowModel show;
  final String movieTitle;
  final String theatreName;
  final List<SeatModel> seats;
  final Set<String> selectedIds;
  final Duration remaining;
  final bool expired;

  const SeatSelectionState({
    required this.show,
    required this.movieTitle,
    required this.theatreName,
    required this.seats,
    this.selectedIds = const {},
    this.remaining = const Duration(minutes: AppConstants.seatHoldMinutes),
    this.expired = false,
  });

  List<SeatModel> get selectedSeats =>
      seats.where((s) => selectedIds.contains(s.id)).toList();

  double get subtotal => selectedSeats.fold(0.0, (sum, s) => sum + s.price);

  SeatSelectionState copyWith({
    List<SeatModel>? seats,
    Set<String>? selectedIds,
    Duration? remaining,
    bool? expired,
  }) {
    return SeatSelectionState(
      show: show,
      movieTitle: movieTitle,
      theatreName: theatreName,
      seats: seats ?? this.seats,
      selectedIds: selectedIds ?? this.selectedIds,
      remaining: remaining ?? this.remaining,
      expired: expired ?? this.expired,
    );
  }
}

class SeatSelectionNotifier extends StateNotifier<SeatSelectionState> {
  Timer? _timer;

  SeatSelectionNotifier(ShowModel show, String movieTitle, String theatreName)
    : super(
        SeatSelectionState(
          show: show,
          movieTitle: movieTitle,
          theatreName: theatreName,
          seats: BookingRepository.generateSeatsForShow(show),
        ),
      ) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newRemaining = state.remaining - const Duration(seconds: 1);
      if (newRemaining.isNegative || newRemaining.inSeconds == 0) {
        state = state.copyWith(remaining: Duration.zero, expired: true);
        timer.cancel();
      } else {
        state = state.copyWith(remaining: newRemaining);
      }
    });
  }

  String? toggleSeat(String seatId) {
    final seat = state.seats.firstWhere((s) => s.id == seatId);
    if (seat.isBooked) return null;

    final selected = {...state.selectedIds};
    if (selected.contains(seatId)) {
      selected.remove(seatId);
    } else {
      if (selected.length >= AppConstants.maxSeatsPerBooking) {
        return 'You can select up to ${AppConstants.maxSeatsPerBooking} seats only';
      }
      selected.add(seatId);
    }
    state = state.copyWith(selectedIds: selected);
    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final seatSelectionProvider = StateNotifierProvider.autoDispose
    .family<
      SeatSelectionNotifier,
      SeatSelectionState,
      ({ShowModel show, String movieTitle, String theatreName})
    >(
      (ref, args) =>
          SeatSelectionNotifier(args.show, args.movieTitle, args.theatreName),
    );

// ---------------- Booking draft (carried into checkout) ----------------

class BookingDraft {
  final BookingType type;
  final String referenceId;
  final String title;
  final String imageUrl;
  final String venue;
  final DateTime date;
  final String time;
  final List<String> seats;
  final int quantity;
  final double subtotal;
  final String? screen;
  final String? fromStation;
  final String? toStation;

  const BookingDraft({
    required this.type,
    required this.referenceId,
    required this.title,
    required this.imageUrl,
    required this.venue,
    required this.date,
    required this.time,
    required this.seats,
    required this.quantity,
    required this.subtotal,
    this.screen,
    this.fromStation,
    this.toStation,
  });
}

class BookingDraftNotifier extends StateNotifier<BookingDraft?> {
  BookingDraftNotifier() : super(null);

  void set(BookingDraft draft) => state = draft;
  void clear() => state = null;
}

final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft?>((ref) {
      return BookingDraftNotifier();
    });

// ---------------- Checkout ----------------

final appliedOfferCodeProvider = StateProvider<String?>((ref) => null);
final appliedDiscountProvider = StateProvider<double>((ref) => 0);
final selectedPaymentMethodProvider = StateProvider<String>((ref) => 'UPI');

final lastBookingProvider = StateProvider<BookingModel?>((ref) => null);

// ---------------- My Tickets ----------------

final allBookingsProvider = FutureProvider<List<BookingModel>>((ref) {
  return ref.watch(bookingRepositoryProvider).getAll();
});

final bookingByIdProvider = FutureProvider.family<BookingModel?, String>((
  ref,
  id,
) {
  return ref.watch(bookingRepositoryProvider).getById(id);
});
