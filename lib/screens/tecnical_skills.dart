import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class TechnicalScreen extends StatefulWidget {
  const TechnicalScreen({super.key});

  @override
  State<TechnicalScreen> createState() => _TechnicalScreenState();
}

class _TechnicalScreenState extends State<TechnicalScreen> {
  List<TextEditingController> allControllers = [];

  List<String> get fieldKeywords {
    final guide = Globals.fieldResumeGuide[Globals.selectedField] ?? {};
    return List<String>.from(guide['keywords'] ?? []);
  }

  @override
void initState() {
  super.initState();
  Globals.skillsSectionVisited = true; // 👈 Add this line
  if (Globals.skills.isEmpty) {
    addTextField();
    addTextField();
  } else {
    for (var s in Globals.skills) {
      addTextField(initialText: s);
    }
  }
}

  @override
  void dispose() {
    for (var controller in allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addTextField({String initialText = ""}) {
    final controller = TextEditingController(text: initialText);
    setState(() {
      allControllers.add(controller);
    });
  }

  void removeTextField(int index) {
    setState(() {
      allControllers[index].dispose();
      allControllers.removeAt(index);
    });
  }

  void insertKeyword(String keyword) {
    bool alreadyAdded = allControllers.any(
      (c) => c.text.trim().toLowerCase() == keyword.toLowerCase(),
    );
    if (!alreadyAdded) {
      addTextField(initialText: keyword);
    }
  }

  void saveSkills() {
    List<String> skills = allControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();

    if (skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one skill")),
      );
      return;
    }

    Globals.skills = skills;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Skills saved!")),
    );
  }

  Widget buildSkillField(int index) {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: TextField(
            controller: allControllers[index],
            decoration: const InputDecoration(
              hintText: "e.g. Flutter, SQL, Networking",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
        IconButton(
          onPressed: () => removeTextField(index),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Globals.bgColor,
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Globals.textColor),
        ),
        title: Text(
          "Technical Skills",
          style: TextStyle(
            fontSize: 22,
            color: Globals.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.grey.withOpacity(0.3),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Globals.textColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter Your Skills",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      if (fieldKeywords.isNotEmpty) ...[
                        Text(
                          "💡 Suggested Skills",
                          style: TextStyle(
                            color: Globals.bgColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: fieldKeywords.map((kw) {
                            return ActionChip(
                              label: Text(kw),
                              backgroundColor: Colors.blue.shade50,
                              onPressed: () => insertKeyword(kw),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      ...List.generate(allControllers.length, (index) => buildSkillField(index)),
                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () => addTextField(),
                        icon: const Icon(Icons.add),
                        label: const Text("Add More Skill"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Globals.bgColor,
                          foregroundColor: Globals.textColor,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          onPressed: saveSkills,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Globals.bgColor,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          ),
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                              fontSize: 18,
                              color: Globals.textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
