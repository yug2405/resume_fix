import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart'; // Required for TapGestureRecognizer

class ProfessionalTemplate extends StatelessWidget {
  final Set<String> sections;
  const ProfessionalTemplate({super.key, required this.sections});

  Widget section(String title, List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade800,
              ),
            ),
            Container(
              width: 50,
              height: 3,
              color: Colors.blueGrey.shade300,
              margin: const EdgeInsets.only(top: 6, bottom: 12),
            ),
            ...children,
          ],
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Globals.selectedTemplate == "Professional" && Globals.profileImage != null) ...[
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundImage: MemoryImage(Globals.profileImage!),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text(
            Globals.name,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const SizedBox(height: 6),

          if (sections.contains("contact info")) ...[
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (Globals.email.isNotEmpty && Globals.number.isNotEmpty)
                  Text("Email: ${Globals.email} | Phone: ${Globals.number}",
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))
                else if (Globals.email.isNotEmpty)
                  Text("Email: ${Globals.email}",
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))
                else if (Globals.number.isNotEmpty)
                  Text("Phone: ${Globals.number}",
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),

                if (Globals.github.isNotEmpty) labeledLink("GitHub", Globals.github),
                if (Globals.linkedin.isNotEmpty) labeledLink("LinkedIn", Globals.linkedin),
                if (Globals.portfolio.isNotEmpty) labeledLink("Portfolio", Globals.portfolio),
              ],
            ),
          ],

          if ((sections.contains("summary") || 
     sections.contains("career objective") || 
     sections.contains("professional development")) &&
    (Globals.careerObjective.isNotEmpty || Globals.currentdes.isNotEmpty))
  section("📝 Summary", [
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
  ]),


          if (sections.contains("education") &&
              (Globals.course.isNotEmpty || Globals.school.isNotEmpty))
            section("🎓 Education", [
              if (Globals.course.isNotEmpty && Globals.school.isNotEmpty)
                Text("${Globals.course} at ${Globals.school}", style: GoogleFonts.poppins(fontSize: 14)),
              if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
                Text("Result: ${Globals.result}, Year: ${Globals.pass}",
                    style: GoogleFonts.poppins(fontSize: 14)),
            ]),

          if ((sections.contains("technical skills") || sections.contains("skills")) &&
              Globals.skills.isNotEmpty)
            section("💡 Skills", Globals.skills.map((s) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 14)),
                    Expanded(child: Text(s, style: GoogleFonts.poppins(fontSize: 14))),
                  ],
                ),
              );
            }).toList()),

          if ((sections.contains("projects") || sections.contains("research projects") ||
                  sections.contains("relevant coursework")) &&
              Globals.projects.isNotEmpty)
            section("📁 Projects", Globals.projects.asMap().entries.map((entry) {
              int i = entry.key;
              final p = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${i + 1}. ${p['name'] ?? ''}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
                    if ((p['desc'] ?? '').isNotEmpty)
                      Text("📝 Description: ${p['desc']}", style: GoogleFonts.poppins(fontSize: 13)),
                    if ((p['role'] ?? '').isNotEmpty)
                      Text("👨‍💻 Role: ${p['role']}", style: GoogleFonts.poppins(fontSize: 13)),
                    if ((p['tech'] ?? '').isNotEmpty)
                      Text("🛠️ Tech: ${p['tech']}", style: GoogleFonts.poppins(fontSize: 13)),
                  ],
                ),
              );
            }).toList()),

          if ((sections.contains("internships") || sections.contains("work experience") ||
                  sections.contains("experiences")) &&
              Globals.experiences.isNotEmpty)
            section("🧑‍💼 Experience", Globals.experiences.asMap().entries.map((entry) {
              int i = entry.key;
              final exp = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${i + 1}. ${exp['role']} at ${exp['company']}",
                        style: GoogleFonts.poppins(fontSize: 14)),
                    if ((exp['duration'] ?? '').isNotEmpty)
                      Text("📆 Duration: ${exp['duration']}",
                          style: GoogleFonts.poppins(fontSize: 13)),
                  ],
                ),
              );
            }).toList()),

          if ((sections.contains("achievements") || sections.contains("awards") ||
              sections.contains("moot court") || sections.contains("certifications")) &&
              (Globals.achievements.isNotEmpty || Globals.certifications.isNotEmpty))
            section("🏅 Achievements & Certifications", [
              ...Globals.achievements.map((a) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $a", style: GoogleFonts.poppins(fontSize: 14)),
                  )),
              if (Globals.certifications.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text("📜 Certifications:", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                ...Globals.certifications.map((c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text("• $c", style: GoogleFonts.poppins(fontSize: 14)),
                    )),
              ]
            ]),

          if (sections.contains("languages") && Globals.languages.isNotEmpty)
            section("🌐 Languages", Globals.languages.map((lang) {
              final String name = lang['lang'] ?? '';
              final int level = lang['level'] ?? 3;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• $name (${getLevelLabel(level)})",
                    style: GoogleFonts.poppins(fontSize: 14)),
              );
            }).toList()),

          if (sections.contains("references") &&
              (Globals.r_name.isNotEmpty || Globals.designation.isNotEmpty || Globals.institute.isNotEmpty))
            section("📚 References", [
              if (Globals.r_name.isNotEmpty)
                Text("Name: ${Globals.r_name}", style: GoogleFonts.poppins(fontSize: 14)),
              if (Globals.designation.isNotEmpty)
                Text("Designation: ${Globals.designation}", style: GoogleFonts.poppins(fontSize: 14)),
              if (Globals.institute.isNotEmpty)
                Text("Institute: ${Globals.institute}", style: GoogleFonts.poppins(fontSize: 14)),
            ]),
        ],
      ),
    );
  }
}
