import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String apiKey = 'AIzaSyBhOhNpNEXXjzTrghu_lGZ58HgTbkezGs0';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('AI Prompt')), 
        body: const AIChatScreen(),
      ),
    );
  }
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  Future<void> _sendPrompt() async {
    if (_controller.text.isEmpty) return;
    final content = [Content.text(_controller.text)];
    final response = await _model.generateContent(content);
    setState(() => _response = response.text ?? "No response received.");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter prompt',
              ),
            ),
            const SizedBox(height: 10),

            // Displaying the prompt inside a light grey bordered container
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withAlpha(128)), // Light grey border
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Text(
                'Your prompt: ${_controller.text}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _sendPrompt,
              child: const Text('Send'),
            ),
            const SizedBox(height: 20),
            Text(
              _response,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
