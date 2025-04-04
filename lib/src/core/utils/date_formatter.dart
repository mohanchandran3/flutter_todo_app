import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMM dd, yyyy HH:mm').format(timestamp.toDate());
  }
}