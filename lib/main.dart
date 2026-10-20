import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Surendhar AI Resume Builder',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  // 1. Controllers to store input text from fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController projectsController = TextEditingController();
  final TextEditingController certificationsController =
      TextEditingController();
  final TextEditingController eventsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  String resultText = "";

  // 2. HTTP function to talk to your Spring Boot backend
  Future<void> generateResume() async {
    setState(() {
      isLoading = true;
      resultText = "";
    });

    // Use http://10.0.2.2:8080/generate for Android Emulator or http://localhost:8080/generate for Flutter Web
    final url = Uri.parse('http://localhost:8080/generate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': nameController.text,
          'education': educationController.text,
          'userDescription':
              'Projects: ${projectsController.text}. '
              'Certifications: ${certificationsController.text}. '
              'Events: ${eventsController.text}. '
              'Description: ${descriptionController.text}',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          resultText = response.body;
        });
      } else {
        setState(() {
          resultText = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        resultText = "Connection Failed: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Container
          Container(
            width: 250,
            color: const Color.fromARGB(221, 234, 90, 7),
            child: Column(
              children: [
                const SizedBox(height: 40),
                ListTile(
                  selected: selectedIndex == 0,
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => setState(() => selectedIndex = 0),
                ),
                ListTile(
                  selected: selectedIndex == 1,
                  leading: const Icon(Icons.description, color: Colors.white),
                  title: const Text(
                    "My Resumes",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                ListTile(
                  selected: selectedIndex == 2,
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => setState(() => selectedIndex = 2),
                ),
              ],
            ),
          ),

          // Main Form Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          "SURENDHAR AI RESUME BUILDER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input TextFields attached to Controllers
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: educationController,
                      decoration: const InputDecoration(
                        hintText: "education",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: projectsController,
                      decoration: const InputDecoration(
                        hintText: "projects",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: certificationsController,
                      decoration: const InputDecoration(
                        hintText: "certifications",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: eventsController,
                      decoration: const InputDecoration(
                        hintText: "events participation",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Button attached to generateResume method
                    ElevatedButton(
                      onPressed: isLoading ? null : generateResume,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 60),
                        backgroundColor: const Color.fromARGB(221, 234, 90, 7),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Generate Resume",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    const SizedBox(height: 30),

                    // Output Display Box
                    if (resultText.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          resultText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
