import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/components/textfield.dart';
import 'package:healty/components/dropdown.dart';
import 'package:provider/provider.dart';
import '../controllers/besin_controller.dart';
import '../controllers/meal_controller.dart';
import 'caloriesAddScreen.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  final TextEditingController _mealnameController=TextEditingController();
  final TextEditingController _caloriescalcucation=TextEditingController();

  Future<void> _mealAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Besin Değeri Ekle'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
          CustomTextField(controller:_mealnameController,hintText: "Yemek adı giriniz",icon: Icons.pending_actions_outlined,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(controller:_caloriescalcucation,hintText: "Tahmini Kalori",icon: Icons.calculate,),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                // İşlemi yap
                print("Tamam'a basıldı.");
                // Diyaloğu kapat
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  final TextEditingController _textController = TextEditingController();
  final List<String> ogunler = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Ara Öğün"];
  String? seciliOgun;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Kalori Takibi'),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _mealCard(),
            const SizedBox(height: 20),
            _ogunEkleKarti(),
          ],
        ),
      ),
    );
  }


  Widget _mealCard() {
    return Consumer<BesinController>(
      builder: (context, besinController, child) {
        final besinler = besinController.gosterilecekBesinler;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "🥗 Tüm Besinler",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _mealAlertDialog(context);
                    },
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                  )
                ],

              ),
              const SizedBox(height: 10),

              TextField(
                onChanged: besinController.filtreleBesinleri,
                decoration: InputDecoration(
                  hintText: "Besin ara...",
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),


              SizedBox(
                height: 300,
                child: besinler.isEmpty
                    ? const Center(
                  child: Text(
                    "Besin bulunamadı 🍎",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: besinler.length,
                  itemBuilder: (context, index) {
                    final besin = besinler[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text(
                            besin.turkceAd[0].toUpperCase(),
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        title: Text(
                          besin.turkceAd,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "Kalori: ${besin.kalori.toStringAsFixed(1)} kcal | "
                              "Protein: ${besin.protein.toStringAsFixed(1)}g | "
                              "Yağ: ${besin.yag.toStringAsFixed(1)}g | "
                              "Karbonhidrat: ${besin.karbonhidrat
                              .toStringAsFixed(1)}g",
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            besin.isSelected
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: besin.isSelected
                                ? Colors.green
                                : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            besinController.toggleBesinSecimi(besin);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      "Toplam Kalori: ${besinController.toplamKalori
                          .toStringAsFixed(1)} kcal",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Protein: ${besinController.toplamProtein.toStringAsFixed(
                          1)} g | "
                          "Yağ: ${besinController.toplamYag.toStringAsFixed(
                          1)} g",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _ogunEkleKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _textController,
            hintText: "Yemek adı giriniz",
          ),
          const SizedBox(height: 12),
          CustomDropdown(
            value: seciliOgun,
            icon: Icons.restaurant_menu,
            hintText: "Öğün Seçiniz",
            items: ogunler,
            onChanged: (value) {
              setState(() {
                seciliOgun = value;
              });
            },
          ),
          const SizedBox(height: 20),


          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Yemeği Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                final besinController = context.read<BesinController>();
                final mealController = context.read<MealController>();

                if (_textController.text.isEmpty || seciliOgun == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen yemek adı ve öğün seçiniz."),
                    ),
                  );
                  return;
                }
                final toplamKalori = besinController.toplamKalori;
                final toplamProtein = besinController.toplamProtein;
                final toplamYag = besinController.toplamYag;

                mealController.kaydet(
                  yemekAdi: _textController.text,
                  ogun: seciliOgun!,
                  toplamKalori: toplamKalori,
                  toplamProtein: toplamProtein,
                  toplamYag: toplamYag,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "✅ ${_textController
                          .text} adlı yemek '$seciliOgun' öğününe eklendi.",
                    ),
                  ),
                );


                _textController.clear();
                setState(() {
                  seciliOgun = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
