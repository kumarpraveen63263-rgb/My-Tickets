enum TicketStatus { upcoming, completed, cancelled, expired }

enum BookingType { movie, event, metro }

extension TicketStatusX on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.upcoming:
        return 'Upcoming';
      case TicketStatus.completed:
        return 'Completed';
      case TicketStatus.cancelled:
        return 'Cancelled';
      case TicketStatus.expired:
        return 'Expired';
    }
  }
}

extension BookingTypeX on BookingType {
  String get label {
    switch (this) {
      case BookingType.movie:
        return 'Movie';
      case BookingType.event:
        return 'Event';
      case BookingType.metro:
        return 'Metro';
    }
  }
}
