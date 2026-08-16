class AppConstants {
  AppConstants._();

  static const String appName = 'MyTickets';
  static const String appTagline = 'Every Experience. One Ticket.';

  static const int otpLength = 6;
  static const String demoOtp = '123456';
  static const int otpResendSeconds = 30;
  static const int seatHoldMinutes = 10;
  static const int metroTicketValidMinutes = 90;
  static const int maxSeatsPerBooking = 10;
  static const int maxMetroPassengers = 6;

  static const double gstRate = 0.18;
  static const double convenienceFeePerTicket = 30.0;

  static const String defaultCity = 'Chennai, Tamil Nadu';

  static const List<String> languages = [
    'Telugu',
    'Tamil',
    'Hindi',
    'Malayalam',
    'Kannada',
    'English',
  ];

  static const List<String> genres = [
    'Action',
    'Drama',
    'Sci-Fi',
    'Thriller',
    'Comedy',
    'Romance',
    'Fantasy',
    'Crime',
  ];

  // Hive box names
  static const String boxAuth = 'auth_box';
  static const String boxTickets = 'tickets_box';
  static const String boxSearch = 'search_box';
  static const String boxSettings = 'settings_box';
  static const String boxFavourites = 'favourites_box';
}
