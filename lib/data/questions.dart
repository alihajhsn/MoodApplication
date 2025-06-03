//data/questions.dart

import 'package:mood_application_project/models/answer.dart';
import 'package:mood_application_project/models/mood.dart';
import 'package:mood_application_project/models/question.dart';

final List<Question> questions = [
Question(text: 
"1. How are you feeling right now?", 
Answers: [
  Answer(text: "I feel surrounded by warmth and care.", mood: Mood.Loved),
  Answer(text: 	"I feel amazing, like everything is going my way today!", mood: Mood.Happy),
  Answer(text: "I'm not feeling great... it’s been a tough day.", mood: Mood.Sad),
  Answer(text: 	"I feel strong and ready to face anything.", mood: Mood.Confident),
  Answer(text: 	"I’m just okay — nothing special going on.", mood: Mood.Neutral),
  Answer(text: 	"I’m feeling calm and at peace right now.", mood: Mood.Relaxed),
  Answer(text: "Honestly, I just want to sleep all day.", mood: Mood.Tired),

]),

Question(text: 
"2. What best describes your current energy level?", 
Answers: [
  Answer(text: 	"I feel emotionally recharged by the people around me.", mood: Mood.Loved),
  Answer(text: 	"I'm full of joy and light — ready for anything fun!", mood: Mood.Happy),
  Answer(text: "I have no energy... just trying to get through the day.", mood: Mood.Sad),
  Answer(text: "I’ve got the energy and focus to get things done!", mood: Mood.Confident),
  Answer(text: "I’m neither energetic nor tired — just in the middle.", mood: Mood.Neutral),
  Answer(text: 	"I’m feeling laid-back and comfortable, no rush today.", mood: Mood.Relaxed),
  Answer(text: "I feel drained and really need a break.", mood: Mood.Tired),

]),

Question(text: 
"3. How do you feel about the people around you today?", 
Answers: [
  Answer(text: "I feel deeply connected to the people I care about.", mood: Mood.Loved),
  Answer(text: "Everyone seems great — I’m enjoying being around them!", mood: Mood.Happy),
  Answer(text: "I feel distant, like no one really understands me.", mood: Mood.Sad),
  Answer(text: 	"I feel respected and supported, which lifts me up.", mood: Mood.Confident),
  Answer(text: "I don’t have strong feelings about anyone today.", mood: Mood.Neutral),
  Answer(text: "Being around calm people is helping me stay at ease.", mood: Mood.Relaxed),
  Answer(text: "I’m too exhausted to engage with anyone right now.", mood: Mood.Tired),

]),

Question(text: 
"4. How would you like to spend the rest of your day?", 
Answers: [
  Answer(text: "Spending quality time with someone close.", mood: Mood.Loved),
  Answer(text: 	"Doing something fun with people I enjoy being around!", mood: Mood.Happy),
  Answer(text: 	"Just being alone to process my emotions.", mood: Mood.Sad),
  Answer(text: 	"Tackling goals and making real progress.", mood: Mood.Confident),
  Answer(text: "Going with the flow, nothing in particular.", mood: Mood.Neutral),
  Answer(text: "Unwinding with a quiet walk or some music.", mood: Mood.Relaxed),
  Answer(text: 	"Getting some good rest — maybe even a nap.", mood: Mood.Tired),

]),
];