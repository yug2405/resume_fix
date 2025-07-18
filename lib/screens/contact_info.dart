import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resume_fix/utils/global.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Globals.namec.text = Globals.name;
    Globals.emailc.text = Globals.email;
    Globals.numberc.text = Globals.number;
    Globals.githubc.text = Globals.github;
    Globals.linkedinc.text = Globals.linkedin;
    Globals.portfolioc.text = Globals.portfolio;
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        Globals.profileImage = bytes;
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        Globals.profileImage = bytes;
      });
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isOptional = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.number : TextInputType.text,
        validator: (val) {
          if (isOptional) return null;
          if (val == null || val.trim().isEmpty) return "Required";

          if (isPhone) {
            final trimmed = val.trim();
            if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
              return "Phone number must be exactly 10 digits";
            }
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void saveContactInfo() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        Globals.name = Globals.namec.text.trim();
        Globals.email = Globals.emailc.text.trim();
        Globals.number = Globals.numberc.text.trim();
        Globals.github = Globals.githubc.text.trim();
        Globals.linkedin = Globals.linkedinc.text.trim();
        Globals.portfolio = Globals.portfolioc.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact Info Saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = Globals.selectedTemplate.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Info"),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Profile Image (for selected templates)
              if (template == 'professional' || template == 'creative')
                Center(
                  child: Column(
                    children: [
                      if (Globals.profileImage != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(Globals.profileImage!),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: pickImageFromCamera,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Capture"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: pickImageFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Upload"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

              buildTextField("Full Name", Globals.namec),
              buildTextField("Email", Globals.emailc),
              buildTextField("Phone Number", Globals.numberc, isPhone: true),

              const Divider(height: 40),
              const Text("Online Profiles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              buildTextField("GitHub", Globals.githubc),
              buildTextField("LinkedIn", Globals.linkedinc),
              buildTextField("Portfolio", Globals.portfolioc, isOptional: true),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: saveContactInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals.bgColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("SAVE", style: TextStyle(color: Globals.textColor, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
