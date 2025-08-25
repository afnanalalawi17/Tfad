class StationResponse {
  final String message;
  final List<Station> stations;
  final List<Question> questions;

  StationResponse({
    required this.message,
    required this.stations,
    required this.questions,
  });

  factory StationResponse.fromJson(Map<String, dynamic> json) {
    return StationResponse(
      message: json['message'],
      stations: (json['stations'] as List)
          .map((e) => Station.fromJson(e))
          .toList(),
      questions: (json['questions'] as List)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}

class Station {
  final int id;
  final String stationNumber;
  final String stationName;
  final String location;
  final String? description;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final Creator creator;

  Station({
    required this.id,
    required this.stationNumber,
    required this.stationName,
    required this.location,
    this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.creator,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      stationNumber: json['station_number'],
      stationName: json['station_name'],
      location: json['location'],
      description: json['description'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      creator: Creator.fromJson(json['creator']),
    );
  }
}

class Creator {
  final int id;
  final String name;

  Creator({required this.id, required this.name});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Question {
  final int id;
  final String text;
  final List<String> options;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
