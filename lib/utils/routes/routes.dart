import 'package:flutter/material.dart';

// 🖥️ Screens
import 'package:resume_fix/screens/splash_screen.dart';
import 'package:resume_fix/screens/homepage.dart';
import 'package:resume_fix/screens/contact_info.dart';
import 'package:resume_fix/screens/personal_details.dart';
import 'package:resume_fix/screens/carrier_objective.dart';
import 'package:resume_fix/screens/education.dart';
import 'package:resume_fix/screens/experiences.dart';
import 'package:resume_fix/screens/achievements.dart';
import 'package:resume_fix/screens/projects.dart';
import 'package:resume_fix/screens/references.dart';
import 'package:resume_fix/screens/tecnical_skills.dart';
import 'package:resume_fix/screens/pdf_screen.dart';
import 'package:resume_fix/screens/field_selection.dart';
import 'package:resume_fix/screens/field_suggestion.dart';
import 'package:resume_fix/screens/resume_preview_screen.dart';
import 'package:resume_fix/screens/template_selection.dart';
import 'package:resume_fix/screens/languages.dart';
import 'package:resume_fix/screens/sop_evaluator/sop_input_screen.dart';
import 'package:resume_fix/screens/sop_evaluator/sop_evaluator.dart';

class Routes {
  // 🔁 Route Names
  static String splashScreen = '/';
  static String homePage = 'home';
  static String buildOptionPage = 'build_option';
  static String carrierObjectivePage = 'carrier_objective';
  static String contactInfoPage = 'contact_info';
  static String educationPage = 'education';
  static String experiencesPage = 'experiences';
  static String achievementsPage = 'achievements';
  static String pdfScreenPage = 'pdf_screen';
  static String personalDetailPage = 'personal_details';
  static String projectsPage = 'projects';
  static String referencesPage = 'references';
  static String technicalSkillsPage = 'technical_skills';
  static String fieldSelectionPage = '/fieldSelection';
  static String fieldSuggestionPage = '/fieldSuggestions';
  static String resumePreviewPage = 'resume_preview';
  static String templateSelectionPage = '/templateSelection';
  static const String certificationsPage = "/certifications";
  static const String profilePicture = "/profile_picture";
  static const String languagesPage = "/languages";
  static const String sopInputScreen = "/sop_input";
  static String sopEvaluatorPage = '/sopEvaluator';





  // 🧭 Route Mappings
  static Map<String, WidgetBuilder> myRoutes = {
    splashScreen: (context) => const splashscreen(),
    homePage: (context) => const Homepage(),
    contactInfoPage: (context) => const ContactInfoScreen(),
    personalDetailPage: (context) => const PersonalDetails(),
    carrierObjectivePage: (context) => const CareerObjectiveScreen(),
    educationPage: (context) => const EducationScreen(),
    experiencesPage: (context) => const ExperiencesScreen(),
    achievementsPage: (context) => const AchievementsScreen(),
    certificationsPage: (context) => const AchievementsScreen(title: "Certifications"),
    projectsPage: (context) => const Projects(),
    referencesPage: (context) => const ReferenceScreen(),
    technicalSkillsPage: (context) => const TechnicalScreen(),
    pdfScreenPage: (context) => const PdfScreen(),
    fieldSelectionPage: (context) => const FieldSelectionScreen(),
    fieldSuggestionPage: (context) => const FieldSuggestionScreen(),
    resumePreviewPage: (context) => const ResumePreviewScreen(),
    templateSelectionPage: (context) => const TemplateSelectionScreen(),
    languagesPage: (context) => const LanguagesScreen(),
    sopInputScreen: (context) => const SopInputScreen(),
    sopEvaluatorPage: (context) => const SoPEvaluatorScreen(),
  };
}
