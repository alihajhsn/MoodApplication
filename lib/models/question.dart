//models/question.dart

import 'package:mood_application_project/models/answer.dart';

class Question {

  final String text;
  final List<Answer> Answers;

  Question({required this.text, required this.Answers});
}