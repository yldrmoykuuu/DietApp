import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/button.dart';
import 'package:healty/components/textfield.dart';
import 'package:healty/utils/colors.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../components/appbar.dart';
import 'mainScreen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isLoading = true;

  String? gender;
  String? goal;

  List<String> dietPreferences = [];
  List<String> allergies = [];

  final List<String> dietOptions = [
    'Vegan',
    'Vejetaryen',
    'Gluten-Free',
    'Keto',
  ];
  final List<String> allergyOptions = ['Fındık', 'Süt', 'Yumurta', 'Gluten'];

  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final uid = _authService.currentUser?.uid;

    if (uid == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final doc = await _firestore.collection("users").doc(uid).get();

      final isComplete = doc.exists &&
          doc.data()?['weight'] != null &&
          doc.data()?['height'] != null &&
          doc.data()?['age'] != null &&
          doc.data()?['gender'] != null &&
          doc.data()?['goal'] != null;

      if (isComplete) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Profil kontrol hatası: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveProfileData() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      _showSnackbar(
        "Kullanıcı oturumu bulunamadı. Lütfen tekrar giriş yapın.",
        Colors.red,
      );
      return;
    }

    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final age = int.tryParse(_ageController.text.trim());

    if (weight == null ||
        height == null ||
        age == null ||
        gender == null ||
        goal == null) {
      _showSnackbar(
        "Lütfen tüm zorunlu alanları (Kilo, Boy, Yaş, Cinsiyet, Hedef) doldurunuz.",
        Colors.red,
      );
      return;
    }

    try {
      final profileData = {
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'goal': goal,
        'dietPreferences': dietPreferences,
        'allergies': allergies,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection("users")
          .doc(uid)
          .set(profileData, SetOptions(merge: true));

      _showSnackbar("Profil Bilgileri Başarıyla Kaydedildi!", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      print("Firestore Kayıt Hatası: $e");
      _showSnackbar(
        "Bilgileriniz kaydedilirken bir sorun oluştu. Lütfen konsolu kontrol edin.",
        Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'App',),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Hoşgeldiniz!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Sağlıklı beslenme yolculuğunuza başlamadan önce profil bilgilerinizi doldurun.",
                style: TextStyle(fontSize: 16, color: Colors.green.shade400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _weightController,
                icon: Icons.monitor_weight,
                hintText: "Kilo (kg)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _heightController,
                icon: Icons.height,
                hintText: "Boy (cm)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ageController,
                icon: Icons.cake,
                hintText: "Yaş",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Cinsiyet",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: ['Erkek', 'Kadın', 'Diğer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => gender = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: goal,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.flag),
                  hintText: "Hedef",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: ['Kilo Alma', 'Kilo Verme', 'Koruma']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => goal = value),
              ),
              const SizedBox(height: 16),
              MultiSelectDialogField<String>(
                items: dietOptions
                    .map((e) => MultiSelectItem<String>(e, e))
                    .toList(),
                title: const Text("Diyet Tercihleri"),
                selectedColor: AppColors.primaryLight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                buttonIcon: const Icon(Icons.fastfood),
                buttonText: const Text("Diyet Tercihleri"),
                initialValue: dietPreferences,
                onConfirm: (values) => setState(() => dietPreferences = values),
              ),
              const SizedBox(height: 16),
              MultiSelectDialogField<String>(
                items: allergyOptions
                    .map((e) => MultiSelectItem<String>(e, e))
                    .toList(),
                title: const Text("Alerjiler"),
                selectedColor: AppColors.primaryLight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                buttonIcon: const Icon(Icons.warning),
                buttonText: const Text("Alerjiler"),
                initialValue: allergies,
                onConfirm: (values) => setState(() => allergies = values),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Kaydet",
                onPressed: () {
                  _saveProfileData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
