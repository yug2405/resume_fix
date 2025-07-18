import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  final TextEditingController _languageController = TextEditingController();
  int _selectedLevel = 3;

  void addLanguage() {
    final lang = _languageController.text.trim();
    if (lang.isEmpty) return;

    setState(() {
      Globals.languages.add({"lang": lang, "level": _selectedLevel});
      _languageController.clear();
      _selectedLevel = 3;
    });
  }

  void removeLanguage(int index) {
    setState(() {
      Globals.languages.removeAt(index);
    });
  }

  Widget buildDotRating(int rating, Function(int) onTapDot) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onTapDot(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              index < rating ? Icons.circle : Icons.circle_outlined,
              size: 18,
              color: Colors.deepPurple,
            ),
          ),
        );
      }),
    );
  }

  String getLevelLabel(int level) {
    switch (level) {
      case 1:
        return "Beginner";
      case 2:
        return "Elementary";
      case 3:
        return "Intermediate";
      case 4:
        return "Advanced";
      case 5:
        return "Fluent";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Languages"),
        backgroundColor: Globals.bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ➕ Add Language Form
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _languageController,
                    decoration: const InputDecoration(
                      labelText: "Language",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    const Text("Level"),
                    buildDotRating(_selectedLevel, (val) {
                      setState(() => _selectedLevel = val);
                    }),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: addLanguage,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📋 Language List
            Expanded(
              child: Globals.languages.isEmpty
                  ? const Center(child: Text("No languages added yet."))
                  : ListView.builder(
                      itemCount: Globals.languages.length,
                      itemBuilder: (context, index) {
                        final lang = Globals.languages[index];
                        return Card(
                          child: ListTile(
                            title: Text(lang["lang"]),
                            subtitle: Text(
                              getLevelLabel(lang["level"]),
                              style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeLanguage(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
