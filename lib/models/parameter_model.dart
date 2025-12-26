class Parameter {
  final int id;
  final String name;
  final String unit;
  final String desiredLimit;
  final String permissibleLimit;

  String result = '';
  String remark = '';

  Parameter({
    required this.id,
    required this.name,
    required this.unit,
    required this.desiredLimit,
    required this.permissibleLimit,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      id: json['i_ParameterId'],
      name: json['s_ParameterName'],
      unit: json['s_Unit'] ?? '',
      desiredLimit: json['f_DesiredLimit']?.toString() ?? '',
      permissibleLimit: json['f_PermissibleLimit']?.toString() ?? '',
    );
  }
}
