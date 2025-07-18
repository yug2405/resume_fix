import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:resume_fix/utils/routes/routes.dart';

class FieldSelectionScreen extends StatefulWidget {
  const FieldSelectionScreen({super.key});

  @override
  State<FieldSelectionScreen> createState() => _FieldSelectionScreenState();
}

class _FieldSelectionScreenState extends State<FieldSelectionScreen> {
  String? selectedField;

  void handleFieldSelection(String? value) {
    if (value != null) {
      setState(() {
        selectedField = value;
        Globals.selectedField = value;

        final guide = Globals.fieldResumeGuide[value] ?? {};
        Globals.selectedTemplate = guide["template"] ?? "Simple";
        Globals.skills = List<String>.from(guide["keywords"] ?? []);
        Globals.resumeFlow = List<String>.from(guide["sections"] ?? []);

        debugPrint("✅ Field Selected: $selectedField");
        debugPrint("📄 Template: ${Globals.selectedTemplate}");
        debugPrint("🧠 Keywords: ${Globals.skills}");
        debugPrint("📋 Resume Flow: ${Globals.resumeFlow}");
      });
    }
  }

  void navigateNext() {
    if (selectedField == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a field")),
      );
    } else {
      Navigator.pushNamed(context, Routes.fieldSuggestionPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Field"),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedField,
              decoration: const InputDecoration(
                labelText: "Choose your field",
                border: OutlineInputBorder(),
              ),
              items: Globals.fieldResumeGuide.keys.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(field),
                );
              }).toList(),
              onChanged: handleFieldSelection,
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Globals.bgColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: navigateNext,
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
