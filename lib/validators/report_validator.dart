class ReportValidator {
  static String? validateDates(DateTime? start, DateTime? end) {
    if (start == null) return 'Select start date';
    if (end == null) return 'Select end date';
    if (end.isBefore(start)) return 'End date must be after start date';
    return null;
  }
}
