import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healty/screens/register.dart';
import 'package:healty/screens/weightPickerScreen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState(){
    super.initState();
    _controller=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8500),
    );
    _fadeAnimation=CurvedAnimation(parent: _controller, curve: Curves.easeIn,);
    _scaleAnimation=CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
    Timer(const Duration(seconds: 10),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()),);

    });

  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  const BoxDecoration(
          gradient: LinearGradient(
              colors:[Color(0xFFA8E063), Color(0xFF56AB2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Center(
          child: FadeTransition(opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center
            ,
            children: [
              Lottie.asset('assets/animation.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain),
              const SizedBox(height: 20),
              const Text( "Healtify",style: TextStyle(fontSize: 32,fontWeight:FontWeight.bold,color: Colors.white),),
              const SizedBox(height: 12),
              Text("Hedef kilona birlikte ulaşalım",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.85),
              ),),

            ],
          ),
          ),

        ),
      ),
    );
  }
}

