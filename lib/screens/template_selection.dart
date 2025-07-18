import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:resume_fix/screens/screen_navigator.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  final List<String> templates = ['Simple', 'Professional', 'Modern', 'Creative'];
  late String recommendedTemplate;

  @override
  void initState() {
    super.initState();
    recommendedTemplate =
        Globals.fieldResumeGuide[Globals.selectedField]?["template"] ?? "Modern";
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Globals.bgColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a Resume Template"),
        backgroundColor: bgColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: templates.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final template = templates[index];
          final isSelected = Globals.selectedTemplate == template;
          final isRecommended = template == recommendedTemplate;

          return GestureDetector(
            onTap: () {
              setState(() {
                Globals.selectedTemplate = template;
                Globals.resumeFlow = [
  "Profile Picture",
  ...?Globals.fieldResumeGuide[Globals.selectedField]?['sections'],
];

              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$template template selected")),
              );

              Future.delayed(const Duration(milliseconds: 300), () {
                navigateToNextResumeScreen(context, 0); // Navigate to first section
              });
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isSelected ? Colors.blueGrey.shade100 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, size: 32, color: bgColor),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: bgColor,
                            ),
                          ),
                          if (isRecommended)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "Recommended",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
