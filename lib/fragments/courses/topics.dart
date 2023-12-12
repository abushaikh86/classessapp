// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pluspoint/util/constants.dart' as constants;

// Define the Chapter and Topic classes as you have before

// Define a function to create dynamic data
List<Chapter> createDynamicChapters(List<dynamic> chapterData) {
  List<Chapter> chapters = [];

  // print(chapterData);
  for (var chapterInfo in chapterData) {
    String chapterName = chapterInfo['name'];
    bool isChapterCompleted = chapterInfo['status'] == 'complete';

    List<Topic> topics = [];

    for (var topicInfo in chapterInfo['topics']) {
      String topicName = topicInfo['name'];
      bool isTopicCompleted = topicInfo['status'] == 'complete';

      topics.add(Topic(
          name: topicName,
          isCompleted: isTopicCompleted,
          date: '25 Aug, 2022'));
    }

    chapters.add(Chapter(
      name: chapterName,
      isCompleted: isChapterCompleted,
      topics: topics,
    ));
  }

  return chapters;
}

class TopicsPage extends StatefulWidget {
  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  int? expandedIndex; // Keep track of the currently expanded card index

  @override
  Widget build(BuildContext context) {
    // Replace this with your dynamic data
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final List<Chapter> chapters =
        createDynamicChapters(args['topic_info']['chapters']);

    // print(args['topic_info']['chapters']);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Course Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Details Section
            Text(
              args['topic_info']['courses']['${args['course_id']}'],
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text('2020 Offline'),
            SizedBox(height: 16.0),

            // Linear progress bar with background color
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    value: args['courseProgress'],
                    minHeight: 15.0,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '${(args['courseProgress'] * 100).toInt()}%',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              // Add a horizontal line
              color: Colors.grey, // You can customize the color as needed
              thickness: 1, // You can adjust the thickness
            ),
            SizedBox(
              height: 20,
            ),

            // List of Chapters
            Text(
              'Chapters',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),

            for (int index = 0; index < chapters.length; index++)
              ChapterCard(
                chapter: chapters[index],
                isExpanded: expandedIndex == index,
                onTap: () {
                  setState(() {
                    expandedIndex = (expandedIndex == index) ? null : index;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final bool isExpanded;
  final VoidCallback onTap;

  ChapterCard({
    required this.chapter,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isChapterCompleted =
        chapter.topics.every((topic) => topic.isCompleted);

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              color:
                  constants.mainColor, // Background color for the card header
            ),
            padding: EdgeInsets.all(1.0), // Padding for the card header
            child: ListTile(
              title: Text(
                chapter.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                isChapterCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: isChapterCompleted ? Colors.green : Colors.grey,
              ),
              onTap: onTap,
            ),
          ),
          if (isExpanded)
            Column(
              children: chapter.topics.map((topic) {
                return ListTile(
                  title: Text(
                    topic.name,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Icon(
                    topic.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: topic.isCompleted ? Colors.green : Colors.grey,
                  ),
                  subtitle: Text('Date: ${topic.date}',
                      style: TextStyle(fontSize: 12)), // Display the date
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class Topic {
  final String name;
  final bool isCompleted;
  final String date;

  Topic({
    required this.name,
    required this.isCompleted,
    required this.date,
  });
}

class Chapter {
  final String name;
  final bool isCompleted;
  final List<Topic> topics;

  Chapter({
    required this.name,
    required this.isCompleted,
    required this.topics,
  });
}
