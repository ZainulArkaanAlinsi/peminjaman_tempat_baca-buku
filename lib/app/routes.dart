import 'package:get/get.dart';
import '../pages/splash_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/home_page.dart';
import '../pages/book_detail_page.dart';
import '../pages/reader_page.dart';
import '../pages/profile_page.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const bookDetail = '/book-detail';
  static const reader = '/reader';
  static const profile = '/profile';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.bookDetail,
      page: () {
        // Get book dari arguments
        final book = Get.arguments;
        return BookDetailPage(book: book);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.reader,
      page: () {
        // Get book dari arguments
        final book = Get.arguments;
        return ReaderPage(book: book);
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
