// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluspoint/fragments/results/certificate.dart';
import 'package:pluspoint/util/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResultPage(),
    );
  }
}

class ResultPage extends StatelessWidget {
  // final List<ResultData> resultData = [];

  @override
  Widget build(BuildContext context) {
    final resultsInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Result Data'),
      ),
      body: resultsInfo['exams_details'].isEmpty
          ? Center(
              child: Text('No data available'),
            )
          : ListView.builder(
              itemCount: resultsInfo['exams_details'].length,
              itemBuilder: (context, index) {
                final data = resultsInfo['exams_details'][index];
                DateTime dateF = DateTime.parse(data['exam_date']);
                String formattedDate = DateFormat("dd-MM-yyyy").format(dateF);
                final percentage = double.tryParse(data['percentage']);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Exam Date: $formattedDate'),
                        subtitle:
                            Text('Course: ${data['course']['course_name']}'),
                      ),
                      ListTile(
                        title: Text(
                            'Percentage: ${percentage?.toStringAsFixed(2)}'),
                        subtitle: Text('Final Status: ${data['level']}'),
                      ),
                      ListTile(
                        title: Text('Grade: ${data['grade_code']}'),
                        trailing: Visibility(
                          visible: data['grade_code'] != 'F',
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences sharedPref =
                                  await SharedPreferences.getInstance();
                              var student_id = sharedPref.getInt('student_id');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CertificateResult(
                                          studentIdData: student_id,
                                          courseIdData:
                                              data['course_id'].toString())));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: constants.mainColor,
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ResultData {
  final String examDate;
  final String course;
  final String percentage;
  final String finalStatus;
  final String grade;

  ResultData(this.examDate, this.course, this.percentage, this.finalStatus,
      this.grade);
}
