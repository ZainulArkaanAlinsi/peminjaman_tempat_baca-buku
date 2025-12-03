import 'package:get/get.dart';
import '../models/user.dart';
import '../controllers/auth_controller.dart';

class UserController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Get current user
  User? get currentUser => authController.currentUser.value;

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    final user = currentUser;
    if (user != null) {
      final updatedUser = user.copyWith(
        name: name ?? user.name,
        email: email ?? user.email,
        photoUrl: photoUrl ?? user.photoUrl,
      );
      authController.updateUserProfile(updatedUser);
    }
  }

  // Add book to favorites
  void addToFavorites(String bookId) {
    authController.addToFavorites(bookId);
  }

  // Remove book from favorites
  void removeFromFavorites(String bookId) {
    authController.removeFromFavorites(bookId);
  }

  // Check if book is in favorites
  bool isBookFavorite(String bookId) {
    return authController.isBookFavorite(bookId);
  }

  // Add book to reading history
  void addToReadingHistory(String bookId) {
    authController.addToReadingHistory(bookId);
  }

  // Get user stats
  Map<String, int> getUserStats() {
    final user = currentUser;
    if (user == null) {
      return {'favorites': 0, 'readingHistory': 0};
    }

    return {
      'favorites': user.favorites.length,
      'readingHistory': user.readingHistory.length,
    };
  }

  // Clear reading history
  void clearReadingHistory() {
    final user = currentUser;
    if (user != null) {
      final updatedUser = user.copyWith(readingHistory: []);
      authController.updateUserProfile(updatedUser);
    }
  }

  // Clear favorites
  void clearFavorites() {
    final user = currentUser;
    if (user != null) {
      final updatedUser = user.copyWith(favorites: []);
      authController.updateUserProfile(updatedUser);
    }
  }
}
