class Option {
  String value;
  String detail;
  bool correct;

  Option({required this.correct, required this.value, required this.detail});

  // Option.fromMap(Map data) {
  //   value = data['value'];
  //   detail = data['detail'] ?? '';
  //   correct = data['correct'];
  // }
}
