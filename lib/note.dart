class Note {
  final int? id;
  final String title;
  final String content;
  final String color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as String,
    );
  }
}
