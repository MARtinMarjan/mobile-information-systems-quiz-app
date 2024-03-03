import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:quiz_app/models/lesson.dart';

class LessonViewer extends StatefulWidget {
  const LessonViewer({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonViewer> createState() => _LessonViewerState();
}

class _LessonViewerState extends State<LessonViewer> {
  int _index = 0;

  final ScrollController controller = ScrollController();

  String _firebaseStringToMarkdownString(String data) {
    return data.replaceAll(r'\n', '\n');
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.lesson.lessonData[_index]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Lesson ${widget.lesson.lessonNumber + 1}"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          children: [
            Expanded(
                child: Markdown(
                    selectable: true,
                    controller: controller,
                    data: _firebaseStringToMarkdownString(
                        widget.lesson.lessonData[_index]))),
            // data: data)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                (_index > 0)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _index--;
                          });
                        },
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                      ),
                (_index < widget.lesson.lessonDataLength - 1)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _index++;
                          });
                        },
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
