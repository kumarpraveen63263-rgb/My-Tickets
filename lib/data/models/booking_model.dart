import 'ticket_model.dart';

class BookingModel {
  final String id;
  final String bookingId;
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
  final double convenienceFee;
  final double gst;
  final double discount;
  final double totalAmount;
  final TicketStatus status;
  final DateTime createdAt;
  final String? screen;
  final String? fromStation;
  final String? toStation;

  const BookingModel({
    required this.id,
    required this.bookingId,
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
    required this.convenienceFee,
    required this.gst,
    required this.discount,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.screen,
    this.fromStation,
    this.toStation,
  });

  BookingModel copyWith({TicketStatus? status}) {
    return BookingModel(
      id: id,
      bookingId: bookingId,
      type: type,
      referenceId: referenceId,
      title: title,
      imageUrl: imageUrl,
      venue: venue,
      date: date,
      time: time,
      seats: seats,
      quantity: quantity,
      subtotal: subtotal,
      convenienceFee: convenienceFee,
      gst: gst,
      discount: discount,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
      screen: screen,
      fromStation: fromStation,
      toStation: toStation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'type': type.name,
      'referenceId': referenceId,
      'title': title,
      'imageUrl': imageUrl,
      'venue': venue,
      'date': date.toIso8601String(),
      'time': time,
      'seats': List<String>.from(seats),
      'quantity': quantity,
      'subtotal': subtotal,
      'convenienceFee': convenienceFee,
      'gst': gst,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'screen': screen,
      'fromStation': fromStation,
      'toStation': toStation,
    };
  }

  factory BookingModel.fromMap(Map<dynamic, dynamic> map) {
    BookingType parseType() {
      return BookingType.values.firstWhere(
        (value) => value.name == map['type'],
        orElse: () => BookingType.movie,
      );
    }

    TicketStatus parseStatus() {
      return TicketStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => TicketStatus.upcoming,
      );
    }

    DateTime parseDate(String key) {
      return DateTime.tryParse(map[key]?.toString() ?? '') ?? DateTime.now();
    }

    return BookingModel(
      id: map['id']?.toString() ?? '',
      bookingId: map['bookingId']?.toString() ?? '',
      type: parseType(),
      referenceId: map['referenceId']?.toString() ?? '',
      title: map['title']?.toString() ?? 'MyTickets Booking',
      imageUrl: map['imageUrl']?.toString() ?? '',
      venue: map['venue']?.toString() ?? '',
      date: parseDate('date'),
      time: map['time']?.toString() ?? '',
      seats: List<String>.from((map['seats'] as List?) ?? const <String>[]),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      convenienceFee: (map['convenienceFee'] as num?)?.toDouble() ?? 0,
      gst: (map['gst'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0,
      status: parseStatus(),
      createdAt: parseDate('createdAt'),
      screen: map['screen']?.toString(),
      fromStation: map['fromStation']?.toString(),
      toStation: map['toStation']?.toString(),
    );
  }
}

class BookingStorage {
  BookingStorage._();

  static const String schemaVersion = '1';
}
