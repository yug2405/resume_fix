import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class CreativeTemplate extends StatelessWidget {
  final Set<String> sections;
  const CreativeTemplate({super.key, required this.sections});

  String shortenUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return url;
    return uri.host.replaceFirst('www.', '') + uri.path;
  }

  String ensureUrl(String url) {
    if (!url.startsWith('http')) {
      return 'https://${url.trim()}';
    }
    return url.trim();
  }

  Widget clickableLink(String label, String url) {
    final Uri uri = Uri.parse(ensureUrl(url));
    final String displayText = shortenUrl(uri.toString());

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
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
      ),
    );
  }

  Widget numberedText(String text, int index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${index + 1}. ",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14))),
          ],
        ),
      );

  Widget bulletDash(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("– ", style: TextStyle(fontSize: 14)),
            Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14))),
          ],
        ),
      );

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((Globals.selectedTemplate == "Creative" || Globals.selectedTemplate == "Professional") &&
              Globals.profileImage != null) ...[
            Center(
              child: CircleAvatar(
                backgroundImage: MemoryImage(Globals.profileImage!),
                radius: 45,
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text(
            Globals.name,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 4),

          // 📞 Contact Info
          if (sections.contains("contact info")) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 10,
              runSpacing: 4,
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
                          final Uri emailUri = Uri.parse("mailto:${Globals.email}");
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          }
                        },
                    ),
                  ),
                if (Globals.number.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: Globals.number,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri phoneUri = Uri.parse("tel:${Globals.number}");
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          }
                        },
                    ),
                  ),
                if (Globals.github.isNotEmpty) clickableLink("GitHub", Globals.github),
                if (Globals.linkedin.isNotEmpty) clickableLink("LinkedIn", Globals.linkedin),
                if (Globals.portfolio.isNotEmpty) clickableLink("Portfolio", Globals.portfolio),
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
            if (Globals.course.isNotEmpty && Globals.school.isNotEmpty)
              bulletDash("${Globals.course} at ${Globals.school}"),
            if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
              bulletDash("Result: ${Globals.result}, Year: ${Globals.pass}"),
          ],

          if ((sections.contains("technical skills") || sections.contains("skills")) &&
              Globals.skills.isNotEmpty) ...[
            sectionTitle("💡 Skills"),
            ...Globals.skills.map((s) => bulletDash(s)),
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

              return bulletDash("$name (${getLabel(level)})");
            }),
          ],

          if ((sections.contains("projects") || sections.contains("research projects") || sections.contains("relevant coursework")) &&
              Globals.projects.isNotEmpty) ...[
            sectionTitle("📁 Projects"),
            ...Globals.projects.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((p['name'] ?? '').isNotEmpty) numberedText(p['name']!, i),
                  if ((p['desc'] ?? '').isNotEmpty) bulletDash("Description: ${p['desc']}"),
                  if ((p['role'] ?? '').isNotEmpty) bulletDash("Role: ${p['role']}"),
                  if ((p['tech'] ?? '').isNotEmpty) bulletDash("Technologies: ${p['tech']}"),
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
              final i = entry.key;
              final exp = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  numberedText("${exp['role']} at ${exp['company']}", i),
                  if ((exp['duration'] ?? '').isNotEmpty)
                    bulletDash("Duration: ${exp['duration']}"),
                  const SizedBox(height: 6),
                ],
              );
            }),
          ],

          if ((sections.contains("achievements") || sections.contains("awards") ||
              sections.contains("moot court") || sections.contains("certifications")) &&
              (Globals.achievements.isNotEmpty || Globals.certifications.isNotEmpty)) ...[
            sectionTitle("🏅 Achievements & Certifications"),
            ...Globals.achievements.asMap().entries
                .map((entry) => numberedText(entry.value, entry.key)),
            if (Globals.certifications.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text("📜 Certifications",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              ...Globals.certifications.asMap().entries
                  .map((entry) => numberedText(entry.value, entry.key)),
            ],
          ],

          if (sections.contains("references") &&
              (Globals.r_name.isNotEmpty ||
                  Globals.designation.isNotEmpty ||
                  Globals.institute.isNotEmpty)) ...[
            sectionTitle("📚 References"),
            if (Globals.r_name.isNotEmpty) bulletDash("Name: ${Globals.r_name}"),
            if (Globals.designation.isNotEmpty) bulletDash("Designation: ${Globals.designation}"),
            if (Globals.institute.isNotEmpty) bulletDash("Institute: ${Globals.institute}"),
          ],
        ],
      ),
    );
  }
}
