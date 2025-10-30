import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healty/controllers/auth_service.dart';
import 'package:healty/screens/mainScreen.dart';
import 'package:healty/screens/register.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import 'homeScreen.dart';

class WeightPickerScreen extends StatefulWidget {
  const WeightPickerScreen({super.key});

  @override
  State<WeightPickerScreen> createState() => _WeightPickerScreenState();
}

class _WeightPickerScreenState extends State<WeightPickerScreen> {
bool _isLoading=true;
  double _weight = 60.0;
  final AuthService _authService=AuthService();


  late WeightSliderController _controller;
  Future<void> _saveWeightAndNavigate() async {
    setState(() => _isLoading = true);

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Kullanıcı bulunamadı. Lütfen tekrar giriş yapın.");
      }


      final Map<String, dynamic> dataToSave = {
        'weightGoal': _weight
      };


      final String? error = await _authService.updateProfileData(user.uid, dataToSave);

      if (error != null) {
        throw Exception(error);
      }

      if (mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>UserProfileScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hata: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  @override
  void initState() {
    super.initState();

    _controller = WeightSliderController(
      initialWeight: _weight,
      minWeight: 40,
      maxWeight: 150,
    );
    _checkWeightGoal();
  }
  Future<void> _checkWeightGoal() async{
    final userProfile=await _authService.getUserProfile();
    if(userProfile?.weightGoal!=null){
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()),);
      }
    }else{
      if(mounted){
        setState((){
          _isLoading=false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hedef Kilonuzu Belirleyin",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey,fontSize: 24),),
            Text(
              "${_weight.toStringAsFixed(1)} kg",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF56AB2F),
              ),
            ),
            const SizedBox(height: 30),


            Container(
              height: 300,
              child: VerticalWeightSlider(
                controller: _controller,
                isVertical: true,
                height: 300,
                indicator: Container(
                  height: 3,
                  width: 100,
                  alignment: Alignment.centerLeft,
                  color: Colors.red[300],
                ),
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA8E063),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed:_isLoading ? null: _saveWeightAndNavigate,
            child:_isLoading ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
            :
              const Text(
                "İlerle",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}