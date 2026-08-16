class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}

/// Mock notification service — no real push integration, backs the
/// notification bell/badge on the Home screen with local mock data.
class NotificationService {
  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Booking Confirmed',
      body: 'Your tickets for Kalki 2898 AD are confirmed.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 'n2',
      title: 'Limited Time Offer',
      body: 'Get 20% off on your next event booking. Use code EVENT20.',
      time: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AppNotification(
      id: 'n3',
      title: 'Show Reminder',
      body: 'Your show starts in 3 hours at PVR Ampa Skywalk.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  Future<List<AppNotification>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _notifications;
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
