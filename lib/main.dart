import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes.dart';
import 'app/theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/book_controller.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await Get.putAsync(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

  // Initialize services
  Get.put(ApiService());
  Get.put(AuthController());
  Get.put(BookController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Buku Siap Pinjam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: Routes.splash, // Mulai dari splash
      getPages: AppPages.routes,
    );
  }
}
