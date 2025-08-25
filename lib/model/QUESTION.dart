class StationApi {
  final int id;
  final String stationNumber;
  final String stationName;
  final String? location;
  final String? description;

  StationApi({
    required this.id,
    required this.stationNumber,
    required this.stationName,
    this.location,
    this.description,
  });

  factory StationApi.fromJson(Map<String, dynamic> j) => StationApi(
    id: j['id'] ?? 0,
    stationNumber: j['station_number']?.toString() ?? '',
    stationName: j['station_name']?.toString() ?? '',
    location: j['location']?.toString(),
    description: j['description']?.toString(),
  );

  @override
  String toString() => stationNumber; // used by dropdown_search
}

class QuestionApi {
  final int id;
  final String text;
  final List<String> options;
  final String textOnReport;
  final String serialNumber;
  final int total;
  final String type; // "checkbox" | "radio" (API shows "checkbox")
  final String? group; // null in sample; optional future use

  QuestionApi({
    required this.id,
    required this.text,
    required this.options,
    required this.textOnReport,
    required this.serialNumber,
    required this.total,
    required this.type,
    this.group,
  });

  factory QuestionApi.fromJson(Map<String, dynamic> j) => QuestionApi(
    id: j['id'] ?? 0,
    text: j['text']?.toString() ?? '',
    options: (j['options'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    textOnReport: j['text_on_report']?.toString() ?? '',
    serialNumber: j['serial_number']?.toString() ?? '',
    total: j['total'] ?? 0,
    type: j['type']?.toString() ?? 'checkbox',
    group: j['group']?.toString(),
  );
}