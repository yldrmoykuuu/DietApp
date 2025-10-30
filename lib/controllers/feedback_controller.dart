import 'package:healty/services/feedback_service.dart';

class FeedBackController{
  final FeedbackService _feedbackService=FeedbackService();
  Future<void> handleFeedbackSubmission(String feedbackText) async {

    return _feedbackService.submitFeedback(feedbackText);
  }
}