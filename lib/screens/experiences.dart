import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> {
  final List<TextEditingController> roleControllers = [];
  final List<TextEditingController> companyControllers = [];
  final List<TextEditingController> durationControllers = [];
  final ScrollController scrollController = ScrollController();

  List<String> get fieldRoleSuggestions {
    final guide = Globals.fieldResumeGuide[Globals.selectedField] ?? {};
    return List<String>.from(guide['roles'] ?? []);
  }

  @override
  void initState() {
    super.initState();
    addExperience(); // default single entry
  }

  void addExperience() {
    setState(() {
      roleControllers.add(TextEditingController());
      companyControllers.add(TextEditingController());
      durationControllers.add(TextEditingController());
    });

    // Smooth scroll after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 150,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void removeExperience(int index) {
    setState(() {
      roleControllers[index].dispose();
      companyControllers[index].dispose();
      durationControllers[index].dispose();

      roleControllers.removeAt(index);
      companyControllers.removeAt(index);
      durationControllers.removeAt(index);
    });
  }

  void insertRole(int index, String role) {
    final controller = roleControllers[index];
    controller.text = role;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: role.length),
    );
    setState(() {});
  }

  void saveExperiences() {
    final List<Map<String, String>> experiences = [];

    for (int i = 0; i < roleControllers.length; i++) {
      final role = roleControllers[i].text.trim();
      final company = companyControllers[i].text.trim();
      final duration = durationControllers[i].text.trim();

      if (role.isNotEmpty && company.isNotEmpty && duration.isNotEmpty) {
        experiences.add({
          "role": role,
          "company": company,
          "duration": duration,
        });
      }
    }

    if (experiences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill at least one complete experience")),
      );
      return;
    }

    Globals.experiences = experiences;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Experiences saved!")),
    );
  }

  @override
  void dispose() {
    for (final c in roleControllers) c.dispose();
    for (final c in companyControllers) c.dispose();
    for (final c in durationControllers) c.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Globals.bgColor,
        title: Text("Internships", style: TextStyle(color: Globals.textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Globals.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.grey.withOpacity(0.3),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: roleControllers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: roleControllers[index],
                              decoration: const InputDecoration(
                                labelText: "Role",
                                hintText: "e.g. Frontend Developer",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (fieldRoleSuggestions.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: fieldRoleSuggestions.map((role) {
                                  return ActionChip(
                                    label: Text(role, style: const TextStyle(fontSize: 13)),
                                    backgroundColor: Colors.blue.shade50,
                                    onPressed: () => insertRole(index, role),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: companyControllers[index],
                              decoration: const InputDecoration(
                                labelText: "Company",
                                hintText: "e.g. Cognifyz Technologies",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: durationControllers[index],
                              decoration: const InputDecoration(
                                labelText: "Duration",
                                hintText: "e.g. Jan 2024 - Mar 2024",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeExperience(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: addExperience,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Experience"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveExperiences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Globals.bgColor,
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        color: Globals.textColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
