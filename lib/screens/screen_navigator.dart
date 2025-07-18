import 'package:flutter/material.dart';
import 'package:resume_fix/utils/global.dart';
import 'package:resume_fix/utils/routes/routes.dart';

/// 🗺️ Section to Route Mapping
Map<String, String> sectionRouteMap = {
  "Profile Picture": Routes.profilePicture,
  "Contact Info": Routes.contactInfoPage,
  "Summary": Routes.carrierObjectivePage,
  "Education": Routes.educationPage,
  "Projects": Routes.projectsPage,
  "Technical Skills": Routes.technicalSkillsPage,
  "Internships": Routes.experiencesPage,
  "Certifications": Routes.certificationsPage,
  "Awards": Routes.achievementsPage,
  "Languages": Routes.languagesPage,
  "Teaching Experience": Routes.experiencesPage,
  "Profile": Routes.carrierObjectivePage,
  "Skills": Routes.technicalSkillsPage,
  "Objective": Routes.carrierObjectivePage,
  "Carrier Objective": Routes.carrierObjectivePage, // typo fallback
  "Experiences": Routes.experiencesPage,
"Achievements": Routes.achievementsPage,
"References": Routes.referencesPage,
"Interest/Hobbies": Routes.personalDetailPage,
"Personal Details": Routes.personalDetailPage,
};

/// 🔁 Recursive Navigator for Resume Flow
void navigateToNextResumeScreen(BuildContext context, int index) {
  if (index < Globals.resumeFlow.length) {
    String section = Globals.resumeFlow[index];
    String? route = sectionRouteMap[section];

    if (route != null) {
      Navigator.pushNamed(context, route).then((_) {
        navigateToNextResumeScreen(context, index + 1); // ⏭️ Continue next
      });
    } else {
      // 🧹 Skip unknown sections
      navigateToNextResumeScreen(context, index + 1);
    }
  } else {
    // ✅ Resume completed, go to preview
    Navigator.pushNamed(context, Routes.resumePreviewPage);
  }
}
