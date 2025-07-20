import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';

class Buildoption extends StatefulWidget {
  final List<String> flow;

  const Buildoption({super.key, required this.flow});

  @override
  State<Buildoption> createState() => _BuildOptionState();
}

class _BuildOptionState extends State<Buildoption> {
  final Map<String, String> aliasMap = {
    "skills": "technical skills",
    "work experience": "experiences",
    "experience": "experiences",
    "internship": "experiences",
    "internships": "experiences",
    "certification": "achievements",
    "awards": "achievements",
    "summary": "career objective",
    "profile": "career objective",
    "objective": "career objective",
    "moot court": "achievements",
    "languages known": "interest hobbies",
    "languages": "interest hobbies",
    "extracurriculars": "interest hobbies",
    "activities": "interest hobbies",
    "sop evaluator": "sop evaluator",
  };

  String normalize(String s) {
    var val = s.toLowerCase().trim().replaceAll('_', ' ');
    if (val == 'internships') val = 'internship';
    return aliasMap[val] ?? val;
  }

  bool isSectionFilled(String sectionKey) {
    switch (sectionKey) {
      case 'contact_info':
      case 'contact info':
        return Globals.name.isNotEmpty &&
            Globals.email.isNotEmpty &&
            Globals.number.length == 10;
      case 'career objective':
      case 'carrier_objective':
      case 'summary':
      case 'objective':
      case 'profile':
        return Globals.careerObjective.isNotEmpty;
      case 'education':
      case 'professional development':
        return Globals.course.isNotEmpty && Globals.school.isNotEmpty;
      case 'projects':
      case 'portfolio':
      case 'research projects':
      case 'publications':
      case 'relevant coursework':
        return Globals.projects.isNotEmpty;
      case 'technical skills':
      case 'technical_skills':
      case 'skills':
      case 'business skills':
        return Globals.skills.isNotEmpty && Globals.skillsSectionVisited;
      case 'experiences':
      case 'experience':
      case 'internship':
      case 'internships':
      case 'work experience':
      case 'clinical experience':
      case 'customer service experience':
      case 'field/lab experience':
      case 'volunteering':
      case 'research experience':
      case 'teaching experience':
        return Globals.experiences.isNotEmpty;
      case 'achievements':
      case 'awards':
      case 'certifications':
      case 'awards/honors':
      case 'moot court':
        return Globals.achievements.isNotEmpty ||
            Globals.certifications.isNotEmpty;
      case 'interest hobbies':
      case 'interest_hobbies':
      case 'languages known':
      case 'languages':
      case 'extracurriculars':
      case 'activities':
        return Globals.hobbies.isNotEmpty || Globals.languages.isNotEmpty;
      case 'references':
        return Globals.r_name.isNotEmpty &&
            Globals.designation.isNotEmpty &&
            Globals.institute.isNotEmpty;
      case 'profile_picture':
        return Globals.profileImage != null;
      case 'declaration':
        return Globals.declaration.isNotEmpty &&
            Globals.place.isNotEmpty &&
            Globals.date.isNotEmpty;
      case 'sop evaluator':
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final recommendedSet = widget.flow.map(normalize).toSet();
    final seen = <String>{};
    final filteredDetails = Globals.alldetails.where((section) {
      final name = normalize(section['name'] ?? "");
      if (!recommendedSet.contains(name)) return false;
      if (seen.contains(name)) return false;
      seen.add(name);
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                      const Text(
                        "BUILDER OPTIONS",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: width / 20),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 140),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 8,
                        offset: Offset(3, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: filteredDetails.map((section) {
                              final route = section['names'];
                              final name = normalize(section['name'] ?? "");
                              final filled = isSectionFilled(name);

                              return Stack(
                                alignment: const Alignment(-0.9, -1),
                                children: [
                                  Container(
                                    height: height / 12,
                                    width: width / 1.2,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.grey.shade100.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: width / 4),
                                        Expanded(
                                          child: Text(
                                            section['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () async {
                                            if (route != null &&
                                                route.toString().isNotEmpty) {
                                              await Navigator.of(context)
                                                  .pushNamed(route);
                                              setState(() {});
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              filled
                                                  ? Icons.check_circle
                                                  : Icons.edit,
                                              color: filled
                                                  ? Colors.green
                                                  : Colors.grey,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 12,
                                    width: width / 6,
                                    child: Image.asset(section['icon']),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamed('resume_preview'),
              icon: const Icon(Icons.remove_red_eye_outlined),
              label: const Text("Preview My Resume"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('pdf_screen'),
              icon: const Icon(Icons.download),
              label: const Text("Download Resume PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
