enum TodoModelPriority { low, medium, high }

class TodoModel {
  String? id;
  String? title;
  String? description;
  TodoModelPriority? priority;
  bool? isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isDone
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.toString().split('.').last, // Convertendo enum para string
      'isDone': isDone,
    };
  }

  static TodoModel fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: _parsePriority(map['priority']), // Convertendo string para enum
      isDone: map['isDone'],
    );
  }

  static TodoModelPriority _parsePriority(String priority) {
    return TodoModelPriority.values.firstWhere(
        (e) => e.toString().split('.').last == priority,
        orElse: () => TodoModelPriority.low);
  }
}