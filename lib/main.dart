import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  ).then((fn) => runApp(
        MaterialApp(
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const Expenses(),
        ),
      ));
}
