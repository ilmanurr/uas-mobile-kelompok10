import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apk_keuangan/models/database.dart';
import 'package:apk_keuangan/models/transaction_with_category.dart';

class DetailExpenseGraphPage extends StatefulWidget {
  const DetailExpenseGraphPage({Key? key}) : super(key: key);

  @override
  State<DetailExpenseGraphPage> createState() => _DetailExpenseGraphPageState();
}

class _DetailExpenseGraphPageState extends State<DetailExpenseGraphPage> {
  final AppDb database = AppDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Detail Expense Graph',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<TransactionWithCategory>>(
        stream: database.transactionsWithCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Filter transactions for expense
            final expenseTransactions = snapshot.data!
                .where((transaction) => transaction.category.type == 2)
                .toList();

            // Prepare data for pie chart
            final List<PieChartSectionData> pieChartData =
                expenseTransactions.map((transaction) {
              // Generate random color
              final Random random = Random();
              final Color randomColor = Color.fromRGBO(
                random.nextInt(256), // red
                random.nextInt(256), // green
                random.nextInt(256), // blue
                1, // opacity
              );

              return PieChartSectionData(
                value: transaction.transaction.amount.toDouble(),
                title:
                    '${transaction.category.name}\n (${transaction.transaction.name})\n Rp ${transaction.transaction.amount}',
                color: randomColor,
                radius: 120,
                titleStyle: TextStyle(
                  color: Colors.white,
                ),
              );
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
