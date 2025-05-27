class Reminder {
  final String id;
  final String title;
  final DateTime time;
  final bool completed;

  Reminder({required this.id, required this.title, required this.time, required this.completed});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id:json['id'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      completed:json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'time': time.toIso8601String(),
      'completed':completed,
    };
  }

  Reminder copyWith({
    String? id,
    String? title,
    DateTime? time,
    bool? completed,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
}


