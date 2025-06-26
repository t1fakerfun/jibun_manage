class HPData {
  int userId;
  int id;
  int health;
  String updatedAt;

  HPData({
    required this.userId,
    required this.id,
    required this.health,
    required this.updatedAt,
  });

  // Factory method to create an instance from a map
  factory HPData.fromMap(Map<String, dynamic> map) {
    return HPData(
      userId: map['userId'],
      id: map['id'],
      health: map['health'],
      updatedAt: map['updated_at'],
    );
  }

  // Method to convert the instance to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'health': health, 'updated_at': updatedAt};
  }
}
