import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  // Firebase Firestore'un bir örneğini (instance) al
  final CollectionReference _feedbackCollection =
  FirebaseFirestore.instance.collection('feedback');

  /// Aldığı 'feedbackText' metnini Firebase'e kaydeder.
  Future<void> submitFeedback(String feedbackText) async {
    try {
      if (feedbackText.trim().isEmpty) {
        // Boş geri bildirim göndermeyi engelle
        return;
      }

      await _feedbackCollection.add({
        'text': feedbackText,
        'timestamp': FieldValue.serverTimestamp(), // Sunucu tarihini ekle
        // TODO: İleride giriş yapmış kullanıcının ID'sini de ekleyebilirsiniz
        // 'userId': FirebaseAuth.instance.currentUser?.uid,
      });
    } catch (e) {
      // Bir hata olursa, hatayı tekrar fırlat ki Controller bunu yakalayabilsin
      print("FeedbackService Hatası: $e");
      throw Exception('Geri bildirim gönderilemedi.');
    }
  }
}