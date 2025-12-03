import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      isLoading.value = true;
      final user = await _authService.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      print('Error checking auth status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.login(email, password);
      currentUser.value = user;

      Get.offAllNamed('/home');
      Get.snackbar(
        'Berhasil',
        'Selamat datang kembali!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.register(name, email, password);
      currentUser.value = user;

      Get.offAllNamed('/home');
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      currentUser.value = null;
      Get.offAllNamed('/login');
      Get.snackbar(
        'Berhasil',
        'Anda telah logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateUserProfile(User updatedUser) {
    currentUser.value = updatedUser;
    _authService.updateUser(updatedUser);
  }

  void addToFavorites(String bookId) {
    final user = currentUser.value;
    if (user != null && !user.favorites.contains(bookId)) {
      final updatedUser = user.copyWith(favorites: [...user.favorites, bookId]);
      currentUser.value = updatedUser;
      _authService.updateUser(updatedUser);
    }
  }

  void removeFromFavorites(String bookId) {
    final user = currentUser.value;
    if (user != null) {
      final updatedUser = user.copyWith(
        favorites: user.favorites.where((id) => id != bookId).toList(),
      );
      currentUser.value = updatedUser;
      _authService.updateUser(updatedUser);
    }
  }

  void addToReadingHistory(String bookId) {
    final user = currentUser.value;
    if (user != null && !user.readingHistory.contains(bookId)) {
      final updatedUser = user.copyWith(
        readingHistory: [...user.readingHistory, bookId],
      );
      currentUser.value = updatedUser;
      _authService.updateUser(updatedUser);
    }
  }

  bool isBookFavorite(String bookId) {
    return currentUser.value?.favorites.contains(bookId) ?? false;
  }
}
