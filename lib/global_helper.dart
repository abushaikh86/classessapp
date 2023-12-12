// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:convert';

import 'package:pluspoint/util/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GlobalHelper {
  var api = constants.apiBaseURL;

  Future<dynamic> login(String mobile, String password) async {
    var response = await http.post(
      Uri.parse('${api}/login'),
      body: {
        'login_name': mobile,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // print(responseData);
      return responseData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getStudentDetails() async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/studentdetails'),
      body: {
        'student_id': student_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCourse() async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/courses'),
      body: {
        'student_id': student_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getTopics(course_id) async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/topics'),
      body: {
        'student_id': student_id.toString(),
        'course_id': course_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getNotes(course_id) async {
    final response = await http.post(
      Uri.parse('${api}/notes'),
      body: {
        'course_id': course_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getNote(note_id) async {
    final response = await http.post(
      Uri.parse('${api}/notes_view'),
      body: {
        'id': note_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<int> resetPassword(String number) async {
    final response = await http.post(
      Uri.parse('${api}/resetpasswordfrontend'),
      body: {
        'email': number.toString(),
      },
    );

    if (response.statusCode == 200) {
      if (response.body == '') {
        return 0;
      } else {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      }
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getFees() async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/fees'),
      body: {
        'student_id': student_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getFeeReceipt(id) async {
    final response = await http.post(
      Uri.parse('${api}/receipt_view'),
      body: {
        'id': id,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getAttendance() async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/attendance'),
      body: {
        'student_id': student_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getResults() async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/results'),
      body: {
        'student_id': student_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // print(jsonData.length);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> changePassword(newpass, repeatnewpass) async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/changepassword'),
      body: {
        'student_id': student_id.toString(),
        'newpass': newpass.toString(),
        'repeatnewpass': repeatnewpass.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // print(jsonData.length);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> markAttendance(course_id) async {
    var sharedPref = await SharedPreferences.getInstance();
    var student_id = sharedPref.getInt('student_id');

    final response = await http.post(
      Uri.parse('${api}/attendance_mark'),
      body: {
        'student_id': student_id.toString(),
        'course_id': course_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // print(jsonData.length);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCoordinates() async {
    final response = await http.post(
      Uri.parse('${api}/getcoordinates'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // print(jsonData.length);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }
}
