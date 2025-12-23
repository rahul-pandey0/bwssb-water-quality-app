class WaterQualitySample {
  final String id;
  final String division;
  final String subDivision;
  final String serviceStation;
  final String laboratory;
  final DateTime sampleDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String location;
  final double? latitude;
  final double? longitude;
  final SampleType type;
  final Map<String, dynamic>? testResults;
  final DateTime createdAt;

  WaterQualitySample({
    required this.id,
    required this.division,
    required this.subDivision,
    required this.serviceStation,
    required this.laboratory,
    required this.sampleDate,
    this.startDate,
    this.endDate,
    required this.location,
    this.latitude,
    this.longitude,
    required this.type,
    this.testResults,
    required this.createdAt,
  });

  factory WaterQualitySample.fromJson(Map<String, dynamic> json) {
    return WaterQualitySample(
      id: json['id'],
      division: json['division'],
      subDivision: json['subDivision'],
      serviceStation: json['serviceStation'],
      laboratory: json['laboratory'],
      sampleDate: DateTime.parse(json['sampleDate']),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      type: SampleType.values.firstWhere((e) => e.toString() == json['type']),
      testResults: json['testResults'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'division': division,
      'subDivision': subDivision,
      'serviceStation': serviceStation,
      'laboratory': laboratory,
      'sampleDate': sampleDate.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toString(),
      'testResults': testResults,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum SampleType {
  serviceStation,
  wtp,
  stp,
}

class ServiceStation {
  final String id;
  final String name;
  final String division;
  final String subDivision;
  final double latitude;
  final double longitude;
  final String address;
  final bool isActive;

  ServiceStation({
    required this.id,
    required this.name,
    required this.division,
    required this.subDivision,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isActive,
  });

  factory ServiceStation.fromJson(Map<String, dynamic> json) {
    return ServiceStation(
      id: json['id'],
      name: json['name'],
      division: json['division'],
      subDivision: json['subDivision'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'division': division,
      'subDivision': subDivision,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isActive': isActive,
    };
  }
}

class Division {
  final String id;
  final String name;
  final List<SubDivision> subDivisions;

  Division({
    required this.id,
    required this.name,
    required this.subDivisions,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'],
      name: json['name'],
      subDivisions: (json['subDivisions'] as List)
          .map((e) => SubDivision.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subDivisions': subDivisions.map((e) => e.toJson()).toList(),
    };
  }
}

class SubDivision {
  final String id;
  final String name;
  final String divisionId;
  final List<ServiceStation> serviceStations;

  SubDivision({
    required this.id,
    required this.name,
    required this.divisionId,
    required this.serviceStations,
  });

  factory SubDivision.fromJson(Map<String, dynamic> json) {
    return SubDivision(
      id: json['id'],
      name: json['name'],
      divisionId: json['divisionId'],
      serviceStations: (json['serviceStations'] as List)
          .map((e) => ServiceStation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'divisionId': divisionId,
      'serviceStations': serviceStations.map((e) => e.toJson()).toList(),
    };
  }
}