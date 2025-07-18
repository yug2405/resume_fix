import 'package:flutter/material.dart';
import '../utils/global.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  List<Map<String, TextEditingController>> projectControllers = [];

  List<String> get fieldKeywords {
    final guide = Globals.fieldResumeGuide[Globals.selectedField] ?? {};
    return List<String>.from(guide['keywords'] ?? []);
  }

  @override
  void initState() {
    super.initState();
    if (Globals.projects.isNotEmpty) {
      for (var proj in Globals.projects) {
        projectControllers.add({
          'name': TextEditingController(text: proj['name'] ?? ''),
          'tech': TextEditingController(text: proj['tech'] ?? ''),
          'role': TextEditingController(text: proj['role'] ?? ''),
          'desc': TextEditingController(text: proj['desc'] ?? ''),
        });
      }
    } else {
      addProject();
    }
  }

  @override
  void dispose() {
    for (var pc in projectControllers) {
      for (var controller in pc.values) {
        controller.dispose();
      }
    }
    scrollController.dispose();
    super.dispose();
  }

  void addProject() {
    setState(() {
      projectControllers.add({
        'name': TextEditingController(),
        'tech': TextEditingController(),
        'role': TextEditingController(),
        'desc': TextEditingController(),
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  void removeProject(int index) {
    if (projectControllers.length <= 1) return;
    setState(() {
      projectControllers[index]
          .values
          .forEach((controller) => controller.dispose());
      projectControllers.removeAt(index);
    });
  }

  void insertKeyword(int index, String keyword) {
    final techCtrl = projectControllers[index]['tech']!;
    if (!techCtrl.text.contains(keyword)) {
      techCtrl.text = (techCtrl.text + " $keyword").trim();
      techCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: techCtrl.text.length),
      );
    }
  }

  void saveProjects() {
    if (formKey.currentState!.validate()) {
      Globals.projects = projectControllers
          .map((pc) => {
                "name": pc['name']!.text.trim(),
                "tech": pc['tech']!.text.trim(),
                "role": pc['role']!.text.trim(),
                "desc": pc['desc']!.text.trim(),
              })
          .where((proj) =>
              proj["name"]!.isNotEmpty ||
              proj["tech"]!.isNotEmpty ||
              proj["role"]!.isNotEmpty ||
              proj["desc"]!.isNotEmpty)
          .toList();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Projects saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all project fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffededed),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Globals.bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Globals.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Projects",
          style: TextStyle(fontSize: 22, color: Globals.textColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Globals.textColor),
            onPressed: () {
              setState(() {
                for (var pc in projectControllers) {
                  for (var ctrl in pc.values) {
                    ctrl.clear();
                  }
                }
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: projectControllers.length + 1,
            itemBuilder: (context, index) {
              if (index == projectControllers.length) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Globals.bgColor,
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add Project",
                          style: TextStyle(color: Colors.white)),
                      onPressed: addProject,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveProjects,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Globals.bgColor,
                      ),
                      child: Text("SAVE",
                          style: TextStyle(
                              fontSize: 20, color: Globals.textColor)),
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              }

              final controllers = projectControllers[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 4,
                color: Globals.textColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Project ${index + 1}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Globals.bgColor)),
                          const Spacer(),
                          if (projectControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeProject(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildField("Project Name", "e.g. Resume Builder",
                          controllers['name']!),
                      _buildField("Technologies Used",
                          "e.g. Flutter, Firebase", controllers['tech']!),
                      if (fieldKeywords.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text("💡 Suggested Technologies:",
                            style: TextStyle(
                                color: Globals.bgColor,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: fieldKeywords.map((kw) {
                            return ActionChip(
                              label: Text(kw),
                              backgroundColor: Colors.blue.shade50,
                              onPressed: () => insertKeyword(index, kw),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 10),
                      _buildField("Your Role", "e.g. Frontend Developer",
                          controllers['role']!),
                      _buildField("Description", "Explain the project briefly",
                          controllers['desc']!,
                          maxLines: 3),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: Globals.bgColor, fontSize: 18)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: (val) =>
                val!.trim().isEmpty ? "Required field" : null,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
