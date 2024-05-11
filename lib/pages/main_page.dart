import 'package:apk_keuangan/pages/account_page.dart';
import 'package:apk_keuangan/pages/category_page.dart';
import 'package:apk_keuangan/pages/graph_page.dart';
import 'package:apk_keuangan/pages/home_page.dart';
import 'package:apk_keuangan/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      currentIndex = index;
      _children = [
        HomePage(selectedDate: selectedDate),
        CategoryPage(),
        GraphPage(),
        AccountPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              backButton: false,
              accent: Colors.green,
              locale: 'id',
              onDateChanged: (value) {
                setState(() {
                  print('Selected date ' + value.toString());
                  selectedDate = value;
                  updateView(0, selectedDate);
                });
              },
              firstDate: DateTime.now().subtract(Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              )),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => TransactionPage(transactionWithCategory: null),
            ))
                .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  updateView(0, DateTime.now());
                },
                icon: Icon(Icons.home)),
            SizedBox(
              width: 30,
            ),
            IconButton(
              onPressed: () {
                updateView(2, DateTime.now());
              },
              icon: Icon(Icons.bar_chart),
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () {
                  updateView(1, null);
                },
                icon: Icon(Icons.list)),
            SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () {
                  updateView(3, null);
                },
                icon: Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}
