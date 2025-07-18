import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final TextEditingController courseController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController passYearController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveEducation() {
    if (_formKey.currentState!.validate()) {
      Globals.course = courseController.text.trim();
      Globals.school = instituteController.text.trim();
      Globals.result = resultController.text.trim();
      Globals.pass = passYearController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Education Info Saved!")),
      );
    }
  }

  void clearForm() {
    _formKey.currentState!.reset();
    courseController.clear();
    instituteController.clear();
    resultController.clear();
    passYearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Globals.bgColor,
        toolbarHeight: 100,
        centerTitle: true,
        title: const Text(
          "Education",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: clearForm,
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: saveEducation,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              width: w * 0.9,
              decoration: BoxDecoration(
                color: Globals.textColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField(
                      label: "Course/Name",
                      controller: courseController,
                      hint: "e.g. BCA",
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "School/College/Institute",
                      controller: instituteController,
                      hint: "e.g. Swarnim University",
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Result / Grade / Percentage",
                      controller: resultController,
                      hint: "e.g. 8.5 CGPA",
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: "Year of Passing",
                      controller: passYearController,
                      hint: "e.g. 2025",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveEducation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Globals.bgColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        child: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20, color: Globals.bgColor)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'Please enter $label' : null,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
