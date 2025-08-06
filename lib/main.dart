import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reading_book_app/app/theme/dark_theme.dart';
import 'package:reading_book_app/presentations/routes/app_pages.dart';
import 'package:reading_book_app/presentations/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StoryBook',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      // initialBinding: BookBinding(),
      initialRoute: Routes.splashScreen,
      getPages: AppPages.pages,
      routingCallback: routingCallback,
    );
  }
}
