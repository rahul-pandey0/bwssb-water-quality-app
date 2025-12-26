class ServiceStationValidator {
  static String? requiredField(String? v, String label) {
    if (v == null || v.isEmpty) return 'Enter $label';
    return null;
  }

  static String? requiredDropdown(dynamic v, String label) {
    if (v == null) return 'Select $label';
    return null;
  }

  static String? validateDates(DateTime? start, DateTime? end) {
    if (start != null && end != null && end.isBefore(start)) {
      return 'End date must be after start date';
    }
    return null;
  }
}
