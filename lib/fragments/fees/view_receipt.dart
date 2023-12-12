// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;
// import 'package:pdf/pdf.dart';
// import 'package:intl/intl.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class ViewReceipt extends StatefulWidget {
  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // GlobalHelper globalHelper = GlobalHelper();
    final receiptInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<String> coursesList = [];
    for (var row in receiptInfo['selected_courses']) {
      coursesList.add(row['coursename']['course_name']);
    }

    final pdf = pw.Document();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: constants.mainColor,
        foregroundColor: Colors.white,
        title: Text('Fee Receipt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Screenshot(
              controller: screenshotController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          heightFactor: 0.5,
                          child: Image.asset(
                            'assets/logo_text.png',
                            height: 50,
                            width: 180,
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                          'Sr.No: ', '${receiptInfo['fee_data']['fees_id']}'),
                      _buildHeaderText('Enroll No: ',
                          '${receiptInfo['fee_data']['admission_id']}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Date: ',
                        _formatDate(receiptInfo['fee_data']['created_at']),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Student Name: ',
                        ('${receiptInfo['fee_data']['admission']['name']} ${receiptInfo['fee_data']['admission']['surname']}'),
                      ),
                    ],
                  ),
                  Divider(),
                  _buildHeader('Course Selected Details:'),
                  _buildCourseList(coursesList),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Fees Paid: ',
                        ('${receiptInfo['fee_data']['amount_paid']}'),
                      ),
                      _buildHeaderText(
                        'Balance Due: ',
                        ('${receiptInfo['fee_data']['balance_due']}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'In Words: ',
                        ('${receiptInfo['amount_in_words']}'),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'If Cheque, Bank Name: ',
                        ('${receiptInfo['fee_data']['bank_name']}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Cheque No: ',
                        ('${receiptInfo['fee_data']['cheque_no']}'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Branch: ',
                        (' ${receiptInfo['fee_data']['branch_name']}'),
                      ),
                      _buildHeaderText(
                        'Dated: ',
                        (' ${_formatDate(receiptInfo['fee_data']['dated'])}'),
                      ),
                    ],
                  ),
                  Divider(),
                  _buildText('Head office: Plus Point Computer'),
                  _buildText('Shop no: 12/13, B" wing,'),
                  _buildText(
                      'Sudhanshu Chambers, Behind Santosh hotel, Opp Railway station, Kalyan(w)'),
                  _buildText('Help No: 9768871110 / 7350816698'),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Stamp: ',
                        (''),
                      ),
                      _buildHeaderText(
                        'Cashier: ',
                        ('________'),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderText(
                        'Next Installment Date: ',
                        (_formatDate(
                            receiptInfo['fee_data']['next_installment_date'])),
                      ),
                    ],
                  ),
                  _buildText(
                      'Note: Course Fees once paid whether in part or full will not be refunded.'),
                  Divider(),
                  _buildText('Visit Us At: www.pluspointonline.com'),
                  _buildText('Youtube: www.youtube.com/niketshahpluspoint'),
                  _buildText('www.facebook.com/pluspointkalyan'),
               
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildButtonRow(context, pdf),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      // Split the date string into date and time parts
      final dateParts = date.split(" ");

      // Ensure the date has both date and time parts
      if (dateParts.length == 2) {
        final datePart = dateParts[0];

        // Split the date part into year, month, and day
        final dateComponents = datePart.split("-");

        if (dateComponents.length == 3) {
          final year = dateComponents[0];
          final month = dateComponents[1];
          final day = dateComponents[2];

          // Create the formatted date
          final formattedDate = '$day-$month-$year';
          return formattedDate;
        }
      }
    } catch (e) {
      print("Error parsing date: $e");
    }

    return "";
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  Widget _buildHeaderText(String header, String Text) {
    return Row(
      children: [
        _buildHeader(header),
        _buildText(Text),
      ],
    );
  }

  Widget _buildText(String text) {
    return Text(text);
  }

  Widget _buildCourseList(List<String> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: courses.map((course) => Text('- $course')).toList(),
    );
  }

  Widget _buildButtonRow(BuildContext context, pw.Document pdf) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            // Printing.layoutPdf(onLayout: (format) {
            //   return pdf.save();
            // });

            // final pdfFile = await pdf.save();
            // await Printing.sharePdf(bytes: pdfFile);

            await Future.delayed(Duration(milliseconds: 500));
            final imageFile = await screenshotController.capture();
            final pdf = pw.Document();

            pdf.addPage(
              pw.Page(
                build: (pw.Context context) {
                  return pw.Image(pw.MemoryImage(imageFile!));
                },
              ),
            );

            final pdfFile = await pdf.save();

            await Printing.sharePdf(bytes: pdfFile);
          },
          child: Text('Print'),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
        ),
      ],
    );
  }
}
