import 'dart:ui';

import 'package:apk_keuangan/models/database.dart';
import 'package:apk_keuangan/models/transaction_with_category.dart';
import 'package:apk_keuangan/pages/transaction_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<TransactionWithCategory>>(
                stream: database.transactionsWithCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
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
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.download,
                                      color: Colors.green,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Rp $totalIncome',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.upload,
                                      color: Colors.red,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Rp $totalExpense',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            // Teks Transaksi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Transaksi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(
                                            snapshot.data![index].transaction.id,
                                          );
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => TransactionPage(
                                                transactionWithCategory: snapshot.data![index],
                                              ),
                                            ),
                                          ).then((value) {});
                                        },
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${snapshot.data![index].category.name} (${snapshot.data![index].transaction.name})',
                                  ),
                                  leading: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: (snapshot.data![index].category.type == 1)
                                        ? Icon(
                                      Icons.download,
                                      color: Colors.greenAccent[400],
                                    )
                                        : Icon(
                                      Icons.upload,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  title: Text(
                                    'Rp ${snapshot.data![index].transaction.amount}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text('Data transaksi masih kosong'),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Tidak ada data'),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
