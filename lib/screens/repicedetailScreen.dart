import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? recipeDetail;

  final String apiKey = '';

  Future<void> fetchRecipeDetail() async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        recipeDetail = json.decode(response.body);
      });
    } else {
      throw Exception('Detay alınamadı: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecipeDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (recipeDetail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final recipe = recipeDetail!;
    return Scaffold(
      appBar: CustomAppBar(title: recipe['title'],

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(recipe['image']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⏱️ Hazırlık Süresi: ${recipe['readyInMinutes']} dk',
                      style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Text('🍽️ Porsiyon: ${recipe['servings']} kişi',
                      style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Divider(height: 30),
                  const Text('Malzemeler',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...List.generate(
                    recipe['extendedIngredients'].length,
                        (i) => Text("• ${recipe['extendedIngredients'][i]['original']}"),
                  ),
                  const Divider(height: 30),
                  const Text('Hazırlanışı',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    recipe['instructions'] ?? 'Talimat bilgisi mevcut değil.',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
