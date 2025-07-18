import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:resume_fix/utils/routes/routes.dart';
import 'package:resume_fix/screens/simple_template.dart';
import 'package:resume_fix/screens/professional_template.dart';
import 'package:resume_fix/screens/creative_template.dart';
import 'package:resume_fix/screens/modern_template.dart';

/// 🔁 Section Mapping Function (Business Skills => skills, Experience => experiences, etc.)
Set<String> getMappedSections() {
  final originalSections = (Globals.fieldResumeGuide[Globals.selectedField]?['sections'] as List?)
          ?.map((e) => e.toString().toLowerCase().trim())
          .toSet() ?? {};

  final Set<String> mappedSections = {};

  for (var section in originalSections) {
    if (section.contains("skill")) mappedSections.add("skills");
    else if (section.contains("experience")) mappedSections.add("experiences");
    else if (section.contains("education")) mappedSections.add("education");
    else if (section.contains("summary") || section.contains("profile")) mappedSections.add("summary");
    else if (section.contains("project")) mappedSections.add("projects");
    else if (section.contains("achievement") || section.contains("award") || section.contains("certification")) {
      mappedSections.add("achievements");
    } else if (section.contains("reference")) mappedSections.add("references");
    else if (section.contains("hobby") || section.contains("interest")) mappedSections.add("interest/hobbies");
    else if (section.contains("language")) mappedSections.add("languages");
    else if (section.contains("declaration")) mappedSections.add("declaration");
    else mappedSections.add(section); // Keep original if no match
  }

  return mappedSections;
}

/// 🔁 Returns the selected template widget with mapped sections
Widget getTemplateWidget() {
  final sections = getMappedSections();

  switch (Globals.selectedTemplate) {
    case "Simple":
      return SimpleTemplate(sections: sections);
    case "Professional":
      return ProfessionalTemplate(sections: sections);
    case "Creative":
      return CreativeTemplate(sections: sections);
    case "Modern":
    default:
      return ModernTemplate(sections: sections);
  }
}

class ResumePreviewScreen extends StatelessWidget {
  const ResumePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String template = Globals.selectedTemplate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Preview"),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => Navigator.pushNamed(context, Routes.pdfScreenPage),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Template Info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Selected Template",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(template),
                    backgroundColor: Colors.blue.shade100,
                    labelStyle: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Resume UI Preview
            getTemplateWidget(),

            const SizedBox(height: 30),

            /// PDF Generation Button
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.pdfScreenPage),
              style: ElevatedButton.styleFrom(
                backgroundColor: Globals.bgColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                "Proceed to PDF",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
