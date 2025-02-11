class TimeService {
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '''${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago''';
    } else if (difference.inMinutes > 0) {
      return '''${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago''';
    } else {
      return 'just now';
    }
  }
}
