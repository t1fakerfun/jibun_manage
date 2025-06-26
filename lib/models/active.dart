class ActiveData {
  int userId;
  int id;
  String title;
  int value;

  ActiveData({
    required this.userId,
    required this.id,
    required this.title,
    required this.value,
  });
  factory ActiveData.fromMap(Map<String, dynamic> map) {
    return ActiveData(
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
