import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pluspoint/util/constants.dart' as constants;


class ViewNote extends StatelessWidget {
  final String htmlData; // HTML content fetched from the API

  ViewNote(this.htmlData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.mainColor,
        foregroundColor: Colors.white,
        title: Text('Note'),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }
}
