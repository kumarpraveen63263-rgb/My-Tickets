import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDayMonth(DateTime date) =>
      DateFormat('d MMM').format(date);

  static String formatFullDate(DateTime date) =>
      DateFormat('EEE, d MMM yyyy').format(date);

  static String formatDayLabel(DateTime date) => DateFormat('EEE').format(date);

  static String formatDayNumber(DateTime date) => DateFormat('d').format(date);

  static String formatMonthAbbrev(DateTime date) =>
      DateFormat('MMM').format(date);

  static String formatDayMonthYear(DateTime date) =>
      DateFormat('d MMM, yyyy').format(date);

  static String formatTime(DateTime date) => DateFormat('h:mm a').format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static String formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  static String formatCountdown(Duration duration) {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static List<DateTime> nextNDays(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) => DateTime(now.year, now.month, now.day + i));
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
