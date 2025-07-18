import 'package:flutter/material.dart';
import '../utils/global.dart';

class CareerObjectiveScreen extends StatefulWidget {
  const CareerObjectiveScreen({super.key});

  @override
  State<CareerObjectiveScreen> createState() => _CareerObjectiveScreenState();
}

class _CareerObjectiveScreenState extends State<CareerObjectiveScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> get keywordSuggestions {
    final guide = Globals.fieldResumeGuide[Globals.selectedField] ?? {};
    return List<String>.from(guide['keywords'] ?? []);
  }

  void insertKeyword(String word) {
    if (!Globals.careerc.text.contains(word)) {
      Globals.careerc.text += " $word";
      setState(() {});
    }
  }

  void saveObjective() {
    if (formKey.currentState!.validate()) {
      Globals.careerObjective = Globals.careerc.text.trim();
      Globals.currentdes = Globals.currentdesc.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Career Objective saved")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  void clearForm() {
    Globals.careerc.clear();
    Globals.currentdesc.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Globals.careerc.text = Globals.careerObjective;
    Globals.currentdesc.text = Globals.currentdes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      appBar: AppBar(
        backgroundColor: Globals.bgColor,
        title: Text("Summary", style: TextStyle(color: Globals.textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Globals.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Globals.textColor),
            onPressed: clearForm,
          ),
          IconButton(
            icon: Icon(Icons.check, color: Globals.textColor),
            onPressed: saveObjective,
          ),
        ],
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔶 Designation Field
                const Text(
                  "Your Current Designation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: Globals.currentdesc,
                  validator: (val) => val!.isEmpty ? "Enter your designation" : null,
                  decoration: const InputDecoration(
                    hintText: "e.g. Flutter Developer, Data Analyst",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔷 Career Objective Field
                const Text(
                  "Career Objective / Summary",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: Globals.careerc,
                  validator: (val) => val!.isEmpty ? "Enter career objective" : null,
                  maxLines: null,
                  minLines: 5,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: "Write your professional goal or motivation...",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 20),

                // 💡 Suggested Keywords
                if (keywordSuggestions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "💡 Suggested Keywords:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: keywordSuggestions.map((word) {
                          return ActionChip(
                            label: Text(word),
                            backgroundColor: Colors.blue.shade50,
                            onPressed: () => insertKeyword(word),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
