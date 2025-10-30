import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/appbar.dart';

class WaterDetailScreen extends StatefulWidget {
  const WaterDetailScreen({super.key});

  @override
  State<WaterDetailScreen> createState() => _WaterDetailScreenState();
}

class _WaterDetailScreenState extends State<WaterDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "SU dETAY",),
    );
  }
}
