import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:resume_fix/screens/build_option.dart';

class FieldSuggestionScreen extends StatefulWidget {
  const FieldSuggestionScreen({super.key});

  @override
  State<FieldSuggestionScreen> createState() => _FieldSuggestionScreenState();
}

class _FieldSuggestionScreenState extends State<FieldSuggestionScreen> {
  late String selectedDomain;
  late String selectedTemplate;

  final List<String> templateOptions = [
    "Modern",
    "Professional",
    "Simple",
    "Creative",
  ];

  @override
  void initState() {
    super.initState();
    selectedDomain = Globals.selectedField.isNotEmpty
        ? Globals.selectedField
        : Globals.fieldResumeGuide.keys.first;

    final guide = Globals.fieldResumeGuide[selectedDomain] ?? {};
    selectedTemplate = guide["template"] ?? "Modern";

    // 🧠 Set globals
    Globals.selectedField = selectedDomain;
    Globals.selectedTemplate = selectedTemplate;
    Globals.resumeFlow = List<String>.from(guide['sections'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final guide = Globals.fieldResumeGuide[selectedDomain] ?? {};
    final List<String> sections = List<String>.from(guide["sections"] ?? []);
    final List<String> keywords = List<String>.from(guide["keywords"] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Suggestions for $selectedDomain"),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔘 Domain Selection
            // 🔘 Domain Selection - Only show if not pre-selected
if (Globals.selectedField.isEmpty) ...[
  sectionTitle("🎯 Select Your Domain"),
  DropdownButtonFormField<String>(
    value: selectedDomain,
    decoration: const InputDecoration(border: OutlineInputBorder()),
    items: Globals.fieldResumeGuide.keys.map((domain) {
      return DropdownMenuItem(value: domain, child: Text(domain));
    }).toList(),
    onChanged: (value) {
      if (value != null && value != selectedDomain) {
        setState(() {
          selectedDomain = value;
          final guide = Globals.fieldResumeGuide[value] ?? {};
          selectedTemplate = guide["template"] ?? "Modern";
          Globals.selectedField = value;
          Globals.selectedTemplate = selectedTemplate;
          Globals.resumeFlow = List<String>.from(
            guide['sections'] ?? [],
          );
        });
      }
    },
  ),
] else ...[
  sectionTitle("🎯 Selected Domain"),
  Text(
    Globals.selectedField,
    style: const TextStyle(fontSize: 16),
  ),
],

            const SizedBox(height: 24),

            // ✅ Recommended Sections
            sectionTitle("📋 Recommended Sections"),
            ...sections.map(
              (s) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                title: Text(s),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Keywords
            sectionTitle("🔑 Keywords to Use"),
            keywords.isNotEmpty
                ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: keywords
                        .map(
                          (word) => Chip(
                            label: Text(word),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        )
                        .toList(),
                  )
                : const Text("No keywords available."),

            const SizedBox(height: 24),

            // ✅ Template Choice
            sectionTitle("🎨 Select Template"),
            Wrap(
              spacing: 10,
              children: templateOptions.map((template) {
                return ChoiceChip(
                  label: Text(template),
                  selected: selectedTemplate == template,
                  selectedColor: Globals.bgColor.withOpacity(0.2),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        selectedTemplate = template;
                        Globals.selectedTemplate = template;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // 🚀 CTA Button
            ElevatedButton.icon(
              onPressed: () {
                Globals.resumeFlow = List<String>.from(
                  Globals.fieldResumeGuide[selectedDomain]?['sections'] ?? [],
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Buildoption(flow: Globals.resumeFlow),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Start Building Resume"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Globals.bgColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
