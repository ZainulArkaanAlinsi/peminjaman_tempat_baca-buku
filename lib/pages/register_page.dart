import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/auth_controller.dart';
import '../app/routes.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Iconsax.arrow_left),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Daftar Akun Baru',
                style: Theme.of(context).textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Isi data diri Anda untuk mendaftar',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Name Field
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 20),

              // Confirm Password Field
              Obx(
                () => TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                      ),
                      onPressed: () => obscureConfirmPassword.toggle(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Terms and Conditions
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Saya menyetujui '),
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Register Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (_validateForm()) {
                              authController.register(
                                nameController.text,
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Daftar'),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.login),
                    child: const Text('Masuk'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon isi semua field',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak sama',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
