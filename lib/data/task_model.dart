class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Konversi data Map dari SQLite ke Object TaskModel (Read)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Konversi Object TaskModel ke Map untuk disimpan di database SQLite (Create & Update)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }
}

