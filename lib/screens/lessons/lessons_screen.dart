import 'package:flutter/material.dart';
import 'package:quiz_app/screens/lessons/lesson_viewer.dart';
import 'package:quiz_app/services/lesson_service.dart';

import '../../models/lesson.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final LessonService _lessonService = LessonService();

  late List<Lesson> _lessons;

  @override
  initState() {
    super.initState();
    _lessonService.getAllLessons().then((lessons) {
      setState(() {
        _lessons = lessons;
        _lessons.sort((a, b) => a.lessonNumber.compareTo(b.lessonNumber));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Lessons",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: _lessonService.isLoaded == false ||
              _lessons == null ||
              _lessons.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildLessonsList(),
    );
  }

  Widget _buildLessonsList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._lessons.map((lesson) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text('Lesson ${lesson.lessonNumber + 1}',
                          style: Theme.of(context).textTheme.headlineMedium),
                      subtitle: Text(lesson.lessonTitle,
                          style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LessonViewer(lesson: lesson)),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
