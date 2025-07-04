class RestData {
  int userId;
  int id;
  String title;
  int value;

  RestData({
    required this.userId,
    required this.id,
    required this.title,
    required this.value,
  });
  factory RestData.fromMap(Map<String, dynamic> map) {
    return RestData(
      userId: map['userId'],
      id: map['id'],
      title: map['title'],
      value: map['value'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'userId': userId, 'id': id, 'title': title, 'value': value};
  }
}
