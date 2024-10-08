import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository/image_repository_provider.dart';
import 'screens/home_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageRepositoryProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Images',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
