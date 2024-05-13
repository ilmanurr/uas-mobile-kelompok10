import 'package:apk_keuangan/pages/detail_expense_graph_page.dart';
import 'package:apk_keuangan/pages/detail_income_graph_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apk_keuangan/models/database.dart';
import 'package:apk_keuangan/models/transaction_with_category.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final AppDb database = AppDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Graph',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
            // Calculate total income and expense
            int totalIncome = 0;
            int totalExpense = 0;
            if (snapshot.hasData) {
              for (var transaction in snapshot.data!) {
                if (transaction.category.type == 1) {
                  totalIncome += transaction.transaction.amount;
                } else {
                  totalExpense += transaction.transaction.amount;
                }
              }
            }
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Total Income: Rp $totalIncome',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Expense: Rp $totalExpense',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20), // Added for spacing

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailIncomeGraphPage(),
                            ),
                          );
                        },
                        child: Text('Detail Pemasukan'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailExpenseGraphPage(),
                            ),
                          );
                        },
                        child: Text('Detail Pengeluaran'),
                      ),
                    ],
                  ),

                  SizedBox(height: 20), // Added for spacing

                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: totalIncome.toDouble(),
                                  color: Colors.green,
                                  title: 'Income',
                                  radius: 80,
                                ),
                                PieChartSectionData(
                                  value: totalExpense.toDouble(),
                                  color: Colors.red,
                                  title: 'Expense',
                                  radius: 100,
                                ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                      ],
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
