bool isYesterday(DateTime date1, DateTime date2) {
  return date1.day == date2.day - 1 &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

bool isToday(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

int daysBetweenDates(DateTime date1, DateTime date2) {
  return date2.difference(date1).inDays.abs();
}
