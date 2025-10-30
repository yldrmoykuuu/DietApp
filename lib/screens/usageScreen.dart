// kullanim_kosullari_screen.dart


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/appbar.dart';

class KullanimKosullariScreen extends StatelessWidget {
  const KullanimKosullariScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Kullanım Koşulları',

      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metinleri daha kolay yönetmek için helper metotlar kullanabiliriz
            _buildHeading("1. Hizmetin Kapsamı"),
            _buildParagraph(
              "Bu uygulama ('Healtify'), kullanıcılara sağlıklı yaşam ve diyet takibi konusunda yardımcı olmak amacıyla tasarlanmıştır. Sunulan içerikler ve tavsiyeler profesyonel tıbbi tavsiye niteliği taşımaz. Herhangi bir sağlık programına başlamadan önce mutlaka doktorunuza danışın.",
            ),

            _buildHeading("2. Kullanıcı Yükümlülükleri"),
            _buildParagraph(
              "Uygulamayı kullanırken sağladığınız bilgilerin (kilo, boy, vb.) doğru olduğunu kabul edersiniz. Hesap güvenliğinizden siz sorumlusunuz. Yasalara aykırı veya uygulamanın amacına uygun olmayan herhangi bir davranışta bulunmamayı taahhüt edersiniz.",
            ),

            _buildHeading("3. Fikri Mülkiyet"),
            _buildParagraph(
              "Uygulama içerisindeki tüm tasarımlar, metinler, logolar ve yazılımlar 'Healtify' mülkiyetindedir ve izinsiz kullanılamaz.",
            ),

            _buildHeading("4. Sorumluluğun Sınırlandırılması"),
            _buildParagraph(
              "Uygulamanın kullanımından doğabilecek herhangi bir veri kaybı, yanlış yönlendirme veya sağlık sorunundan 'Healtify' sorumlu tutulamaz. Uygulama 'olduğu gibi' sunulmaktadır.",
            ),

            _buildHeading("5. Değişiklikler"),
            _buildParagraph(
              "Bu kullanım koşulları zaman zaman güncellenebilir. Değişiklikler uygulamada yayınlandığı anda yürürlüğe girer. Uygulamayı kullanmaya devam ederek güncel koşulları kabul etmiş sayılırsınız.",
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "Son Güncelleme: 29 Ekim 2025",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Başlıklar için yardımcı metot
  Widget _buildHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Paragraflar için yardımcı metot
  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
        height: 1.5, // Satır yüksekliği
      ),
      textAlign: TextAlign.justify, // İki yana yaslanmış
    );
  }
}