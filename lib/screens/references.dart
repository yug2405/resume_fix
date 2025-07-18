import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill saved values
    nameController.text = Globals.reference['name'] ?? '';
    designationController.text = Globals.reference['designation'] ?? '';
    organizationController.text = Globals.reference['organization'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    organizationController.dispose();
    super.dispose();
  }

  void saveReference() {
    final name = nameController.text.trim();
    final designation = designationController.text.trim();
    final org = organizationController.text.trim();

    if (name.isNotEmpty && designation.isNotEmpty && org.isNotEmpty) {
      Globals.reference = {
        "name": name,
        "designation": designation,
        "organization": org,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all reference details.")),
      );
    }
  }

  Widget buildField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 23, color: Globals.bgColor)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Globals.bgColor,
        title: Text(
          "References",
          style: TextStyle(
            color: Globals.textColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.4),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(15),
              width: w * 0.9,
              decoration: BoxDecoration(
                color: Globals.textColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildField("Reference Name", "e.g. Suresh Shah", nameController),
                  buildField("Designation", "e.g. Marketing Manager, ID-342323", designationController),
                  buildField("Organization/Institute", "e.g. Green Energy Pvt. Ltd.", organizationController),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: saveReference,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Globals.bgColor,
                      ),
                      child: Text("SAVE",
                          style: TextStyle(
                              color: Globals.textColor, fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
