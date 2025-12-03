import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/auth_controller.dart';
import '../app/routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo/Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.book,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                'Selamat Datang!',
                style: Theme.of(context).textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Masuk untuk melanjutkan membaca',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'masukkan@email.com',
                  prefixIcon: Icon(Iconsax.sms),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Password Field
              Obx(
                () => TextField(
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () => obscurePassword.toggle(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.snackbar('Info', 'Fitur lupa password segera hadir');
                  },
                  child: const Text('Lupa Password?'),
                ),
              ),

              const SizedBox(height: 24),

              // Login Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Mohon isi semua field',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            authController.login(
                              emailController.text,
                              passwordController.text,
                            );
                          },
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Masuk'),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.register),
                    child: const Text('Daftar Sekarang'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
