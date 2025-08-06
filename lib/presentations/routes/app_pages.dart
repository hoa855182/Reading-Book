

import 'package:get/get.dart';
import 'package:reading_book_app/presentations/controllers/book/book_binding.dart';
import 'package:reading_book_app/presentations/controllers/reading/reading_binding.dart';
import 'package:reading_book_app/presentations/pages/book/book_list_page.dart';
import 'package:reading_book_app/presentations/pages/reading/reading_page.dart';
import 'package:reading_book_app/presentations/pages/splash_screen.dart';
import 'package:reading_book_app/presentations/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.bookList,
      page: () => const BookListPage(),
      binding: BookBinding(),
    ),
    GetPage(
      name: Routes.reading,
      page: () => const ReadingPage(),
      binding: ReadingBinding(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
    ),
  ];
}

void routingCallback(Routing? routing) {
  if (routing?.current == null) {
    return;
  }
  RxRoute().currentRoute.value = routing?.current ?? '';
}

class RxRoute {
  RxString currentRoute = ''.obs;

  // Tạo singleton
  static final RxRoute _instance = RxRoute._internal();

  factory RxRoute() {
    return _instance;
  }

  RxRoute._internal();
}
