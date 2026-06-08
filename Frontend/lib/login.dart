import 'package:flutter/material.dart';
import 'main.dart';
import 'api_service.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  // ===== VALIDASI =====
  String? validateEmail(String email) {
    if (email.isEmpty) return 'Email tidak boleh kosong';
    if (!email.contains('@') || !email.contains('.')) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password tidak boleh kosong';
    if (password.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  // ===== OAUTH LOGIN (Google Simulation) =====
  Future<void> handleOAuthLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Simulasi data Google OAuth (nama + email random untuk demo)
      final randomId = Random().nextInt(99999);
      final simulatedName = 'Google User $randomId';
      final simulatedEmail = 'googleuser$randomId@gmail.com';

      final result = await ApiService.oauthLogin(simulatedName, simulatedEmail);

      if (result['token'] != null) {
        ApiService.token = result['token'];
        ApiService.userName = result['user']['name'];
        ApiService.userEmail = simulatedEmail;
        ApiService.userRole = result['user']['role'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        setState(() => errorMessage = result['message'] ?? 'OAuth login gagal');
      }
    } catch (e) {
      setState(() => errorMessage = 'Tidak bisa terhubung ke server');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ===== LOGIN =====
  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Cek validasi
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null) {
      setState(() => errorMessage = emailError);
      return;
    }
    if (passwordError != null) {
      setState(() => errorMessage = passwordError);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.login(email, password);

      if (result['token'] != null) {
        // Simpan token + user info
        ApiService.token = result['token'];
        ApiService.userName = result['user']['name'];
        ApiService.userEmail = email;
        ApiService.userRole = result['user']['role'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        setState(() => errorMessage = result['message'] ?? 'Login gagal');
      }
    } catch (e) {
      setState(() => errorMessage = 'Tidak bisa terhubung ke server');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                "assets/GachaShop.png",
                width: 160,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.shopping_bag, size: 100, color: Colors.white);
                },
              ),

              const SizedBox(height: 20),

              // TITLE
              const Text(
                "Gacha Shop",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // ERROR MESSAGE
              if (errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              // EMAIL
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2A2A40),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2A2A40),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F5AF0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // DIVIDER
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: TextStyle(color: Colors.white38)),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),

              const SizedBox(height: 20),

              // GOOGLE OAUTH BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : handleOAuthLogin,
                  icon: const Icon(Icons.account_circle, color: Colors.white70),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // REGISTER LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Color(0xFF7F5AF0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

// ===================================================
// REGISTER PAGE
// ===================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  // ===== VALIDASI =====
  String? validateName(String name) {
    if (name.isEmpty) return 'Nama tidak boleh kosong';
    if (name.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return 'Email tidak boleh kosong';
    if (!email.contains('@') || !email.contains('.')) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password tidak boleh kosong';
    if (password.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  // ===== REGISTER =====
  Future<void> handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final nameError = validateName(name);
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (nameError != null) {
      setState(() => errorMessage = nameError);
      return;
    }
    if (emailError != null) {
      setState(() => errorMessage = emailError);
      return;
    }
    if (passwordError != null) {
      setState(() => errorMessage = passwordError);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.register(name, email, password);

      if (result['message'] == 'User registered successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => errorMessage = result['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      setState(() => errorMessage = 'Tidak bisa terhubung ke server');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1E2E), elevation: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),

            const SizedBox(height: 30),

            // ERROR MESSAGE
            if (errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            // NAME
            buildField("Full Name", controller: nameController),

            // EMAIL
            buildField("Email", controller: emailController),

            // PASSWORD
            buildField("Password", controller: passwordController, isPassword: true),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String hint, {bool isPassword = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF2A2A40),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}