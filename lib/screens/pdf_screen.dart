import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:resume_fix/utils/global.dart';

class PdfScreen extends StatelessWidget {
  const PdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate PDF"),
        backgroundColor: Globals.bgColor,
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (context) => generatePdf(),
        canChangePageFormat: false,
        allowPrinting: true,
        allowSharing: true,
        useActions: true,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final sectionSet = getSectionSet();

    pw.ImageProvider? profileImage;

    if ((Globals.selectedTemplate == "Professional" ||
            Globals.selectedTemplate == "Creative") &&
        Globals.profileImage != null) {
      profileImage = pw.MemoryImage(Globals.profileImage!);
    }

    final templateWidget = buildTemplateContent(
      Globals.selectedTemplate,
      sectionSet,
      profileImage: profileImage,
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [templateWidget],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 16),
          child: pw.Text(
            "Generated on: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  final cStyle = const pw.TextStyle(fontSize: 12);

  pw.Widget buildTemplateContent(
    String template,
    Set<String> sections, {
    pw.ImageProvider? profileImage,
  }) {
    switch (template.toLowerCase()) {
      case 'creative':
        return buildCreativeTemplate(sections, profileImage: profileImage);
      case 'professional':
        return buildProfessionalTemplate(sections, profileImage: profileImage);
      case 'simple':
        return buildSimpleTemplate(sections);
      case 'modern':
      default:
        return buildModernTemplate(sections);
    }
  }

  Set<String> getSectionSet() {
    final originalSections =
        (Globals.fieldResumeGuide[Globals.selectedField]?['sections'] as List?)
            ?.map(
              (e) => e.toString().toLowerCase().trim(),
            ) // lowercase & trimmed
            .toSet() ??
        {};

    final Set<String> mappedSections = {};

    for (var section in originalSections) {
      if (section.contains("skill"))
        mappedSections.add("skills");
      else if (section.contains("experience"))
        mappedSections.add("experiences");
      else if (section.contains("education"))
        mappedSections.add("education");
      else if (section.contains("summary") || section.contains("profile"))
        mappedSections.add("summary");
      else if (section.contains("project"))
        mappedSections.add("projects");
      else if (section.contains("achievement") ||
          section.contains("award") ||
          section.contains("certification"))
        mappedSections.add("achievements");
      else if (section.contains("reference"))
        mappedSections.add("references");
      else if (section.contains("hobby") || section.contains("interest"))
        mappedSections.add("interest/hobbies");
      else if (section.contains("language"))
        mappedSections.add("languages");
      else if (section.contains("declaration"))
        mappedSections.add("declaration");
      else
        mappedSections.add(section); // default fallback
    }

    return mappedSections;
  }

  static const bodyStyle = pw.TextStyle(fontSize: 10);

  pw.Widget numberedBullet(String text, int index) => pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text("${index + 1}. ", style: bodyStyle),
      pw.Expanded(child: pw.Text(text, style: bodyStyle)),
    ],
  );

  // This file only modifies the buildModernTemplate() logic to resemble the uploaded modern layout

  pw.Widget buildModernTemplate(Set<String> sections) {
    final leftColumn = <pw.Widget>[];
    final rightColumn = <pw.Widget>[];

    final headingStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.indigo800,
    );
    final bodyStyle = pw.TextStyle(fontSize: 10);
    final smallStyle = pw.TextStyle(fontSize: 9, color: PdfColors.grey800);

    pw.Widget sectionHeader(String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        title.toUpperCase(),
        style: headingStyle.copyWith(letterSpacing: 1),
      ),
    );

    pw.Widget bullet(String text) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("- ", style: bodyStyle),
        pw.Expanded(child: pw.Text(text, style: bodyStyle)),
      ],
    );

    pw.Widget numberedBullet(String text, int index) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("${index + 1}. ", style: bodyStyle),
        pw.Expanded(child: pw.Text(text, style: bodyStyle)),
      ],
    );

    // ---------- Header ----------
    leftColumn.add(
      pw.Text(
        Globals.name.toUpperCase(),
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
    );

    leftColumn.add(pw.SizedBox(height: 8));
    leftColumn.add(pw.Divider());

    // ---------- Contact Info ----------
    void addContact(String label, String value, {bool link = false}) {
      if (value.isEmpty) return;

      final linkUrl = value.startsWith("http") ? value : "https://$value";

      if (link) {
        leftColumn.add(
          pw.UrlLink(
            destination: linkUrl,
            child: pw.Text(
              "$label: $value", // Show full link, no shortening
              style: bodyStyle.copyWith(
                color: PdfColors.blue,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
        );
      } else {
        leftColumn.add(pw.Text("$label: $value", style: bodyStyle));
      }
    }

    // 👇 Add contacts
    addContact("Phone", Globals.number);
    addContact("Email", "mailto:${Globals.email}", link: true);
    addContact("LinkedIn", Globals.linkedin, link: true);
    addContact("GitHub", Globals.github, link: true);
    addContact("Portfolio", Globals.portfolio, link: true);
    leftColumn.add(pw.SizedBox(height: 10));

    // ---------- Skills ----------
    if ((sections.contains("skills") ||
            sections.contains("technical skills")) &&
        Globals.skills.isNotEmpty) {
      leftColumn.add(sectionHeader("Skills"));
      leftColumn.add(
        pw.Wrap(
          spacing: 6,
          runSpacing: 4,
          children: Globals.skills
              .map(
                (s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(s, style: smallStyle),
                ),
              )
              .toList(),
        ),
      );
      leftColumn.add(pw.SizedBox(height: 10));
    }

    // ---------- Languages ----------
    if (Globals.languages.isNotEmpty) {
      leftColumn.add(sectionHeader("Languages"));

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

      for (var lang in Globals.languages) {
        final name = lang["lang"] ?? '';
        final level = lang["level"] ?? 0;
        final label = getLevelLabel(level);
        leftColumn.add(bullet("$name ($label)"));
      }

      leftColumn.add(pw.SizedBox(height: 10));
    }

    // ---------- Education ----------
    if (sections.contains("education")) {
      leftColumn.add(sectionHeader("Education"));
      leftColumn.add(
        pw.Text(
          "${Globals.course}, ${Globals.school}",
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo600,
          ),
        ),
      );
      if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty) {
        leftColumn.add(
          pw.Text(
            "Result: ${Globals.result}, Year: ${Globals.pass}",
            style: smallStyle,
          ),
        );
      }
      leftColumn.add(pw.SizedBox(height: 10));
    }

    // ---------- Summary ----------
    if ((sections.contains("summary") ||
            sections.contains("professional development")) &&
        (Globals.careerObjective.isNotEmpty || Globals.currentdes.isNotEmpty)) {
      rightColumn.add(sectionHeader("Summary"));

      if (Globals.currentdes.isNotEmpty) {
        rightColumn.add(
          pw.Text("Designation: ${Globals.currentdes}", style: smallStyle),
        );
        rightColumn.add(pw.SizedBox(height: 4));
      }

      if (Globals.careerObjective.isNotEmpty) {
        rightColumn.add(
          pw.Text(
            Globals.careerObjective,
            style: bodyStyle,
            textAlign: pw.TextAlign.justify,
          ),
        );
      }

      rightColumn.add(pw.SizedBox(height: 10));
    }

    // ---------- Experience ----------
    if ((sections.contains("experiences") ||
            sections.contains("work experience") ||
            sections.contains("internships")) &&
        Globals.experiences.isNotEmpty) {
      rightColumn.add(sectionHeader("Experience"));
      for (var exp in Globals.experiences) {
        final role = exp['role'] ?? '';
        final company = exp['company'] ?? '';
        final duration = exp['duration'] ?? '';
        final desc = exp['description'] ?? '';

        if (role.isNotEmpty) {
          final index = Globals.experiences.indexOf(exp);
          rightColumn.add(
            pw.Text(
              "${index + 1}. $role",
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          );
        }

        if (company.isNotEmpty || duration.isNotEmpty) {
          rightColumn.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(company, style: smallStyle),
                pw.Text(duration, style: smallStyle),
              ],
            ),
          );
        }

        if (desc.isNotEmpty) rightColumn.add(bullet(desc));
        rightColumn.add(pw.SizedBox(height: 6));
      }
    }

    // ---------- Projects ----------
    if ((sections.contains("projects") ||
            sections.contains("research projects") ||
            sections.contains("relevant coursework")) &&
        Globals.projects.isNotEmpty) {
      rightColumn.add(sectionHeader("Projects"));
      for (var proj in Globals.projects) {
        final name = proj['name'] ?? '';
        final tech = proj['tech'] ?? '';
        final role = proj['role'] ?? '';
        final desc = proj['desc'] ?? '';

        if (name.isNotEmpty) {
          final index = Globals.projects.indexOf(proj);
          rightColumn.add(
            pw.Text(
              "${index + 1}. $name",
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          );
        }
        if (tech.isNotEmpty) rightColumn.add(bullet("Technologies: $tech"));
        if (role.isNotEmpty) rightColumn.add(bullet("Role: $role"));
        if (desc.isNotEmpty) rightColumn.add(bullet("Description: $desc"));
        rightColumn.add(pw.SizedBox(height: 6));
      }
    }

    // ---------- Achievements & Certifications ----------
    if ((sections.contains("achievements") ||
            sections.contains("certifications")) &&
        (Globals.achievements.isNotEmpty ||
            Globals.certifications.isNotEmpty)) {
      rightColumn.add(sectionHeader("Achievements & Certifications"));

      rightColumn.addAll(
        Globals.achievements.asMap().entries.map(
          (entry) => numberedBullet(entry.value, entry.key),
        ),
      );

      if (Globals.certifications.isNotEmpty) {
        rightColumn.add(pw.SizedBox(height: 4));
        rightColumn.add(pw.Text("Certifications:", style: headingStyle));
        rightColumn.addAll(
          Globals.certifications.asMap().entries.map(
            (entry) => numberedBullet(entry.value, entry.key),
          ),
        );
      }

      rightColumn.add(pw.SizedBox(height: 10));
    }

    // ---------- References ----------
    if (sections.contains("references") && Globals.r_name.isNotEmpty) {
      rightColumn.add(sectionHeader("References"));
      if (Globals.r_name.isNotEmpty)
        rightColumn.add(bullet("Name: ${Globals.r_name}"));
      if (Globals.designation.isNotEmpty)
        rightColumn.add(bullet("Designation: ${Globals.designation}"));
      if (Globals.institute.isNotEmpty)
        rightColumn.add(bullet("Institute: ${Globals.institute}"));
    }

    return pw.Container(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: leftColumn,
            ),
          ),
          pw.SizedBox(width: 25),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: rightColumn,
            ),
          ),
        ],
      ),
    );
  }
  // Extracted only the SIMPLE template layout based on your design
  // You can now integrate this into your `buildSimpleTemplate()` method

  pw.Widget buildSimpleTemplate(Set<String> sections) {
    final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );

    final pw.TextStyle textStyle = pw.TextStyle(fontSize: 11);

    pw.Widget sectionHeader(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
      child: pw.Text(text.toUpperCase(), style: headerStyle),
    );

    pw.Widget bullet(String text) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("- ", style: textStyle),
        pw.Expanded(child: pw.Text(text, style: textStyle)),
      ],
    );

    pw.Widget numberedBullet(String text, int index) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("${index + 1}. ", style: textStyle),
        pw.Expanded(child: pw.Text(text, style: textStyle)),
      ],
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              Globals.name.toUpperCase(),
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 6),

          // Contact + Socials
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "${Globals.email} | ${Globals.number}",
                  style: textStyle,
                ),
                if (Globals.dob.isNotEmpty || Globals.nationality.isNotEmpty)
                  pw.Text(
                    "DOB: ${Globals.dob} | Nationality: ${Globals.nationality}",
                    style: textStyle,
                  ),
                if (Globals.linkedin.isNotEmpty)
                  pw.UrlLink(
                    destination: Globals.linkedin.startsWith("http")
                        ? Globals.linkedin
                        : "https://${Globals.linkedin}",
                    child: pw.Text(
                      "LinkedIn: ${Globals.linkedin}",
                      style: textStyle.copyWith(
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                if (Globals.github.isNotEmpty)
                  pw.UrlLink(
                    destination: Globals.github.startsWith("http")
                        ? Globals.github
                        : "https://${Globals.github}",
                    child: pw.Text(
                      "GitHub: ${Globals.github}",
                      style: textStyle.copyWith(
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                if (Globals.portfolio.isNotEmpty)
                  pw.UrlLink(
                    destination: Globals.portfolio.startsWith("http")
                        ? Globals.portfolio
                        : "https://${Globals.portfolio}",
                    child: pw.Text(
                      "Portfolio: ${Globals.portfolio}",
                      style: textStyle.copyWith(
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Summary
          if ((sections.contains("summary") ||
                  sections.contains("professional development")) &&
              (Globals.careerObjective.isNotEmpty ||
                  Globals.currentdes.isNotEmpty)) ...[
            sectionHeader("Summary"),
            if (Globals.currentdes.isNotEmpty)
              pw.Text("Designation: ${Globals.currentdes}", style: textStyle),
            if (Globals.careerObjective.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(Globals.careerObjective, style: textStyle),
            ],
            pw.SizedBox(height: 10),
          ],

          // Experience
          if ((sections.contains("experiences") ||
                  sections.contains("work experience") ||
                  sections.contains("internships")) &&
              Globals.experiences.isNotEmpty) ...[
            sectionHeader("Experience"),
            ...Globals.experiences.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "${index + 1}. ${exp['role']?.toUpperCase() ?? ''}, ${exp['company'] ?? ''}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      color: PdfColors.deepOrange700,
                    ),
                  ),
                  if ((exp['duration'] ?? '').isNotEmpty)
                    pw.Text("Duration: ${exp['duration']}", style: textStyle),
                  if ((exp['description'] ?? '').isNotEmpty)
                    bullet(exp['description']!),
                  pw.SizedBox(height: 6),
                ],
              );
            }),
          ],

          // Projects
          if ((sections.contains("projects") ||
                  sections.contains("research projects") ||
                  sections.contains("relevant coursework")) &&
              Globals.projects.isNotEmpty) ...[
            sectionHeader("Projects"),
            ...Globals.projects.asMap().entries.map((entry) {
              final index = entry.key;
              final proj = entry.value;
              final title = proj['name'] ?? proj['title'] ?? '';
              final desc = proj['desc'] ?? proj['description'] ?? '';
              final role = proj['role'] ?? '';
              final tech = proj['tech'] ?? '';

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    pw.Text(
                      "${index + 1}. $title",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: PdfColors.teal800,
                      ),
                    ),
                  if (tech.isNotEmpty) bullet("Technologies: $tech"),
                  if (role.isNotEmpty) bullet("Role: $role"),
                  if (desc.isNotEmpty) bullet("Description: $desc"),
                  pw.SizedBox(height: 6),
                ],
              );
            }),
          ],

          // Education
          if (sections.contains("education")) ...[
            sectionHeader("Education"),
            pw.Text(
              "${Globals.course}, ${Globals.school}",
              style: pw.TextStyle(
                color: PdfColors.indigo600,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
              pw.Text(
                "Result: ${Globals.result}, Year: ${Globals.pass}",
                style: textStyle,
              ),
            pw.SizedBox(height: 10),
          ],

          // Skills
          if ((sections.contains("skills") ||
                  sections.contains("technical skills")) &&
              Globals.skills.isNotEmpty) ...[
            sectionHeader("Skills"),
            pw.Wrap(
              spacing: 10,
              runSpacing: 6,
              children: Globals.skills
                  .map(
                    (s) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(s, style: pw.TextStyle(fontSize: 10)),
                    ),
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 10),
          ],

          // Achievements & Certifications
          if ((sections.contains("activities") ||
                  sections.contains("achievements") ||
                  sections.contains("awards") ||
                  sections.contains("certifications")) &&
              (Globals.achievements.isNotEmpty ||
                  Globals.certifications.isNotEmpty)) ...[
            sectionHeader("Activities"),
            ...Globals.achievements.asMap().entries.map(
              (entry) => numberedBullet(entry.value, entry.key),
            ),
            if (Globals.certifications.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                "Certifications:",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              ...Globals.certifications.asMap().entries.map(
                (entry) => numberedBullet(entry.value, entry.key),
              ),
            ],
            pw.SizedBox(height: 10),
          ],

          // References
          if (sections.contains("references") &&
              (Globals.r_name.isNotEmpty ||
                  Globals.designation.isNotEmpty ||
                  Globals.institute.isNotEmpty)) ...[
            sectionHeader("References"),
            if (Globals.r_name.isNotEmpty) bullet("Name: ${Globals.r_name}"),
            if (Globals.designation.isNotEmpty)
              bullet("Designation: ${Globals.designation}"),
            if (Globals.institute.isNotEmpty)
              bullet("Institute: ${Globals.institute}"),
            pw.SizedBox(height: 10),
          ],

          // Hobbies
          if (sections.contains("interest/hobbies") &&
              Globals.hobbies.isNotEmpty) ...[
            sectionHeader("Hobbies"),
            pw.Wrap(
              spacing: 10,
              runSpacing: 6,
              children: Globals.hobbies
                  .map(
                    (hobby) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(hobby, style: pw.TextStyle(fontSize: 10)),
                    ),
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 10),
          ],

          // Languages
          if (sections.contains("languages") &&
              Globals.languages.isNotEmpty) ...[
            sectionHeader("Languages"),
            ...Globals.languages.map((lang) {
              final level = (lang['level'] as num).toInt();
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

              final label = getLevelLabel(level);
              return pw.Text("${lang['lang']}: $label", style: textStyle);
            }),
            pw.SizedBox(height: 10),
          ],

          // Declaration
          if (Globals.declaration.isNotEmpty) ...[
            sectionHeader("Declaration"),
            pw.Text(Globals.declaration, style: textStyle),
            if (Globals.place.isNotEmpty || Globals.date.isNotEmpty)
              pw.Text(
                "Place: ${Globals.place} | Date: ${Globals.date}",
                style: textStyle,
              ),
            pw.SizedBox(height: 10),
          ],

          // Custom Sections
          for (var section in Globals.customSections) ...[
            if ((section['title'] ?? '').isNotEmpty &&
                (section['desc'] ?? '').isNotEmpty) ...[
              sectionHeader(section['title']!),
              pw.Text(section['desc']!, style: textStyle),
              pw.SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }

  pw.Widget buildProfessionalTemplate(
    Set<String> sections, {
    pw.ImageProvider? profileImage,
  }) {
    final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      decoration: pw.TextDecoration.underline,
    );

    final pw.TextStyle textStyle = pw.TextStyle(fontSize: 11);

    pw.Widget sectionHeader(String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
      child: pw.Text(title, style: headerStyle),
    );

    pw.Widget bullet(String text, {bool useDash = false}) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(useDash ? "- " : "• ", style: textStyle),
        pw.Expanded(child: pw.Text(text, style: textStyle)),
      ],
    );

    pw.Widget numberedBullet(String text, int index) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("${index + 1}. ", style: textStyle),
        pw.Expanded(child: pw.Text(text, style: textStyle)),
      ],
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // 👤 Profile Image + Name
          pw.Center(
            child: pw.Column(
              children: [
                if (profileImage != null)
                  pw.Container(
                    width: 80,
                    height: 80,
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(
                        image: profileImage,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                pw.Text(
                  Globals.name.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 4),

          // 📞 Contact
          pw.Center(
            child: pw.Text(
              "${Globals.number} | ${Globals.email}",
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
            ),
          ),

          // 🔗 Social Links
          if (Globals.linkedin.isNotEmpty ||
              Globals.github.isNotEmpty ||
              Globals.portfolio.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (Globals.linkedin.isNotEmpty)
                    pw.UrlLink(
                      destination: Globals.linkedin.startsWith("http")
                          ? Globals.linkedin
                          : "https://${Globals.linkedin}",
                      child: pw.Text(
                        "LinkedIn: ${Globals.linkedin}",
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ),
                  if (Globals.github.isNotEmpty)
                    pw.UrlLink(
                      destination: Globals.github.startsWith("http")
                          ? Globals.github
                          : "https://${Globals.github}",
                      child: pw.Text(
                        "GitHub: ${Globals.github}",
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ),
                  if (Globals.portfolio.isNotEmpty)
                    pw.UrlLink(
                      destination: Globals.portfolio.startsWith("http")
                          ? Globals.portfolio
                          : "https://${Globals.portfolio}",
                      child: pw.Text(
                        "Portfolio: ${Globals.portfolio}",
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // 📝 Summary
          if ((sections.contains("summary") ||
                  sections.contains("professional development")) &&
              (Globals.careerObjective.isNotEmpty ||
                  Globals.currentdes.isNotEmpty)) ...[
            sectionHeader("Summary"),
            if (Globals.currentdes.isNotEmpty)
              pw.Text("Designation: ${Globals.currentdes}", style: textStyle),
            if (Globals.careerObjective.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(Globals.careerObjective, style: textStyle),
            ],
          ],

          // 🛠 Skills
          if ((sections.contains("skills") ||
                  sections.contains("technical skills")) &&
              Globals.skills.isNotEmpty) ...[
            sectionHeader("Skills"),
            pw.Wrap(
              spacing: 10,
              runSpacing: 6,
              children: Globals.skills.map((s) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(s, style: pw.TextStyle(fontSize: 10)),
                );
              }).toList(),
            ),
          ],

          // 💼 Experience
          if ((sections.contains("experiences") ||
                  sections.contains("work experience") ||
                  sections.contains("internships")) &&
              Globals.experiences.isNotEmpty) ...[
            sectionHeader("Experience"),
            ...Globals.experiences.asMap().entries.map((entry) {
              final i = entry.key;
              final exp = entry.value;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "${i + 1}. ${exp['company'] ?? ''}",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      if ((exp['duration'] ?? '').isNotEmpty)
                        pw.Text(
                          exp['duration'] ?? '',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey800,
                          ),
                        ),
                    ],
                  ),
                  if ((exp['role'] ?? '').isNotEmpty)
                    pw.Text(
                      exp['role'] ?? '',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  if ((exp['description'] ?? '').isNotEmpty)
                    bullet(exp['description']!),
                  pw.SizedBox(height: 6),
                ],
              );
            }),
          ],

          // 🧪 Projects
          if ((sections.contains("projects") ||
                  sections.contains("research projects") ||
                  sections.contains("relevant coursework")) &&
              Globals.projects.isNotEmpty) ...[
            sectionHeader("Projects"),
            ...Globals.projects.asMap().entries.map((entry) {
              final i = entry.key;
              final proj = entry.value;
              final title = proj['name'] ?? proj['title'] ?? '';
              final desc = proj['desc'] ?? proj['description'] ?? '';
              final role = proj['role'] ?? '';
              final tech = proj['tech'] ?? '';

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    pw.Text(
                      "${i + 1}. $title",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  if (tech.isNotEmpty)
                    bullet("Technologies: $tech", useDash: true),
                  if (role.isNotEmpty) bullet("Role: $role", useDash: true),
                  if (desc.isNotEmpty)
                    bullet("Description: $desc", useDash: true),
                  pw.SizedBox(height: 6),
                ],
              );
            }),
          ],

          // 🎓 Education
          if (sections.contains("education")) ...[
            sectionHeader("Education"),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  Globals.school,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Year: ${Globals.pass}",
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                ),
              ],
            ),
            pw.Text(Globals.course, style: textStyle),
          ],

          // 🏅 Achievements & Certifications
          if ((sections.contains("achievements") ||
                  sections.contains("certifications")) &&
              (Globals.achievements.isNotEmpty ||
                  Globals.certifications.isNotEmpty)) ...[
            sectionHeader("Achievements & Certifications"),
            ...Globals.achievements.asMap().entries.map(
              (entry) => numberedBullet(entry.value, entry.key),
            ),
            if (Globals.certifications.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                "Certifications:",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              ...Globals.certifications.asMap().entries.map(
                (entry) => numberedBullet(entry.value, entry.key),
              ),
            ],
          ],

          // 🧑‍🤝‍🧑 References
          if (sections.contains("references") &&
              (Globals.r_name.isNotEmpty ||
                  Globals.designation.isNotEmpty ||
                  Globals.institute.isNotEmpty)) ...[
            sectionHeader("References"),
            if (Globals.r_name.isNotEmpty) bullet("Name: ${Globals.r_name}"),
            if (Globals.designation.isNotEmpty)
              bullet("Designation: ${Globals.designation}"),
            if (Globals.institute.isNotEmpty)
              bullet("Institute: ${Globals.institute}"),
          ],

          // 🎯 Hobbies
          if (sections.contains("interest/hobbies") &&
              Globals.hobbies.isNotEmpty) ...[
            sectionHeader("Hobbies"),
            pw.Wrap(
              spacing: 10,
              runSpacing: 6,
              children: Globals.hobbies
                  .map(
                    (hobby) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(hobby, style: pw.TextStyle(fontSize: 10)),
                    ),
                  )
                  .toList(),
            ),
          ],

          // 🌍 Languages
          if (sections.contains("languages") &&
              Globals.languages.isNotEmpty) ...[
            sectionHeader("Languages"),
            ...Globals.languages.map((lang) {
              final level = (lang['level'] as num).toInt();
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

              final label = getLevelLabel(level);
              return pw.Text("${lang['lang']}: $label", style: textStyle);
            }),
          ],

          // 🧾 Declaration
          if (Globals.declaration.isNotEmpty) ...[
            sectionHeader("Declaration"),
            pw.Text(Globals.declaration, style: textStyle),
            if (Globals.place.isNotEmpty || Globals.date.isNotEmpty)
              pw.Text(
                "Place: ${Globals.place} | Date: ${Globals.date}",
                style: textStyle,
              ),
          ],

          // 📚 Custom Sections
          for (var section in Globals.customSections) ...[
            if ((section['title'] ?? '').isNotEmpty &&
                (section['desc'] ?? '').isNotEmpty) ...[
              sectionHeader(section['title']!),
              pw.Text(section['desc']!, style: textStyle),
            ],
          ],
        ],
      ),
    );
  }

  pw.Widget buildCreativeTemplate(
    Set<String> sections, {
    pw.ImageProvider? profileImage,
  }) {
    final headingStyle = pw.TextStyle(
      fontSize: 13,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.purple800,
    );
    final bodyStyle = pw.TextStyle(fontSize: 10);
    final subText = pw.TextStyle(fontSize: 9, color: PdfColors.grey800);

    pw.Widget sectionHeader(String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(title.toUpperCase(), style: headingStyle),
    );

    pw.Widget bulletDash(String text) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("- ", style: bodyStyle),
        pw.Expanded(child: pw.Text(text, style: bodyStyle)),
      ],
    );

    pw.Widget numberedBullet(String text, int index) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("${index + 1}. ", style: bodyStyle),
        pw.Expanded(child: pw.Text(text, style: bodyStyle)),
      ],
    );

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 🔹 Left Sidebar
        pw.Container(
          width: 150,
          color: PdfColors.purple100,
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (profileImage != null)
                pw.Center(
                  child: pw.Container(
                    width: 70,
                    height: 70,
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(
                        image: profileImage,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              sectionHeader("Contact"),
              if (Globals.email.isNotEmpty)
                bulletDash("Email: ${Globals.email}"),
              if (Globals.number.isNotEmpty)
                bulletDash("Phone: ${Globals.number}"),

              if (Globals.linkedin.isNotEmpty)
                bulletDash("LinkedIn: ${Globals.linkedin}"),
              if (Globals.github.isNotEmpty)
                bulletDash("GitHub: ${Globals.github}"),
              if (Globals.portfolio.isNotEmpty)
                bulletDash("Portfolio: ${Globals.portfolio}"),

              if (Globals.skills.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                sectionHeader("Skills"),
                ...Globals.skills.asMap().entries.map(
                  (entry) => numberedBullet(entry.value, entry.key),
                ),
              ],

              if (sections.contains("interest/hobbies") &&
                  Globals.hobbies.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                sectionHeader("Hobbies"),
                ...Globals.hobbies.map((hobby) => bulletDash(hobby)),
              ],
            ],
          ),
        ),

        // 🔸 Right Column
        pw.SizedBox(width: 15),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.purple200,
                child: pw.Text(
                  Globals.name.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 12),

              if ((sections.contains("summary") ||
                      sections.contains("professional development")) &&
                  (Globals.careerObjective.isNotEmpty ||
                      Globals.currentdes.isNotEmpty)) ...[
                sectionHeader("Summary"),
                if (Globals.currentdes.isNotEmpty)
                  pw.Text(
                    "Designation: ${Globals.currentdes}",
                    style: bodyStyle,
                  ),
                if (Globals.careerObjective.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(Globals.careerObjective, style: bodyStyle),
                ],
                pw.SizedBox(height: 10),
              ],

              if (sections.contains("education")) ...[
                sectionHeader("Education"),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      Globals.course,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(Globals.pass, style: subText),
                  ],
                ),
                pw.Text(Globals.school, style: bodyStyle),
                if (Globals.result.isNotEmpty)
                  pw.Text("Result: ${Globals.result}", style: subText),
                pw.SizedBox(height: 10),
              ],

              if ((sections.contains("internships") ||
                      sections.contains("work experience") ||
                      sections.contains("experiences")) &&
                  Globals.experiences.isNotEmpty) ...[
                sectionHeader("Work Experience"),
                ...Globals.experiences.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exp = entry.value;
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "${i + 1}. ${exp['role'] ?? ''}",
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(exp['duration'] ?? '', style: subText),
                        ],
                      ),
                      if ((exp['company'] ?? '').isNotEmpty)
                        pw.Text(exp['company']!, style: bodyStyle),
                      if ((exp['description'] ?? '').isNotEmpty)
                        pw.Text(exp['description']!, style: subText),
                      pw.SizedBox(height: 6),
                    ],
                  );
                }),
              ],

              if ((sections.contains("projects") ||
                      sections.contains("research projects") ||
                      sections.contains("relevant coursework")) &&
                  Globals.projects.isNotEmpty) ...[
                sectionHeader("Projects"),
                ...Globals.projects.asMap().entries.map((entry) {
                  final i = entry.key;
                  final proj = entry.value;
                  final title = proj['name'] ?? proj['title'] ?? '';
                  final desc = proj['desc'] ?? proj['description'] ?? '';
                  final role = proj['role'] ?? '';
                  final tech = proj['tech'] ?? '';

                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        pw.Text(
                          "${i + 1}. $title",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      if (desc.isNotEmpty) bulletDash("Description: $desc"),
                      if (role.isNotEmpty) bulletDash("Role: $role"),
                      if (tech.isNotEmpty) bulletDash("Technologies: $tech"),
                      pw.SizedBox(height: 6),
                    ],
                  );
                }),
                pw.SizedBox(height: 10),
              ],

              if ((sections.contains("activities") ||
                      sections.contains("achievements") ||
                      sections.contains("awards") ||
                      sections.contains("certifications")) &&
                  (Globals.achievements.isNotEmpty ||
                      Globals.certifications.isNotEmpty)) ...[
                sectionHeader("Achievements & Certifications"),
                ...Globals.achievements.asMap().entries.map(
                  (entry) => numberedBullet(entry.value, entry.key),
                ),
                if (Globals.certifications.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text("Certifications:", style: headingStyle),
                  ...Globals.certifications.asMap().entries.map(
                    (entry) => numberedBullet(entry.value, entry.key),
                  ),
                ],
                pw.SizedBox(height: 10),
              ],

              if (sections.contains("languages") &&
                  Globals.languages.isNotEmpty) ...[
                sectionHeader("Languages"),
                ...Globals.languages.map((lang) {
                  final level = (lang['level'] as num).toInt();
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

                  final label = getLevelLabel(level);
                  return bulletDash("${lang['lang']}: $label");
                }),
                pw.SizedBox(height: 10),
              ],

              if (sections.contains("references") &&
                  (Globals.r_name.isNotEmpty ||
                      Globals.designation.isNotEmpty ||
                      Globals.institute.isNotEmpty)) ...[
                sectionHeader("References"),
                if (Globals.r_name.isNotEmpty)
                  bulletDash("Name: ${Globals.r_name}"),
                if (Globals.designation.isNotEmpty)
                  bulletDash("Designation: ${Globals.designation}"),
                if (Globals.institute.isNotEmpty)
                  bulletDash("Institute: ${Globals.institute}"),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget baseLayout(
    Set<String> sectionSet, {
    PdfColor titleColor = PdfColors.black,
  }) {
    pw.Widget sectionTitle(String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: titleColor,
        ),
      ),
    );

    pw.Widget bullet(String text) => pw.Bullet(
      text: text,
      style: pw.TextStyle(fontSize: 11, color: titleColor),
      bulletColor: titleColor,
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          Globals.name,
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: titleColor,
          ),
        ),
        pw.SizedBox(height: 4),

        if (sectionSet.contains("contact info")) ...[
          if (Globals.email.isNotEmpty || Globals.number.isNotEmpty)
            pw.Text("${Globals.email} | ${Globals.number}", style: cStyle),
        ],

        if ((sectionSet.contains("summary") ||
                sectionSet.contains("Professional Development")) &&
            Globals.careerObjective.isNotEmpty) ...[
          sectionTitle("Summary"),
          pw.Text(Globals.careerObjective, style: cStyle),
        ],

        if (sectionSet.contains("career objective") &&
            Globals.currentdes.isNotEmpty) ...[
          sectionTitle("Career Objective"),
          pw.Text(Globals.currentdes, style: cStyle),
        ],

        if (sectionSet.contains("education")) ...[
          sectionTitle("Education"),
          if (Globals.course.isNotEmpty || Globals.school.isNotEmpty)
            bullet("${Globals.course} at ${Globals.school}"),
          if (Globals.result.isNotEmpty || Globals.pass.isNotEmpty)
            bullet("Result: ${Globals.result}, Year: ${Globals.pass}"),
        ],

        if ((sectionSet.contains("technical skills") ||
                sectionSet.contains("skills")) &&
            Globals.skills.isNotEmpty) ...[
          sectionTitle("Skills"),
          ...Globals.skills.map((s) => bullet(s)),
        ],

        if ((sectionSet.contains("projects") ||
                sectionSet.contains("research projects")) &&
            Globals.projects.isNotEmpty) ...[
          sectionTitle("Projects"),
          ...Globals.projects.map(
            (p) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                bullet(" ${p['name'] ?? ''}"),
                if ((p['desc'] ?? '').isNotEmpty) bullet("📝 ${p['desc']}"),
                if ((p['role'] ?? '').isNotEmpty)
                  bullet("👨‍💻 Role: ${p['role']}"),
                if ((p['tech'] ?? '').isNotEmpty)
                  bullet("🛠️ Tech: ${p['tech']}"),
              ],
            ),
          ),
        ],

        if ((sectionSet.contains("internships") ||
                sectionSet.contains("experiences") ||
                sectionSet.contains("work experience")) &&
            Globals.experiences.isNotEmpty) ...[
          sectionTitle("Experience"),
          ...Globals.experiences.map(
            (exp) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                bullet("${exp['role']} at ${exp['company']}"),
                if ((exp['duration'] ?? '').isNotEmpty)
                  bullet("Duration: ${exp['duration']}"),
              ],
            ),
          ),
        ],

        if ((sectionSet.contains("achievements") ||
                sectionSet.contains("certifications")) &&
            (Globals.achievements.isNotEmpty ||
                Globals.certifications.isNotEmpty)) ...[
          sectionTitle("Achievements & Certifications"),
          ...Globals.achievements.map((a) => bullet(a)),
          if (Globals.certifications.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              "Certifications:",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
                color: titleColor,
              ),
            ),
            ...Globals.certifications.map((c) => bullet(c)),
          ],
        ],

        if (sectionSet.contains("references") &&
            (Globals.r_name.isNotEmpty ||
                Globals.designation.isNotEmpty ||
                Globals.institute.isNotEmpty)) ...[
          sectionTitle("References"),
          if (Globals.r_name.isNotEmpty) bullet("Name: ${Globals.r_name}"),
          if (Globals.designation.isNotEmpty)
            bullet("Designation: ${Globals.designation}"),
          if (Globals.institute.isNotEmpty)
            bullet("Institute: ${Globals.institute}"),
        ],
      ],
    );
  }
}
