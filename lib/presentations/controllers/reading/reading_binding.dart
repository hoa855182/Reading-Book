import 'package:get/get.dart';
import '../book/book_controller.dart';
import 'reading_controller.dart';

class ReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingController>(
      () => ReadingController(
        bookController: Get.find<BookController>(),
      ),
    );
  }
}
