import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatTimeString => DateFormat('HH:mm').format(this);

  String get formatMonthYearString => DateFormat('MMM, yyyy').format(this);

  String get formatDateTimeString => DateFormat('dd/MM/yyyy HH:mm aaa').format(this);

  String get formatDateTimeStringNotification => DateFormat('dd MMM yyyy HH:mm aaa').format(this);

  String get formatTimeDateString => DateFormat('HH:mm dd/MM/yyyy').format(this);

  String get formatDayString => DateFormat('dd').format(this);

  String get formatMonthString => DateFormat('MMM').format(this);

  String get formatDateDefault => DateFormat('dd/MM/yyyy').format(this);

  String get formatDateFavourite => DateFormat('dd MMM yyyy').format(this);

  String get formatTimeFavourite => DateFormat('HH:mm aaa').format(this);

  String get formatDayOfBirthday => DateFormat('MMM dd, yyyy').format(this);

  bool  isSameDate(DateTime other) => this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
}
