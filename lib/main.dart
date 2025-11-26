import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/mtg_viewmodel.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MtgViewModel())],
      child: MaterialApp(
        title: 'MTG App',
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}