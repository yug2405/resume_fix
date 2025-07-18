import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class AchievementsScreen extends StatefulWidget {
  final String title;
  const AchievementsScreen({super.key, this.title = "Achievements"});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<TextEditingController> _controllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final isCert = widget.title == "Certifications";
    final existingData = isCert ? Globals.certifications : Globals.achievements;

    if (existingData.isEmpty) {
      _controllers.add(TextEditingController());
    } else {
      for (var text in existingData) {
        _controllers.add(TextEditingController(text: text));
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void addAchievement() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void removeAchievement(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  void saveAchievements() {
    if (_formKey.currentState!.validate()) {
      final data = _controllers.map((c) => c.text.trim()).toList();
      if (widget.title == "Certifications") {
        Globals.certifications = data;
      } else {
        Globals.achievements = data;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.title} saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all ${widget.title.toLowerCase()} fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Globals.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Globals.textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(_controllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controllers[index],
                            validator: (val) => val == null || val.trim().isEmpty
                                ? "Enter ${widget.title} ${index + 1}"
                                : null,
                            decoration: InputDecoration(
                              labelText: "${widget.title} ${index + 1}",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (_controllers.length > 1)
                          IconButton(
                            onPressed: () => removeAchievement(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                      ],
                    ),
                  );
                }),

                ElevatedButton.icon(
                  onPressed: addAchievement,
                  icon: const Icon(Icons.add),
                  label: const Text("Add More"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals.bgColor,
                    foregroundColor: Globals.textColor,
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: saveAchievements,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals.bgColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: Text(
                    "SAVE",
                    style: TextStyle(fontSize: 18, color: Globals.textColor),
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
