import 'package:flutter/material.dart';

class Constants {
  static String lang = 'en';
  static const String CHAT_GPT_URL = "https://api.openai.com/v1";
  // static const String APP_BASE_URL = 'localhost:8000/api';
  // static const String APP_BASE_URL = 'http://10.0.2.2:8000/api';
  // static const String APP_BASE_URL = 'http://192.168.1.8:8000/api';
  // static const String APP_BASE_URL = 'https://hossam.videobesteg.xyz/api';
  static const String APP_BASE_URL = 'http://35.179.50.43/api';
  static const String CHAT_KEY =
      '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';
  static String? token;
}

Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);
Color sendColor = Colors.blue;
Color recieveColor = Colors.blueGrey;

// List<String> models = [
//   'Model1',
//   'Model2',
//   'Model3',
//   'Model4',
//   'Model5',
//   'Model6',
// ];

// List<DropdownMenuItem<String>>? get getModelsItem {
//   List<DropdownMenuItem<String>>? modelsItems =
//       List<DropdownMenuItem<String>>.generate(
//           models.length,
//           (index) => DropdownMenuItem(
//               value: models[index],
//               child: TextWidget(
//                 label: models[index],
//                 fontSize: 15,
//               )));
//   return modelsItems;
// }

// final chatMessages = [
//   {
//     "msg": "Hello who are you?",
//     "chatIndex": 0,
//   },
//   {
//     "msg":
//         "Hello, I am ChatGPT, a large language model developed by OpenAI. I am here to assist you with any information or questions you may have. How can I help you today?",
//     "chatIndex": 1,
//   },
//   {
//     "msg": "What is flutter?",
//     "chatIndex": 0,
//   },
//   {
//     "msg":
//         "Flutter is an open-source mobile application development framework created by Google. It is used to develop applications for Android, iOS, Linux, Mac, Windows, and the web. Flutter uses the Dart programming language and allows for the creation of high-performance, visually attractive, and responsive apps. It also has a growing and supportive community, and offers many customizable widgets for building beautiful and responsive user interfaces.",
//     "chatIndex": 1,
//   },
//   {
//     "msg": "Okay thanks",
//     "chatIndex": 0,
//   },
//   {
//     "msg":
//         "You're welcome! Let me know if you have any other questions or if there's anything else I can help you with.",
//     "chatIndex": 1,
//   },
// ];
