// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, prefer_const_constructors, prefer_const_declarations, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pluspoint/fragments/courses/notes.dart';
import 'package:pluspoint/fragments/courses/topics.dart';
import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CourseListPage(),
    );
  }
}

class CourseListPage extends StatelessWidget {
  // final List<Course> courses = [
  //   Course('Course 1', 0.6),
  //   Course('Course 2', 0.3),
  //   // Add more courses here
  // ];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> courseInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // print(courseInfo['percentage'][0]);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Courses List'),
      ),
      body: ListView.builder(
        itemCount: courseInfo['courses'].length,
        itemBuilder: (context, index) {
          GlobalHelper globalHelper = GlobalHelper();

          final courseData = courseInfo['courses'][index];
          final courseName = courseData['course_name'];
          final courseProgress = courseInfo['percentage'][index] / 100.0;

          var course_id = courseInfo['courses'][index]['course_id'];

          Color progressBarColor =
              courseProgress == 1.0 ? Colors.green : Colors.red;

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        courseName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(courseProgress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      value: courseProgress,
                      backgroundColor: Colors.grey,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(progressBarColor),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? topic_info =
                              await globalHelper.getTopics(course_id);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicsPage(),
                              settings: RouteSettings(
                                arguments: {
                                  'course_id': course_id,
                                  'topic_info': topic_info,
                                  'courseProgress': courseProgress,
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('View'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? notes_info =
                              await globalHelper.getNotes(course_id);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotesListPage(),
                              settings: RouteSettings(
                                arguments: notes_info['notes'],
                              ),
                            ),
                          );
                        },
                        child: Text('Notes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
