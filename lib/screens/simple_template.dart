import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class SimpleTemplate extends StatelessWidget {
  final Set<String> sections;
  const SimpleTemplate({super.key, required this.sections});

  Widget bullet(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("• ", style: TextStyle(fontSize: 14)),
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14))),
          ],
        ),
      );

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.blueGrey.shade800,
          ),
        ),
      );

  String shortenUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return url;
    return uri.host.replaceFirst('www.', '') + uri.path;
  }

  Widget labeledLink(String label, String rawUrl) {
    String url = rawUrl.trim();
    if (!url.startsWith("http") && !url.startsWith("mailto:")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);
    final String displayText = shortenUrl(uri.toString());

    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          ),
          TextSpan(
            text: displayText,
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
        ],
      ),
    );
  }

  String getLevelLabel(int level) {
    switch (level) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Globals.name,
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          if (sections.contains("contact info")) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (Globals.email.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: "Email: ${Globals.email}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri uri = Uri.parse("mailto:${Globals.email}");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                    ),
                  ),
                if (Globals.number.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: "Phone: ${Globals.number}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri uri = Uri.parse("tel:${Globals.number}");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                    ),
                  ),
                if (Globals.github.isNotEmpty) labeledLink("GitHub", Globals.github),
                if (Globals.linkedin.isNotEmpty) labeledLink("LinkedIn", Globals.linkedin),
                if (Globals.portfolio.isNotEmpty) labeledLink("Portfolio", Globals.portfolio),
              ],
            ),
          ],

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

          if (sections.contains("education") &&
              (Globals.course.isNotEmpty || Globals.school.isNotEmpty)) ...[
            sectionTitle("🎓 Education"),
            bullet("${Globals.course} at ${Globals.school}"),
            if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
              bullet("Result: ${Globals.result}, Year: ${Globals.pass}"),
          ],

          if ((sections.contains("technical skills") || sections.contains("skills")) &&
              Globals.skills.isNotEmpty) ...[
            sectionTitle("💡 Skills"),
            ...Globals.skills.map((s) => bullet(s)),
          ],

          if ((sections.contains("projects") ||
                  sections.contains("research projects") ||
                  sections.contains("relevant coursework")) &&
              Globals.projects.isNotEmpty) ...[
            sectionTitle("📁 Projects"),
            ...Globals.projects.asMap().entries.map((entry) {
              int i = entry.key;
              final p = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((p['name'] ?? '').isNotEmpty)
                    Text("${i + 1}. ${p['name']}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                  if ((p['desc'] ?? '').isNotEmpty) bullet("📝 ${p['desc']}"),
                  if ((p['role'] ?? '').isNotEmpty) bullet("👨‍💻 Role: ${p['role']}"),
                  if ((p['tech'] ?? '').isNotEmpty) bullet("🛠️ Tech: ${p['tech']}"),
                  const SizedBox(height: 6),
                ],
              );
            }),
          ],

          if ((sections.contains("internships") ||
                  sections.contains("work experience") ||
                  sections.contains("experiences")) &&
              Globals.experiences.isNotEmpty) ...[
            sectionTitle("🧑‍💼 Experience"),
            ...Globals.experiences.asMap().entries.map((entry) {
              int i = entry.key;
              final exp = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((exp['role'] ?? '').isNotEmpty && (exp['company'] ?? '').isNotEmpty)
                    Text("${i + 1}. ${exp['role']} at ${exp['company']}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                  if ((exp['duration'] ?? '').isNotEmpty)
                    bullet("📆 Duration: ${exp['duration']}"),
                  const SizedBox(height: 6),
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
            ...Globals.achievements.map((a) => bullet(a)),
            if (Globals.certifications.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text("📜 Certifications:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 4),
              ...Globals.certifications.map((c) => bullet(c)),
            ],
          ],

          if (sections.contains("languages") && Globals.languages.isNotEmpty) ...[
            sectionTitle("🌐 Languages"),
            ...Globals.languages.map((lang) {
              final String name = lang['lang'] ?? '';
              final int level = lang['level'] ?? 3;
              return bullet("$name (${getLevelLabel(level)})");
            }),
          ],

          if (sections.contains("references") &&
              (Globals.r_name.isNotEmpty || Globals.designation.isNotEmpty || Globals.institute.isNotEmpty)) ...[
            sectionTitle("📚 References"),
            if (Globals.r_name.isNotEmpty) bullet("Name: ${Globals.r_name}"),
            if (Globals.designation.isNotEmpty) bullet("Designation: ${Globals.designation}"),
            if (Globals.institute.isNotEmpty) bullet("Institute: ${Globals.institute}"),
          ],
        ],
      ),
    );
  }
}
