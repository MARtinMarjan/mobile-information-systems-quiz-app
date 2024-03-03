class Lesson {
  final List<String> lessonData;
  final String lessonTitle;
  get lessonDataLength => lessonData.length;

  final int lessonNumber;

  Lesson(this.lessonData, this.lessonTitle, this.lessonNumber);

  factory Lesson.toMap(Map<String, dynamic> data) {
    return Lesson(
      (data['lessonData'] as List<dynamic>? ?? []).map((lessonData) {
        return lessonData as String;
      }).toList(),
      data['lessonTitle'] as String? ?? '',
      data['lessonNumber'] as int? ?? 0,
    );
  }
}
