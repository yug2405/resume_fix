import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/global.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String? maritalStatus;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController cityc = TextEditingController();

  @override
  void initState() {
    super.initState();
    cityc.text = Globals.city;
    maritalStatus = Globals.selectedField;
  }

  @override
  void dispose() {
    cityc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffededed),
      appBar: AppBar(
        backgroundColor: Globals.bgColor,
        toolbarHeight: 120,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Globals.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Personal Details",
            style: TextStyle(color: Globals.textColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Globals.textColor),
            onPressed: () {
              formKey.currentState!.reset();
              Globals.dobc.clear();
              Globals.nationalityc.clear();
              cityc.clear();

              setState(() {
                maritalStatus = null;
                Globals.profileImage = null;
                Globals.english = false;
                Globals.hindi = false;
                Globals.gujarati = false;
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: w * 0.9,
                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Globals.textColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DOB
                        sectionLabel("DOB"),
                        textFormField(
                          controller: Globals.dobc,
                          hint: "DD/MM/YYYY",
                          validatorText: "Enter DOB",
                          onChanged: (val) => Globals.dob = val,
                        ),
                        const SizedBox(height: 16),

                        // City
                        sectionLabel("City"),
                        textFormField(
                          controller: cityc,
                          hint: "City",
                          validatorText: "Enter City",
                          onChanged: (val) => Globals.city = val,
                        ),
                        const SizedBox(height: 16),

                        // Profile Image
                        sectionLabel("Profile Image"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final picked = await Globals.picker
                                .pickImage(source: ImageSource.gallery);
                            if (picked != null) {
                              final bytes = await picked.readAsBytes();
                              setState(() {
                                Globals.profileImage = bytes;
                              });
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Globals.bgColor),
                              image: Globals.profileImage != null
                                  ? DecorationImage(
                                      image: MemoryImage(Globals.profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: Globals.profileImage == null
                                ? Icon(Icons.add_a_photo,
                                    size: 40, color: Globals.bgColor)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Marital Status
                        sectionLabel("Marital Status"),
                        Row(
                          children: [
                            Radio(
                              value: "Single",
                              groupValue: maritalStatus,
                              onChanged: (val) =>
                                  setState(() => maritalStatus = val),
                            ),
                            const Text("Single",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "Married",
                              groupValue: maritalStatus,
                              onChanged: (val) =>
                                  setState(() => maritalStatus = val),
                            ),
                            const Text("Married",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Languages Known
                        sectionLabel("Languages Known"),
                        buildCheckbox("English", Globals.english,
                            (val) => Globals.english = val),
                        buildCheckbox("Hindi", Globals.hindi,
                            (val) => Globals.hindi = val),
                        buildCheckbox("Gujarati", Globals.gujarati,
                            (val) => Globals.gujarati = val),
                        const SizedBox(height: 20),

                        // Nationality
                        sectionLabel("Nationality"),
                        textFormField(
                          controller: Globals.nationalityc,
                          hint: "Indian",
                          validatorText: "Enter Nationality",
                          onChanged: (val) => Globals.nationality = val,
                        ),
                        const SizedBox(height: 30),

                        // SAVE Button
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              Globals.selectedField = maritalStatus ?? '';
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Saved Successfully...")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please Enter Full Detail...")),
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 110,
                              color: Globals.bgColor,
                              child: Text("SAVE",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Globals.textColor)),
                            ),
                          ),
                        ),
                      ],
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

  Widget sectionLabel(String text) => Text(
        text,
        style: TextStyle(fontSize: 23, color: Globals.bgColor),
      );

  Widget textFormField({
    required TextEditingController controller,
    required String hint,
    required String validatorText,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: (val) => val == null || val.isEmpty ? validatorText : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => setState(() => onChanged(val!)),
        ),
        Text(label,
            style: const TextStyle(fontSize: 20, color: Colors.grey)),
      ],
    );
  }
}
