// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, must_be_immutable, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pluspoint/fragments/results/results.dart';
import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/fragments/attendance/attendance.dart';
import 'package:pluspoint/fragments/change_password.dart';
import 'package:pluspoint/fragments/courses/courses.dart';
import 'package:pluspoint/fragments/fees/fees.dart';
import 'package:pluspoint/fragments/online_exam.dart';
import 'package:pluspoint/fragments/profile.dart';
import 'package:pluspoint/login.dart';
import 'package:pluspoint/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluspoint/util/constants.dart' as constants;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Timer? dataFetchTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalHelper globalHelper = GlobalHelper();
  Map<String, dynamic>? user_info;
  Map<String, dynamic>? course_info;
  Map<String, dynamic>? attendanceInfo;
  Map<String, dynamic>? feesInfo;
  Map<String, dynamic>? resultsInfo;
  Map<String, dynamic>? coordinates;

  @override
  void initState() {
    super.initState();
    // Use a Future-based async operation to fetch user_info
    initializeData();
    dataFetchTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      initializeData(); // Fetch data every 5 minutes (or your desired interval)
    });
  }

  void initializeData() {
    _loadUserInfo();
    _courseDetails();
    _attendaceDetails();
    _feesDetails();
    _resultDeatils();
    _getCoordinates();
  }

  void _toggleDrawer() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      user_info = await globalHelper.getStudentDetails();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _courseDetails() async {
    try {
      course_info = await globalHelper.getCourse();
      setState(() {
        course_info;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _attendaceDetails() async {
    try {
      attendanceInfo = await globalHelper.getAttendance();
      setState(() {
        attendanceInfo;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _feesDetails() async {
    try {
      feesInfo = await globalHelper.getFees();
      setState(() {
        feesInfo;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getCoordinates() async {
    try {
      coordinates = await globalHelper.getCoordinates();
      setState(() {
        coordinates;
        constants.Latitude = double.parse(coordinates!['success']['latitude']);
        constants.Longitude =
            double.parse(coordinates!['success']['longitude']);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _resultDeatils() async {
    try {
      resultsInfo = await globalHelper.getResults();
      setState(() {
        resultsInfo;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Plus Point Computer'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
      ),
      drawer: MyDrawer(
        user_info: user_info,
        course_info: course_info,
        attendanceInfo: attendanceInfo,
        feesInfo: feesInfo,
        resultsInfo: resultsInfo,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildCard(
                  // icon: Icons.menu_book,
                  title: 'Courses',
                  percentage: (course_info != null &&
                          (course_info!['percentage_all'] is int ||
                              course_info!['percentage_all'] is double))
                      ? (course_info!['percentage_all'] as num).toInt()
                      : 0,

                  onTap: () {
                    // Add your navigation logic here when the card is tapped.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseListPage(),
                        settings: RouteSettings(
                          arguments:
                              course_info, // Pass the data as an argument
                        ),
                      ),
                    );
                  },
                ),
                _buildCard(
                  // icon: Icons.perm_contact_calendar_sharp,
                  title: 'Attendance',
                  percentage: 95, // Replace with the actual percentage
                  onTap: () {
                    // Add your navigation logic here when the card is tapped.
                    // print(attendanceInfo);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendancePage(),
                        settings: RouteSettings(
                          arguments: {
                            'course_info': course_info,
                            'attendanceInfo': attendanceInfo,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius
                  .zero, // Set the borderRadius to zero for no rounded corners
            ),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: constants.mainColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: ListTile(
                    title: Text(
                      'Fees Information',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                      'Total Fees: ${feesInfo != null ? feesInfo!['course_fees'] : 0}'),
                ),
                ListTile(
                  title: Text(
                      'Fees Paid: ${feesInfo != null ? feesInfo!['total_paid_fees'] : 0}'),
                ),
                ListTile(
                  leading: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeesPage(),
                            settings: RouteSettings(
                              arguments:
                                  feesInfo, // Pass the data as an argument
                            ),
                          ),
                        );
                      },
                      child: Text('View')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    dataFetchTimer?.cancel();
    super.dispose();
  }
}

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic>? user_info; // Define user_info as a parameter
  final Map<String, dynamic>? course_info; // Define user_info as a parameter
  final Map<String, dynamic>? attendanceInfo; // Define user_info as a parameter
  final Map<String, dynamic>? feesInfo; // Define user_info as a parameter
  final Map<String, dynamic>? resultsInfo; // Define user_info as a parameter
  GlobalHelper globalHelper = GlobalHelper();

  MyDrawer(
      {this.user_info,
      this.course_info,
      this.attendanceInfo,
      this.feesInfo,
      this.resultsInfo});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfile(),
                  settings: RouteSettings(
                    arguments: user_info, // Pass the data as an argument
                  ),
                ),
              );
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('assets/drawer_bg.jpg'),
                //   opacity: 0.4,
                //   fit: BoxFit.cover,
                // ),
                gradient: LinearGradient(
                  colors: [
                    constants.mainColor, // Your main color
                    Color.fromARGB(255, 249, 182, 252), // White color
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              accountName: Text(
                user_info?['name'] + ' ' + user_info?['surname'] ?? '',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
              ),
              accountEmail: Text(
                user_info!['email'] != ''
                    ? user_info!['email']
                    : 'Email Not Updated Yet',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Set the border color
                    width: 1.5, // Set the border width
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.network(
                      '${constants.project_url}/backend/web/uploads/profilepic/${user_info?['profile_pic']}',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // print('Error loading image: $error');
                        // Return the default image in case of an error
                        return Image.asset(
                          'assets/pro.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfile(),
                  settings: RouteSettings(
                    arguments: user_info, // Pass the data as an argument
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Enrolled Courses'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseListPage(),
                  settings: RouteSettings(
                    arguments: course_info, // Pass the data as an argument
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Fees'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeesPage(),
                  settings: RouteSettings(
                    arguments: feesInfo, // Pass the data as an argument
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Attendance'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendancePage(),
                  settings: RouteSettings(
                    arguments: {
                      'course_info': course_info,
                      'attendanceInfo': attendanceInfo,
                    }, // Pass the data as an argument
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Online Exam'),
            onTap: () async {
              SharedPreferences sharedPref =
                  await SharedPreferences.getInstance();
              var student_id = sharedPref.getInt('student_id');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlineExam(studentIdData: student_id),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('Results'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultPage(),
                    settings: RouteSettings(arguments: resultsInfo)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              // Add your logout logic here
              var sharedPrefs = await SharedPreferences.getInstance();
              sharedPrefs.setBool(SplashScreenState.KEY_LOGIN, false);
              // constants.Notification("Logged Out Successfully");
              await Future.delayed(Duration(seconds: 2));
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({
  IconData? icon,
  String? title,
  int? percentage,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    value: percentage! / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(constants.mainColor),
                  ),
                ),
                Text('$percentage%'),
              ],
            ),
            SizedBox(height: 15),
            Text(
              '$title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
