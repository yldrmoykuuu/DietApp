import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/controllers/auth_service.dart';
import 'package:healty/controllers/user_provider.dart';
import 'package:healty/models/UserProfile.dart';
import 'package:healty/screens/goalScreen.dart';
import 'package:healty/screens/register.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../controllers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  late Future<UserProfile?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _authService.getUserProfile();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(title: "Profil"),
      body: FutureBuilder<UserProfile?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Hata Oluştu:${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Kullanıcı profili bulunamadı.'));
          }
          final userProfile = snapshot.data!;
          return _buildProfileView(userProfile);
        },
      ),
    );
  }

  Widget _buildProfileView(UserProfile userProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Profil Resmini Düzenle",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Yaş: ${userProfile.age ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Boy: ${userProfile.height ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text("Kilo: ${userProfile.weight ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Profil Bilgileri",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            title: "Alerjiler",
            child: BulletList(items: userProfile.allergies ?? []),
            onTap: () {

              final TextEditingController _allergyController = TextEditingController();
              List<String> tempAllergies = List.from(userProfile.allergies ?? []);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {


                      void _addAlergy() {
                        final String newAllergy = _allergyController.text.trim();
                        if (newAllergy.isNotEmpty && !tempAllergies.contains(newAllergy)) {
                          setState(() {
                            tempAllergies.add(newAllergy);
                          });
                          _allergyController.clear();
                        }
                      }

                      return AlertDialog(
                        title: const Text("Alerjileri Düzenle"),
                        content: Container(
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _allergyController,
                                        decoration: const InputDecoration(labelText: "Alerji adı"),
                                        onSubmitted: (value) => _addAlergy(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle, color: Colors.green),
                                      onPressed: _addAlergy,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                if (tempAllergies.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Eklenmiş alerji yok.", style: TextStyle(color: Colors.grey)),
                                  )
                                else
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: tempAllergies.map((allergy) {
                                      return Chip(
                                        label: Text(allergy),
                                        deleteIcon: const Icon(Icons.close, size: 18),
                                        onDeleted: () {
                                          setState(() {
                                            tempAllergies.remove(allergy);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        actions: [

                          TextButton(
                            child: const Text("İptal"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),


                          TextButton(
                            child: const Text("Kaydet"),
                            onPressed: () {
                              final userProvider = Provider.of<UserProvider>(context, listen: false);
                              final authService = Provider.of<AuthService>(context, listen: false);

                              final String? uid = userProvider.user?.uid;

                              if (uid == null) {
                                print("Hata: Kullanıcı UID'si bulunamadı!");
                                Navigator.of(context).pop(); // Diyaloğu kapat
                                return; // İşlemi durdur
                              }


                              final Map<String, dynamic> datatoSave = {
                                'allergies': tempAllergies,
                                'updatedAt': FieldValue.serverTimestamp(),
                              };


                              authService.updateProfileData(uid, datatoSave).then((errorMessage) {

                                if (errorMessage == null) {
                                  // Başarılıysa
                                  print("Alerjiler başarıyla güncellendi.");
                                  // Arayüzü güncellemek için Controller'a veriyi yeniden çektir
                                  userProvider.fetchUserData();
                                } else {
                                  // Başarısızsa
                                  print("hata oluştu:$errorMessage");
                                }

                                // 6. İşlem (başarılı veya başarısız) BİTTİKTEN SONRA diyaloğu kapat
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()),);

                              }).catchError((e) {
                                // Beklenmedik bir hata olursa
                                print("Beklenmedik bir hata: $e");
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          _buildInfoCard(
            title: "Hedef",
            child: Text(userProfile.goal ?? 'Belirtilmemiş'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GoalScreen()),);
            }

          ),
          _buildInfoCard(
            title: "Diyet Tipi",
            child: BulletList(items: userProfile.dietPreferences ?? []),
            onTap: () {

              final Map<String, String> dietDescriptions = {
                "Gluten-Free": "Bu diyette buğday, arpa ve çavdar gibi gluten içeren tahıllar bulunmaz.",
                "Vejetaryen": "Et, kümes hayvanları ve balık tüketilmeyen, ancak süt ürünleri ve yumurta içerebilen bir diyettir.",
                "Vegan": "Et, süt, yumurta ve bal dahil hiçbir hayvansal ürünün tüketilmediği bir yaşam tarzıdır.",
                "Keto": "Düşük karbonhidratlı ve yüksek yağlı bir beslenme planıdır. Vücudu enerji için yağ yakmaya zorlar.",
                "Laktozsuz": "Laktoz intoleransı olanlar için süt şekeri (laktoz) içermeyen ürünlerin tercih edildiği bir diyettir."
              };


              final List<String> userDiets = userProfile.dietPreferences ?? [];

              showDialog(
                context: context,
                builder: (BuildContext context) {

                  return AlertDialog(
                    title: const Text("Diyet Detayı"),
                    content: Container(
                      width: double.maxFinite,

                      child: (userDiets.isEmpty)
                          ? const Text("Seçili bir diyet tipi bulunamadı.")

                          : ListView.builder(
                        shrinkWrap: true,

                        itemCount: userDiets.length,
                        itemBuilder: (context, index) {


                          final String dietName = userDiets[index];

                          final String description = dietDescriptions[dietName] ?? "Açıklama bulunamadı.";


                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ListTile(

                              leading: Icon(Icons.check_circle_outline, color: Colors.green[600]),
                              title: Text(dietName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(description),
                            ),
                          );
                        },
                      ),
                    ),
                    actions: [

                      TextButton(
                        child: const Text("Tamam"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),





        ],
      ),
    );
  }
}

Widget _buildInfoCard({
  required String title,
  required Widget child,
  VoidCallback? onTap, // Bu parametreyi zaten eklemişsin, harika!
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,


      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 2. BAŞLIK VE İKON İÇİN ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Başlığın
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),


                  if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.blueGrey,
                    ),
                ],
              ),

              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}



class BulletList extends StatelessWidget {
  final List<String>? items;
  final String emptyText;

  const BulletList({
    super.key,
    required this.items,
    this.emptyText = "Belirtilmemiş",
  });

  @override
  Widget build(BuildContext context) {
    if (items == null || items!.isEmpty) {
      return Text(emptyText);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items!.map((item) => Text("• $item")).toList(),
    );
  }
}