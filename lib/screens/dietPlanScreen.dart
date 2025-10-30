import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "diyet planı oluşturucu"),
    );
  }
}
