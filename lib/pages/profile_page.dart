import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/auth_controller.dart';
import '../controllers/book_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final BookController bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Obx(() {
        final user = authController.currentUser.value;

        if (user == null) {
          return const Center(child: Text('User tidak ditemukan'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                child: user.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.photoUrl!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Iconsax.user,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),

              const SizedBox(height: 20),

              // Name
              Text(user.name, style: Theme.of(context).textTheme.displaySmall),

              const SizedBox(height: 8),

              // Email
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),

              const SizedBox(height: 32),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Iconsax.book,
                      '${user.readingHistory.length}',
                      'Dibaca',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      Iconsax.heart,
                      '${user.favorites.length}',
                      'Favorit',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Menu Items
              _buildMenuItem(context, Iconsax.user_edit, 'Edit Profil', () {
                Get.snackbar('Info', 'Fitur edit profil segera hadir');
              }),

              _buildMenuItem(context, Iconsax.notification, 'Notifikasi', () {
                Get.snackbar('Info', 'Fitur notifikasi segera hadir');
              }),

              _buildMenuItem(context, Iconsax.lock, 'Privasi & Keamanan', () {
                Get.snackbar('Info', 'Fitur privasi segera hadir');
              }),

              _buildMenuItem(
                context,
                Iconsax.info_circle,
                'Tentang Aplikasi',
                () {
                  _showAboutDialog(context);
                },
              ),

              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Keluar'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              authController.logout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Keluar'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.logout),
                  label: const Text('Keluar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Iconsax.arrow_right_3, size: 20),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buku Siap Pinjam',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Versi 1.0.0'),
            const SizedBox(height: 16),
            Text(
              'Aplikasi untuk membaca buku digital dengan koleksi 100+ buku dari berbagai kategori.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
        ],
      ),
    );
  }
}
