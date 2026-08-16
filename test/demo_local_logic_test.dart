import 'package:flutter_test/flutter_test.dart';
import 'package:mytick/data/models/booking_model.dart';
import 'package:mytick/data/models/show_model.dart';
import 'package:mytick/data/models/ticket_model.dart';
import 'package:mytick/data/repositories/booking_repository.dart';
import 'package:mytick/data/repositories/offer_repository.dart';

void main() {
  test('booking models round-trip through local storage maps', () {
    final original = BookingModel(
      id: 'demo-1',
      bookingId: 'MTDEMO01',
      type: BookingType.movie,
      referenceId: 'm001',
      title: 'Demo Movie',
      imageUrl: 'image',
      venue: 'Demo Theatre',
      date: DateTime(2026, 8, 16),
      time: '7:30 PM',
      seats: const ['A1', 'A2'],
      quantity: 2,
      subtotal: 760,
      convenienceFee: 30,
      gst: 142.2,
      discount: 100,
      totalAmount: 832.2,
      status: TicketStatus.upcoming,
      createdAt: DateTime(2026, 8, 16, 10),
      screen: 'Screen 1',
    );

    final restored = BookingModel.fromMap(original.toMap());

    expect(restored.id, original.id);
    expect(restored.bookingId, original.bookingId);
    expect(restored.type, original.type);
    expect(restored.seats, original.seats);
    expect(restored.totalAmount, original.totalAmount);
    expect(restored.screen, original.screen);
  });

  test('seat generation is deterministic for the same show', () {
    final show = ShowModel(
      id: 'show-demo',
      movieId: 'm001',
      theatreId: 't001',
      date: DateTime(2026, 8, 20),
      time: '7:30 PM',
      screen: 'Screen 1',
      availability: ShowAvailability.fastFilling,
    );

    final first = BookingRepository.generateSeatsForShow(show);
    final second = BookingRepository.generateSeatsForShow(show);

    expect(
      first.map((seat) => seat.isBooked).toList(),
      second.map((seat) => seat.isBooked).toList(),
    );
    expect(first.length, second.length);
  });

  test(
    'coupon validation is case-insensitive and rejects unknown codes',
    () async {
      final repository = OfferRepository();

      expect(await repository.validateCode('first100'), isNotNull);
      expect(await repository.validateCode('not-a-real-code'), isNull);
    },
  );
}
