import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/controllers/goal_controller.dart';
import 'package:healty/models/UserProfile.dart';
import 'package:provider/provider.dart';

import '../utils/weight_history_chart.dart';


class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final GoalController _controller = GoalController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final goalController = context.watch<GoalController>();
    return Scaffold(
      appBar: const CustomAppBar(title: "Hedef"),
      body: _buildBody(),

    );
  }

  Widget _goalCard(UserProfile userProfile) {
    final double currentWeight = userProfile.weight ?? 0.0;
    final double goalWeight = userProfile.weightGoal ?? 0.0;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.flag_rounded, color: Colors.orange, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Güncel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "13 Ekim",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "$currentWeight kg",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Icon(Icons.track_changes,
                        color: Colors.redAccent, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Hedef",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "20 Ekim",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "$goalWeight kg",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller.error != null) {
      return Center(child: Text(_controller.error!));
    }
    if (_controller.userProfile == null) {
      return const Center(child: Text("kullanıcı profili bulunamadı"));
    }
    final userProfile = _controller.userProfile!;
    return SafeArea(child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _goalCard(userProfile),
          const SizedBox(height: 24),
          Text("Kilo Değişim Grafiği",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
          const SizedBox(height: 46,),
          _buildWeightHistory(),
        ],
      ),
    ));
  }


  _buildWeightHistory() {
    final userProfile=_controller.userProfile;
  return Container(
    height: 300,

    child: WeightHistoryChart(
      stream: _controller.historyStream,
     goalWeight:userProfile?.weightGoal,

    ),
  );
  }
}
