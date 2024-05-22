import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linguotech/Screens/Translation_Screen/Eng_translate_Screen.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _userFriendlyRating = 0;
  int _difficultyRating = 0;
  int _helpfulnessRating = 0;
  int _translationRating = 0;
  int _summarizationRating = 0;

  void _submitFeedback() async {
    try {
      await _firestore.collection('feedback').add({
        'user_friendly': _userFriendlyRating,
        'difficulty': _difficultyRating,
        'helpfulness': _helpfulnessRating,
        'translation': _translationRating,
        'summarization': _summarizationRating,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully')),
      );
    } catch (e) {
      print('Error submitting feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback')),
      );
    }
  }

  Widget _buildRatingBar(String question, int rating, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                onChanged(index + 1);
              },
              child: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: index < rating ? Colors.orange : Colors.grey,
                size: 30,
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EngTranslationScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildRatingBar(
                  'Is it user friendly?', _userFriendlyRating, (rating) {
                setState(() {
                  _userFriendlyRating = rating;
                });
              }),
            ),
            Expanded(
              child: _buildRatingBar(
                  'Did you face any difficulties?', _difficultyRating,
                  (rating) {
                setState(() {
                  _difficultyRating = rating;
                });
              }),
            ),
            Expanded(
              child: _buildRatingBar(
                  'How much did our app help you?', _helpfulnessRating,
                  (rating) {
                setState(() {
                  _helpfulnessRating = rating;
                });
              }),
            ),
            Expanded(
              child: _buildRatingBar('Rate translation', _translationRating,
                  (rating) {
                setState(() {
                  _translationRating = rating;
                });
              }),
            ),
            Expanded(
              child: _buildRatingBar(
                  'Rate text summarization', _summarizationRating, (rating) {
                setState(() {
                  _summarizationRating = rating;
                });
              }),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
