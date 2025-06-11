class EmergencyNote {
  final String id;
  final String userId;
  final String name;
  final String relation;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmergencyNote({
    required this.id,
    required this.userId,
    required this.name,
    required this.relation,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmergencyNote.fromJson(Map<String, dynamic> json) {
    return EmergencyNote(
      id: json['id'] ?? json['_id'],
      userId: json['userId'] ?? json['user'],
      name: json['name'],
      relation: json['relation'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'relation': relation,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 