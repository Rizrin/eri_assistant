import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERI Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC3AA3), // Pink Elysia
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatMessages = [
    {
      "role": "system",
      "content":
          "You are a helpful assistant. Always reply in English or Indonesian, whichever the user uses."
    },
  ];

  Future<void> query(String prompt) async {
    final message = {
      "role": "user",
      "content": prompt,
    };

    chatMessages.add(message);

    final data = {
      "model": "llama3.2",
      "messages": chatMessages,
      "stream": false,
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        chatMessages.add(
          {
            "role": "system",
            "content": responseData["message"]["content"],
          },
        );

        _controller.clear();
        setState(() {});
      } else {
        chatMessages.remove(message);
        setState(() {});
      }
    } catch (e) {
      chatMessages.remove(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEC3AA3),
        title: const Text(
          "ERI Assistant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox.shrink();
                    final message = chatMessages[index];
                    final isSystem = message["role"] == 'system';
                    return Align(
                      alignment: isSystem
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: isSystem
                              ? const LinearGradient(colors: [
                                  Color(0xFFFFC0E3),
                                  Color(0xFFF8A3D5)
                                ])
                              : const LinearGradient(colors: [
                                  Color(0xFFEC3AA3),
                                  Color(0xFFB74EAD)
                                ]),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: isSystem
                                ? const Radius.circular(0)
                                : const Radius.circular(18),
                            bottomRight: isSystem
                                ? const Radius.circular(18)
                                : const Radius.circular(0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message["content"] ?? '',
                          style: TextStyle(
                            color: isSystem ? Colors.black : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.1),
                  labelText: "Enter your prompt",
                  labelStyle: const TextStyle(color: Colors.pinkAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        query(_controller.text);
                      }
                    },
                    icon: const Icon(
                      Icons.favorite, // heart icon
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
