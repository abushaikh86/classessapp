// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluspoint/fragments/fees/view_receipt.dart';

import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeesPage(),
    );
  }
}

class FeesPage extends StatelessWidget {
  // final List<FeePayment> feePayments = <FeePayment>[];

  @override
  Widget build(BuildContext context) {
    GlobalHelper globalHelper = GlobalHelper();
    final feesInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    var totalFees = double.parse(feesInfo['course_fees']);
    var feesPaid = feesInfo['total_paid_fees']; // Assuming it's an integer
    var feesRemaining = totalFees - feesPaid;
    var paymentProgress = feesInfo['progress'];

    // for (var row in feesInfo['fee_paid']) {
    //   String date = row['created_at'];
    //   String amountPaid = row['amount_paid'];
    //   DateTime dateF = DateTime.parse(date);
    //   String formattedDate = DateFormat("dd-MM-yyyy").format(dateF);

    //   feePayments.add(FeePayment(
    //     feesId: row['fees_id'].toString(),
    //     date: formattedDate,
    //     modeOfPayment: mode,
    //     feePaid: double.parse(amountPaid),
    //   ));
    // }

    // print(feesInfo);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Fees Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Total Fees: ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$totalFees',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        Colors.blue, // Change the color to your desired color
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Fees Paid: ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$feesPaid',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        Colors.green, // Change the color to your desired color
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Fees Remaining: ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$feesRemaining',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red, // Change the color to your desired color
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: paymentProgress / 100.0,
              minHeight: 15.0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 8), // Added space
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(paymentProgress)}%',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 2,
              thickness: 2,
            ),
            SizedBox(height: 16),
            Text(
              'Paid Fees Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: feesInfo['fee_paid'].length,
                itemBuilder: (context, index) {
                  final paymentData = feesInfo['fee_paid'][index];
                  final date = paymentData['created_at'];
                  DateTime dateF = DateTime.parse(date);
                  String formattedDate = DateFormat("dd-MM-yyyy").format(dateF);

                  final amountPaid = paymentData['amount_paid'];
                  final feesId = paymentData['fees_id'].toString();
                  var mode = '';
                  if (paymentData['cash'] == '1') {
                    mode = 'Cash';
                  } else if (paymentData['card'] == '1') {
                    mode = 'Card';
                  } else if (paymentData['cheque'] == '1') {
                    mode = 'Cheque';
                  } else if (paymentData['neft'] == '1') {
                    mode = 'NEFT';
                  } else if (paymentData['dd'] == '1') {
                    mode = 'DD';
                  } else {
                    mode = '';
                  }

                  return Card(
                    margin: EdgeInsets.all(6),
                    child: ListTile(
                      title: Text('Date: $formattedDate'),
                      subtitle: Text(
                        'Mode of Payment: $mode\nFee Paid: $amountPaid',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic>? receiptInfo =
                              await globalHelper.getFeeReceipt(feesId);

                          // print(receiptInfo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewReceipt(),
                                settings: RouteSettings(
                                  arguments: receiptInfo,
                                )),
                          );
                        },
                        child: Text('Receipt'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
