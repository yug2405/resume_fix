import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class ModernTemplate extends StatelessWidget {
  final Set<String> sections;
  const ModernTemplate({super.key, required this.sections});

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.blueGrey.shade800,
          ),
        ),
      );

  Widget bulletItem(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("• ", style: TextStyle(fontSize: 14)),
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14))),
          ],
        ),
      );

  Widget clickableText(String label, String value, String scheme) {
    if (value.isEmpty) return const SizedBox();
    final Uri uri = Uri.parse('$scheme${value.trim()}');
    return RichText(
      text: TextSpan(
        text: '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
      ),
    );
  }

  Widget labeledLink(String label, String rawUrl) {
    String url = rawUrl.trim();
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);
    final String displayText = url
        .replaceFirst(RegExp(r'^https?:\/\/(www\.)?'), '')
        .replaceAll(RegExp(r'\/$'), '');

    return RichText(
      text: TextSpan(
        text: "$label: $displayText",
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } catch (e) {
              debugPrint("Failed to launch $url: $e");
            }
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              Globals.name,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sections.contains("contact info")) ...[
                      Center(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            if (Globals.email.isNotEmpty)
                              clickableText("Email", Globals.email, "mailto:"),
                            if (Globals.email.isNotEmpty && Globals.number.isNotEmpty)
                              Text("|", style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueGrey)),
                            if (Globals.number.isNotEmpty)
                              clickableText("Phone", Globals.number, "tel:"),
                            if (Globals.github.isNotEmpty)
                              labeledLink("GitHub", Globals.github),
                            if (Globals.linkedin.isNotEmpty)
                              labeledLink("LinkedIn", Globals.linkedin),
                            if (Globals.portfolio.isNotEmpty)
                              labeledLink("Portfolio", Globals.portfolio),
                          ],
                        ),
                      ),
                    ],

                    if (sections.contains("education") &&
                        (Globals.course.isNotEmpty || Globals.school.isNotEmpty)) ...[
                      sectionTitle("🎓 Education"),
                      if (Globals.course.isNotEmpty && Globals.school.isNotEmpty)
                        bulletItem("${Globals.course} at ${Globals.school}"),
                      if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
                        bulletItem("Result: ${Globals.result}, Year: ${Globals.pass}"),
                    ],

                    if ((sections.contains("projects") ||
                            sections.contains("research projects") ||
                            sections.contains("relevant coursework") || sections.contains("publications")) &&
                        Globals.projects.isNotEmpty) ...[
                      sectionTitle("📁 Projects"),
                      ...Globals.projects.asMap().entries.map((entry) {
                        final i = entry.key;
                        final p = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bulletItem("${i + 1}. ${p['name'] ?? ''}"),
                            if ((p['desc'] ?? '').isNotEmpty) bulletItem("📝 ${p['desc']}"),
                            if ((p['role'] ?? '').isNotEmpty) bulletItem("👨‍💻 Role: ${p['role']}"),
                            if ((p['tech'] ?? '').isNotEmpty) bulletItem("🛠️ Tech: ${p['tech']}"),
                            const SizedBox(height: 6),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((sections.contains("summary") ||
                            sections.contains("career objective") ||
                            sections.contains("professional development")) &&
                        (Globals.careerObjective.isNotEmpty || Globals.currentdes.isNotEmpty)) ...[
                      sectionTitle("📝 Summary"),
                      if (Globals.currentdes.isNotEmpty)
                        Text(
                          "Designation: ${Globals.currentdes}",
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      if (Globals.careerObjective.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            Globals.careerObjective,
                            style: GoogleFonts.poppins(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                    ],

                    if ((sections.contains("technical skills") || sections.contains("skills")) &&
                        Globals.skills.isNotEmpty) ...[
                      sectionTitle("💡 Skills"),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: Globals.skills
                            .map((s) => Chip(
                                  label: Text(s, style: GoogleFonts.poppins(fontSize: 13)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  backgroundColor: Colors.blueGrey.shade100,
                                ))
                            .toList(),
                      ),
                    ],

                    if ((sections.contains("internships") ||
                            sections.contains("experiences") ||
                            sections.contains("work experience") || sections.contains("volunteering")) &&
                        Globals.experiences.isNotEmpty) ...[
                      sectionTitle("💼 Experience"),
                      ...Globals.experiences.asMap().entries.map((entry) {
                        final i = entry.key;
                        final exp = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bulletItem("${i + 1}. ${exp['role']} at ${exp['company']}"),
                            if ((exp['duration'] ?? '').isNotEmpty)
                              Text("📆 Duration: ${exp['duration']}",
                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700)),
                            const SizedBox(height: 4),
                          ],
                        );
                      }),
                    ],

                    if ((sections.contains("achievements") ||
                            sections.contains("awards") ||
                            sections.contains("moot court") ||
                            sections.contains("certifications")) &&
                        (Globals.achievements.isNotEmpty || Globals.certifications.isNotEmpty)) ...[
                      sectionTitle("🏅 Achievements & Certifications"),
                      ...Globals.achievements.map((a) => bulletItem(a)),
                      if (Globals.certifications.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text("📜 Certifications",
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        ...Globals.certifications.map((c) => bulletItem(c)),
                      ],
                    ],

                    if (sections.contains("languages") && Globals.languages.isNotEmpty) ...[
                      sectionTitle("🌐 Languages"),
                      ...Globals.languages.map((lang) {
                        final String name = lang['lang'] ?? '';
                        final int level = lang['level'] ?? 3;

                        String getLabel(int lvl) {
                          switch (lvl) {
                            case 1:
                              return "Beginner";
                            case 2:
                              return "Elementary";
                            case 3:
                              return "Intermediate";
                            case 4:
                              return "Advanced";
                            case 5:
                              return "Fluent";
                            default:
                              return "Unknown";
                          }
                        }

                        return bulletItem("$name (${getLabel(level)})");
                      }),
                    ],

                    if (sections.contains("references") &&
                        (Globals.r_name.isNotEmpty ||
                            Globals.designation.isNotEmpty ||
                            Globals.institute.isNotEmpty)) ...[
                      sectionTitle("📚 References"),
                      if (Globals.r_name.isNotEmpty) bulletItem("Name: ${Globals.r_name}"),
                      if (Globals.designation.isNotEmpty) bulletItem("Designation: ${Globals.designation}"),
                      if (Globals.institute.isNotEmpty) bulletItem("Institute: ${Globals.institute}"),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
