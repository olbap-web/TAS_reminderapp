class Reminder {
  final String title;
  final DateTime time;

  Reminder({required this.title, required this.time});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      title: json['title'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time.toIso8601String(),
    };
  }
}
