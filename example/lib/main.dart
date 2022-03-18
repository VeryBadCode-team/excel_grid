import 'package:excel_grid/excel_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: ExcelGrid(
                gridData: MapGridData(
                  rawData: <String, Map<String, dynamic>>{
                    '4': <String, dynamic>{
                      'B': 'Dominik',
                      'C': 'Pająk',
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
