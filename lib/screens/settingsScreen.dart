import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/screens/usageScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Padding(padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ayarlar",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),


                ),
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: Icon(Icons.cancel_outlined, color: Colors.black45),)
              ],
            ),
            Expanded(child: ListView(
              children: [
                _buildSettingsCard(
                  icon: Icons.workspace_premium,
                  color: Colors.green,
                  title: "Premium Avantajları",
                  onTap: () {},
                ),
                const SizedBox(height: 24,),
                _buildSettingsCard(
                  icon: Icons.message,
                  color: Colors.green,
                  title: "Geri Bildirim Yolla",
                  onTap: () {
                    _showFeedBackDialog(context);
                  },
                ),
                _buildSettingsCard(
                  icon: Icons.pending_actions_outlined,
                  color: Colors.green,
                  title: "Kullanım Koşulları",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => KullanimKosullariScreen()),);
                  },
                ),
                _buildSettingsCard(
                  icon: Icons.mark_unread_chat_alt,
                  color: Colors.green,
                  title: "Healtify Destek",
                  onTap: () {},
                ),

                const SizedBox(height: 24,),
                _buildSettingsCard(
                  icon: Icons.star,
                  color: Colors.green,
                  title: "AppStore'da Bizi Destekle",
                  onTap: () {},
                ),
                _buildSettingsCard(
                  icon: Icons.share,
                  color: Colors.green,
                  title: "Arkadaşlarını Davet Et",
                  onTap: () {},
                ),
              ],
            ))
          ],
        ),)
      ),
    );
  }

  _buildSettingsCard(
      {required IconData icon, required Color color, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),

      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: color, size: 36),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  void _showFeedBackDialog(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {

        bool _isSending = false; // Diyalog içindeki lokal state

        return StatefulBuilder( // _isSending durumunu yönetmek için
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Geri Bildirim "),
              content: TextField(
                controller: _feedbackController,
                enabled: !_isSending,
                decoration: InputDecoration(
                    hintText: "Lütfen düşüncelerinizi buraya yazın...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                maxLines: 5,
                minLines: 3,
              ),
              actions: [
                TextButton(
                  onPressed: _isSending ? null : () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text("Vazgeç"),
                ),
                ElevatedButton(
                  onPressed: _isSending ? null : () async {

                    final String feedbackText = _feedbackController.text;
                    if (feedbackText.trim().isEmpty) return; // Boşsa gönderme

                    setState(() { _isSending = true; }); // Yükleniyor...

                    try {


                      print("başarılı");

                      // Başarılıysa
                      Navigator.pop(dialogContext); // Diyalogu kapat


                    } catch (e) {
                      // Hata olursa (Controller'dan veya Servis'ten fırlatılan)
                      setState(() { _isSending = false; }); // Yüklenmeyi durdur

                      Navigator.pop(dialogContext); // Diyalogu kapat
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hata: ${e.toString()}')),
                      );
                    }
                  },
                  child: _isSending
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,))
                      : Text("Gönder"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, foregroundColor: Colors.white),
                )
              ],
            );
          },
        );
      },
    );
  }

}