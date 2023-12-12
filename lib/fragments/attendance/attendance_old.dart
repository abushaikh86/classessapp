// // ignore_for_file: public_member_api_docs, sort_constructors_first, sized_box_for_whitespace, use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors, avoid_print
// import 'package:flutter/material.dart';
// import 'package:pluspoint/global_helper.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:pluspoint/util/constants.dart' as constants;
// import 'package:geolocator/geolocator.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AttendancePage(),
//     );
//   }
// }

// class AttendancePage extends StatefulWidget {
//   @override
//   State<AttendancePage> createState() => _AttendancePageState();
// }

// class _AttendancePageState extends State<AttendancePage> {
//   GlobalHelper globalHelper = GlobalHelper();
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;

//   String scannedData = '';

//   List<Course> courses = [];
//   Course? selectedCourse;

//   TextEditingController courseController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with the first course as the default
//     if (courses.isNotEmpty) {
//       selectedCourse = courses.first;
//       courseController.text = selectedCourse!.name;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<AttendanceRecord> attendanceRecords = [];
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

//     final attendanceInfo = args['attendanceInfo'];
//     final courseInfo = args['course_info'];

//     if (courseInfo != null && courses.isEmpty) {
//       for (var row in courseInfo['courses']) {
//         courses.add(Course(
//           id: row['course_id'],
//           name: row['course_name'],
//         ));
//       }
//     }

//     for (var row in attendanceInfo['attendence_details']) {
//       //  print(row['course']['course_name']);
//       var teachVerStatus =
//           row['teacher_verify_flag'].toString() == '1' ? 'Done' : 'Pending';

//       attendanceRecords.add(AttendanceRecord(
//         date: row['date'],
//         course: row['course']['course_name'],
//         status: row['attendance_status'],
//         teacherVerification: teachVerStatus,
//       ));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: constants.mainColor,
//         title: Text('Attendance'),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 children: attendanceRecords.map((record) {
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 16.0),
//                     child: ListTile(
//                       title: Text('Date: ${record.date}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Course: ${record.course}'),
//                           Text('Status: ${record.status}'),
//                           Text(
//                               'Teacher Verification: ${record.teacherVerification}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ))
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // _scanQRCode();
//           _selectCourseAndScanQRCode();
//         },
//         tooltip: 'Scan',
//         child: const Icon(Icons.camera),
//       ),
//     );
//   }

//   void _selectCourseAndScanQRCode() {
//     // Show a modal dialog for course selection
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Select a Course:'),
//                   DropdownButtonFormField<Course>(
//                     value: selectedCourse,
//                     items: courses.map((course) {
//                       return DropdownMenuItem<Course>(
//                         value: course,
//                         child: Text(course.name),
//                       );
//                     }).toList(),
//                     onChanged: (course) {
//                       setState(() {
//                         selectedCourse = course;
//                         courseController.text = course!.name;
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (selectedCourse != null) {
//                         Navigator.of(context).pop();
//                         _scanQRCode(selectedCourse!.id);
//                       } else {
//                         constants.Notification('Please Select Course First');
//                       }
//                     },
//                     child: Text('Scan QR Code'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _scanQRCode(int courseId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Container(
//             width: 200,
//             height: 200,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: (controller) {
//                 this.controller = controller;
//                 controller.scannedDataStream.listen((scanData) {
//                   setState(() {
//                     scannedData = scanData.toString();

//                     Navigator.pop(context); // Close the QR code scanning dialog
//                     _sendDataAfterScanning(
//                         scannedData, courseId); // Send the data
//                   });
//                 });
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _sendDataAfterScanning(String data, int courseId) async {
//     // showDialog(
//     //   context: context,
//     //   builder: (BuildContext context) {
//     //     return Center(
//     //       child: CircularProgressIndicator(),
//     //     );
//     //   },
//     // );

//     // await Future.delayed(Duration(seconds: 3));
//     // Navigator.pop(context);

//     // Get the user's current location as a Map
//     final userLocation = await _getUserLocation();

//     final fixedLocation = {
//       "latitude": constants.Latitude,
//       "longitude": constants.Longitude,
//     };

//     // Calculate the distance between the user's location and the fixed location
//     final distance = Geolocator.distanceBetween(
//       userLocation["latitude"]!,
//       userLocation["longitude"]!,
//       fixedLocation["latitude"]!,
//       fixedLocation["longitude"]!,
//     );

//     if (distance <= 100) {
//       Map<String, dynamic>? markAttendance =
//           await globalHelper.markAttendance(courseId);

//       if (markAttendance['msg'] == 'Present') {
//         constants.Notification('Thanks, Attendance Marked For Today');
//       } else if (markAttendance['msg'] == 'Already Present') {
//         constants.Notification('Oops, Attendance Already Marked For Today');
//       } else {
//         constants.Notification('Failed, Some Issue Has Occured');
//       }
//     } else {
//       // User is not within 100 meters of the fixed location
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text(
//                 "You are not within 100 meters of the QR code scanner"),
//           );
//         },
//       );
//     }
//     // Navigator.of(context).pop();
//   }

//   Future<Map<String, double>> _getUserLocation() async {
//     try {
//       var status = await Geolocator.checkPermission();
//       if (status == LocationPermission.denied) {
//         status = await Geolocator.requestPermission();
//         if (status != LocationPermission.whileInUse &&
//             status != LocationPermission.always) {
//           // Handle denied or restricted permission
//           print(
//               "User denied or restricted permissions to access the device's location.");
//           return {
//             "latitude": 0.0,
//             "longitude": 0.0,
//           };
//         }
//       }

//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
//       return {
//         "latitude": position.latitude,
//         "longitude": position.longitude,
//       };
//     } catch (e) {
//       print("Error getting user location: $e");
//       return {
//         "latitude": 0.0,
//         "longitude": 0.0,
//       };
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// class Course {
//   final int id;
//   final String name;

//   Course({required this.id, required this.name});
// }

// class AttendanceRecord {
//   final String date;
//   final String course;
//   final String status;
//   final String teacherVerification;
//   AttendanceRecord({
//     required this.date,
//     required this.course,
//     required this.status,
//     required this.teacherVerification,
//   });
// }
