

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/components/articlecard.dart';
import 'package:healty/controllers/auth_service.dart';
import 'package:healty/models/Article.dart';
import 'package:healty/screens/ReportScreen.dart';
import 'package:healty/screens/caloriesScreen.dart';

import 'package:healty/screens/profileScreen.dart';
import 'package:healty/screens/register.dart';

import 'package:healty/screens/settingsScreen.dart';
import 'package:healty/screens/splashScreen.dart';
import 'package:healty/utils/date_enums.dart';



import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../controllers/meal_controller.dart';

import '../controllers/water_controller.dart';
import 'articleDetailScreen.dart';
import 'dietPlanScreen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _authService=AuthService();
  final String? _uid=FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();

    _loadUsername();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<WaterController>().fetchTodaysWater();
    });
    Future.microtask(() {
      Provider.of<MealController>(context, listen: false).getGunlukVeri();
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? username;


  final DateTime now = DateTime.now();


  late final String gun = now.day.toString();
  late final String ay =TurkishMonth.fromMonthInt(now.month).displayName;


  late final String tarih = "$gun.$ay";


  Future<void> _loadUsername() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data()!.containsKey('username')) {
          setState(() {
            username = doc['username'];
          });
        }
      }
    } catch (e) {
      debugPrint("Kullanıcı adı alınamadı: $e");
    }
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      drawer: _buildDrawer(),
      appBar:  CustomAppBar(title: 'Healthy App',showMenu: true,
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()),);
          }, child:Icon(Icons.login,color: Colors.white,),)
        ],


      ),body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Lottie.asset(
                  'assets/diet.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),




                Expanded(
                  child:TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Reportscreen()),);


                  }, child: Text("Raporlarımı görüntüle📊 ",style: TextStyle(fontWeight: FontWeight.bold),))
                ),
              ],
            ),

            _buildHealtyCard(context),
            _buildProgressCard(),
            _buildMealSummaryCard(context),
            const WaterTrackerCard(),
            _buildArticleCarousel(context),
            _buildHabitsCards() ?? Container(),
          ],
        ),
      ),
    ),

    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xffe8f5e9),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff32a852), Color(0xff7de3b4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xff32a852)),
                ),
                const SizedBox(height: 10),
                Text(
                  username == null ? "Hoşgeldin!" : "Hoşgeldin $username✮⋆˙",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xff32a852)),
            title: const Text("Profil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.arrow_circle_down_rounded, color: Color(0xff32a852)),
            title: const Text("Uygun diyet planı oluştur"),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => DietPlanScreen()),);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xff32a852)),
            title: const Text("Ayarlar"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()),);
            },
          ),
          ListTile(
            leading: const Icon(Icons.output, color: Color(0xff32a852)),
            title: const Text("Çıkış"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()),);
            },
          ),




        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final mealController = context.watch<MealController>();
    final double fatCal = mealController.toplamYag * 9;
    final double proteinCal = mealController.toplamProtein * 4;
    final double totalCal = mealController.toplamKalori > 0
        ? mealController.toplamKalori
        : (fatCal + proteinCal);
    final double fatPercent = totalCal > 0 ? fatCal / totalCal : 0;
    final double proteinPercent = totalCal > 0 ? proteinCal / totalCal : 0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Kalorimetre",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CaloriesScreen()),
                    );
                  },
                  child: const Text("Öğün Ekle"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Calories ", style: TextStyle(fontSize: 16)),
                const Icon(Icons.local_fire_department, color: Colors.orange),
                Text(" ${mealController.toplamKalori.toStringAsFixed(0)} kcal"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroIndicator("Yağ", fatPercent, Colors.yellow),
                _buildMacroIndicator("Protein", proteinPercent, Colors.blue),
              ],
            ),
            const SizedBox(height: 12),
            const Text(" Disiplin, hedefler ve başarı arasındaki köprüdür."),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroIndicator(String label, double percent, Color color) {
    final double p = percent.clamp(0.0, 1.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 25,
          lineWidth: 6,
          percent: p,
          progressColor: color,
          backgroundColor: Colors.grey[200]!,
          center: Text(
            "${(p * 100).toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }


  Widget _buildArticleCarousel(BuildContext context) {

    final List<Article> articles = [
      Article(
        title: "Sağlıklı Tabağın Sırrı",
        imageUrl: "https://images.pexels.com/photos/1153370/pexels-photo-1153370.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        summary: """
Sağlıklı bir tabak oluşturmak, katı kurallar veya kalori sayımından çok daha fazlasıdır. Bu, bir denge ve çeşitlilik sanatıdır. Harvard Sağlıklı Beslenme Tabağı modeline göre, ideal bir öğünün yarısı renkli sebze ve meyvelerden oluşmalıdır. Bu gıdalar, vücudunuzun ihtiyaç duyduğu temel vitamin, mineral ve lifleri sağlar.

Tabağınızın diğer yarısını ise ikiye bölün:
1.  **Kaliteli Proteinler (Tabağın ¼'ü):** Tavuk, balık, baklagiller (mercimek, nohut) ve kuruyemişler mükemmel protein kaynaklarıdır. Protein, kas onarımı ve doygunluk hissi için kritik öneme sahiptir. İşlenmiş etlerden (sosis, salam) mümkün olduğunca kaçının.
2.  **Tam Tahıllar (Tabağın ¼'ü):** Beyaz ekmek veya beyaz pirinç yerine kinoa, karabuğday, esmer pirinç veya tam buğday ekmeği tercih edin. Tam tahıllar, kan şekerinizi daha yavaş yükseltir, daha uzun süre tok kalmanızı sağlar ve sindirim sisteminiz için gerekli lifi sunar.

Unutmayın, sağlıklı yağlar da (zeytinyağı, avokado, ceviz gibi) bu denklemin önemli bir parçasıdır. Önemli olan porsiyon kontrolü ve çeşitliliktir.
""",
      ),
      Article(
        title: "Metabolizma 101: Hızlandırmak Mümkün mü?",
        imageUrl: "https://images.pexels.com/photos/3872373/pexels-photo-3872373.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        summary: """
Metabolizma, vücudunuzun yiyecekleri enerjiye dönüştürme sürecidir. Bazal Metabolizma Hızı (BMH), siz dinlenirken vücudunuzun harcadığı kalori miktarıdır ve bu, genetik, yaş, cinsiyet ve kas kütlesi gibi faktörlere bağlıdır.

'Metabolizma hızlandırıcı' olarak pazarlanan ürünlerin çoğu bilimsel bir temele dayanmaz. Ancak metabolizmanızı doğal yollarla desteklemenin kanıtlanmış yolları vardır:
* **Kas Kütlesini Artırın:** Kaslar, yağdan daha fazla kalori yakar. Ağırlık antrenmanı yapmak, dinlenme halindeyken bile metabolizma hızınızı artırır.
* **Yeterli Protein Tüketin:** Protein, sindirimi sırasında diğer makro besinlere göre daha fazla kalori yakar (Termik Etki).
* **Hareket Edin:** Düzenli egzersiz ve gün içindeki basit hareketler (merdiven çıkmak, yürümek) toplam kalori harcamanızı artırır.
* **Su İçin:** Yeterli hidrasyon, metabolik süreçlerin optimal çalışması için gereklidir.

Unutmayın, kalıcı değişiklikler küçük ve sürdürülebilir alışkanlıklarla gelir.
""",
      ),
      Article(
        title: "Su: Zayıflamanın Gizli Kahramanı",
        imageUrl: "https://www.medyamalatya.com/files/uploads/news/default/20240612-zayiflamak-ugruna-fazla-su-icmek-olumcul-olabilir-234491-3c3ae678f695d0189a8c.jpg",
        summary: """
Su, vücut fonksiyonlarının neredeyse tamamında rol oynayan hayati bir bileşendir. Peki, zayıflama üzerindeki etkisi nedir?
Araştırmalar, özellikle yemeklerden önce su içmenin tokluk hissini artırarak porsiyon kontrolüne yardımcı olabileceğini göstermektedir. Bazen vücudumuz susuzluk sinyalini açlık sinyali ile karıştırabilir. Yeterli su içmek, bu 'sahte açlık' hissinin önüne geçer.

Ayrıca, suyun 'termojenik' bir etkisi olabilir. Vücut, soğuk suyu ısıtmak için enerji harcar ve bu da geçici olarak metabolizmayı hızlandırabilir. Günlük su ihtiyacı kişiden kişiye değişmekle birlikte, genel bir kural olarak idrar renginizin açık sarı olması iyi bir göstergedir. Enerji içecekleri veya şekerli meşrubatlar yerine suyu tercih etmek, kalori alımınızı ciddi oranda düşürmenin en basit yoludur.
""",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            "İçerikler",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return InkWell(
                onTap: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>ArticleDetailPage(article: article),
),);
                },
                child: ArticleCard(article: article),
              );
            },
          ),
        ),
      ],
    );
  }

  _buildHealtyCard(BuildContext context) {
    final TextEditingController _weightController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

            margin: const EdgeInsets.symmetric(horizontal: 9,vertical: 10),
            clipBehavior: Clip.antiAlias,
            child:InkWell(
              onTap: (){
                showDialog(context: context, builder: (BuildContext dialogContext){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),
                    ),
                    title: Text("Güncel Kilo",style: TextStyle(color: Colors.lightGreen),),
                    content: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: "Örn: 74.5",
                        labelText: "Kilo (kg)",
                      ),
                    ),
                    actions:<Widget> [
                      TextButton(onPressed: () async {
          final String weightText=_weightController.text.trim().replaceAll(',','.');
          final double? newWeight=double.tryParse(weightText);
          if(_uid==null){
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullancı oturumu bulamadı.Lütfen tekrar deneyiniz")),);
            return;
          }
          if(newWeight==null || newWeight<=0){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lütfen  geçerli bir kilo giriniz")),);
            return;

          }
          final String? error=await _authService.logAndUpdateWeight(_uid!, newWeight);
          if(error==null){
            _weightController.clear();
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kilo başarıyla güncellendi"),));

          }else{
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata:$error"),));
          }


                      }, child: const Text("Güncelle")),
                      TextButton(onPressed: (){Navigator.of(dialogContext).pop();}, child: const Text("İptal")),
                    ],
                  );
                });
              },

            child: Padding(padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.accessibility_rounded,
                    color: Colors.green,
size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sağlık Ölçümünüzü Yapın!",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 8),
                    Text("Ölçümünü buradan ekle 👇",style: TextStyle(fontSize: 14),),

                  ],
                ))
              ],
            ),),


          )
          ),
        ),
      ],
    );
  }
}

  _buildHabitsCards() {



}

Widget _buildMealSummaryCard(BuildContext context) {
  final mealController = Provider.of<MealController>(context);
  final ogunler = mealController.bugunkuOgunler;

  if (mealController.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (ogunler.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Bugün için kayıtlı öğün bulunamadı 🍽️",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0),
        child: Text(
          "Bugünkü Öğünler",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 12),


      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ogunler.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final ogun = ogunler[index];


            Color bgColor;
            IconData icon;
            switch (ogun['ogun']) {
              case 'Kahvaltı':
                bgColor = Colors.orangeAccent;
                icon = Icons.breakfast_dining;
                break;
              case 'Öğle Yemeği':
                bgColor = Colors.blueAccent;
                icon = Icons.lunch_dining;
                break;
              case 'Ara Öğün':
                bgColor = Colors.pinkAccent;
                icon = Icons.local_pizza;
                break;
              case 'Akşam Yemeği':
                bgColor = Colors.orange;
                icon = Icons.dinner_dining;
                break;
              default:
                bgColor = Colors.teal;
                icon = Icons.restaurant;
            }

            return Container(
              width: 130,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [bgColor.withOpacity(0.9), bgColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    Text(
                      ogun['ogun'] ?? "Öğün",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ogun['isim'] ?? "Yemek adı",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${ogun['kalori']?.toStringAsFixed(0) ?? 0} kcal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}










class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {

    final waterController = context.watch<WaterController>();

    final double currentWater = waterController.currentWater;
    final double goalWater = waterController.goalWater;
    double fillPercentage = (goalWater > 0) ? currentWater / goalWater : 0;

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(

            ),
            const SizedBox(height: 20),


            if (waterController.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: LiquidCircularProgressIndicator(
                          value: fillPercentage,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),

                          center: Text(
                            "${(fillPercentage * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(

                        "${currentWater.toStringAsFixed(2)} L / $goalWater L",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 50),


                        onPressed: () => waterController.addWater(),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.redAccent, size: 50),

                        onPressed: () => waterController.removeWater(),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}