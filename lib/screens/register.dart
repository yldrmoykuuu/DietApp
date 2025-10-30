import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty/controllers/auth_service.dart';
import 'package:healty/screens/mainScreen.dart';
import 'package:healty/screens/splashScreen.dart';
import 'package:healty/screens/weightPickerScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:healty/components/button.dart';
import 'package:healty/components/textfield.dart';
import 'package:healty/utils/colors.dart';


import '../controllers/user_provider.dart';
import 'homeScreen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSignUp = true;


  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submit() async {
    final email = _mailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    String? errorMessage;







    if (email.isEmpty || password.isEmpty || (isSignUp && username.isEmpty)) {
      errorMessage = "Lütfen tüm alanları doldurunuz";
    }

    if (errorMessage != null) {
      _showSnackbar(errorMessage, Colors.red);
      return;
    }


    if (isSignUp) {

      errorMessage = await _authService.signUp(
          email: email, password: password, username: username);
    } else {

      errorMessage = await _authService.signIn(email: email, password: password);
    }


    if (errorMessage == null) {

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
      _usernameController.clear();
      _mailController.clear();
      _passwordController.clear();

      _showSnackbar(
        isSignUp ? "Kayıt Başarılı" : "Giriş Başarılı",
        Colors.green,
      );


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeightPickerScreen()),
      );
    } else {
      _showSnackbar(errorMessage, Colors.red);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 16),
              Text(
                "Akıllı Diyet Asistanı",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Sağlıklı beslenmeye adım at",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade400,
                ),

              ),
              const SizedBox(height: 40),
              ToggleSwitch(
                minWidth: size.width * 0.35,
                minHeight: 55,
                initialLabelIndex: isSignUp ? 1 : 0,
                cornerRadius: 30,
                totalSwitches: 2,
                labels: const ['Giriş Yap', 'Kayıt Ol'],
                icons: const [
                  Icons.login,
                  Icons.person_add,
                ],
                iconSize: 28,
                activeBgColors: const [
                  [Color(0xff32a852), Color(0xff7de3b4)],
                  [Color(0xff34c1f2), const Color(0xff0b71c8)],
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey.shade200,
                inactiveFgColor: Colors.grey.shade700,
                borderColor: const [Colors.transparent, Colors.transparent],
                borderWidth: 0,
                dividerColor: Colors.transparent,
                onToggle: (index) {
                  setState(() {
                    isSignUp = index == 1;
                  });
                },
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    if (isSignUp) ...[
                      CustomTextField(
                        controller: _usernameController,
                        icon: Icons.person,
                        hintText: "Kullanıcı Adı",
                      ),
                      const SizedBox(height: 16),
                    ],
                    CustomTextField(
                      controller: _mailController,
                      icon: Icons.mail,
                      hintText: "E-Mail",
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hintText: "Şifre",
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: isSignUp
                                ? [const Color(0xff34c1f2), const Color(0xff0b71c8)]
                                : [const Color(0xff32a852), const Color(0xff7de3b4)],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isSignUp ? "Kayıt Ol" : "Giriş Yap",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
