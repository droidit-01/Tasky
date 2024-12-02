class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? priority;
  String? status;
  String? assignedUser;
  int? isCompleted;

  int? color;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.assignedUser,
    this.priority,
    this.status,
    this.color,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    priority = json['priority'];
    status = json['status'];
    assignedUser = json['assignedUser'];
    color = json['color'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['priority'] = priority;
    data['status'] = status;
    data['assignedUser'] = assignedUser;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
