// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_cast, non_constant_identifier_names, use_build_context_synchronously
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:pluspoint/fragments/courses/notes_view.dart';

import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;

void main() {
  runApp(MaterialApp(
    home: NotesListPage(),
  ));
}

class NotesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalHelper globalHelper = GlobalHelper();

    final List<dynamic> notesDataList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.mainColor,
        foregroundColor: Colors.white,
        title: Text('Notes'),
      ),
      body: notesDataList.isNotEmpty
          ? ListView.builder(
              itemCount: notesDataList.length,
              itemBuilder: (context, index) {
                final note = notesDataList[index];
                final noteName = note['note_name'];
                final noteID = note['id'];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(noteName),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        // Show the loader
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a 2-second delay
                        await Future.delayed(Duration(seconds: 3));

                        // Retrieve the note data
                        Map<String, dynamic>? noteData =
                            await globalHelper.getNote(noteID);

                        if (noteData != null) {
                          // Remove the loader
                          Navigator.pop(context);
                        }

                        // Navigate to the ViewNote page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewNote(noteData['notes'].toString()),
                          ),
                        );
                      },
                      child: Text('View'),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No data available'),
            ),
    );
  }
}
