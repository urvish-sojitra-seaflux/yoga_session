// import 'package:firebase_ai/firebase_ai.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<String> _messages = [];
//   GenerativeModel? _model;
//   final generationConfig = GenerationConfig(
//     maxOutputTokens: 65535,
//     temperature: 1,
//     topP: 1,
//   );
//   final safetySettings = [
//     SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high,
//         HarmBlockMethod.probability),
//     SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high,
//         HarmBlockMethod.probability),
//     SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high,
//         HarmBlockMethod.probability),
//     SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high,
//         HarmBlockMethod.probability),
//   ];
//   void _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         _messages.add(text);
//         _controller.clear();
//       });
//       final response = await _model?.generateContent(
//         [Content.text(text)],
//       );
//       if (response != null && response.candidates.isNotEmpty) {
//         final generatedText = response.candidates.first.text;
//         debugPrint('Generated text: $generatedText');
//         setState(() {
//           _messages.add(generatedText ?? 'No response generated');
//         });
//       } else {
//         setState(() {
//           _messages.add('Error generating response');
//         });
//       }
//     }
//   }

//   GenerativeModel generateContent() {
//     // throw """
//     // Your prompt includes the seed parameter, which is not currently supported by the Firebase AI SDK.
//     // If it's OK to not have the seed as part of your request, you can remove this exception.
//     // """;
//     final ai = FirebaseAI.vertexAI(
//       location: 'global',
//       // auth: FirebaseAuth.instance,
//     );
//     final model = ai.generativeModel(
//       model: 'gemini-2.5-flash',
//       generationConfig: generationConfig,
//       safetySettings: safetySettings,
//     );
//     return model;
//   }

//   @override
//   void initState() {
//     _model = generateContent();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[_messages.length - 1 - index];
//                 return Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(msg),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.0)),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 12),
//                       ),
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: const Icon(Icons.send, color: Colors.white)),
//                     onPressed: _sendMessage,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
