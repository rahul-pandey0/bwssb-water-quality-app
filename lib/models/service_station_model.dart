class ServiceStation {
  final int id;
  final String division;
  final String subDivision;
  final String name;

  ServiceStation({
    required this.id,
    required this.division,
    required this.subDivision,
    required this.name,
  });

  factory ServiceStation.fromJson(Map<String, dynamic> json) {
    return ServiceStation(
      id: json['i_ServiceStationId'],
      division: json['s_DivisionName'],
      subDivision: json['s_SubDivisionName'],
      name: json['s_ServiceStationName'],
    );
  }
}
