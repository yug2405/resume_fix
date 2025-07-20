import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resume_fix/utils/routes/routes.dart';

class Globals {
  // 🎨 Theme
  static Color textColor = const Color(0xffffffff);
  static Color bgColor = Colors.black;
  static Color text1 = const Color(0xffb0b0b0);
  static Color pdfTop = const Color(0xff353743);

  static TextStyle mystyle = TextStyle(
    fontSize: 20,
    color: bgColor,
    fontWeight: FontWeight.w500,
  );

  // 🔁 Flow Control
  static int initialIndex = 0;
  static bool off1 = true;
  static String selectedField = "";
  static String selectedTemplate = "Modern";
  static String selectedDomain = "";
  static List<String> resumeFlow = [];

  // 🌐 Language/Skill Flags (basic)
  static bool gujarati = false;
  static bool hindi = false;
  static bool english = false;
  static bool flutter = false;

  // 📷 Image Picker
  static String? imagePath = "";
  static final ImagePicker picker = ImagePicker();
  static Uint8List? profileImage;

  // 🧾 Personal Info
  static String name = "";
  static String email = "";
  static String number = "";
  static String city = "";
  static String dob = "";
  static String nationality = "";

  // 🏫 Education
  static String course = "";
  static String school = "";
  static String result = "";
  static String pass = "";

  // 🧑‍💼 Career
  static String career = "";
  static String careerObjective = "";
  static String currentdes = "";

  // 🏆 Achievements / Certifications
  static List<String> achievements = [];
  static List<String> certifications = [];

  // 🧾 References
  static String r_name = "";
  static String designation = "";
  static String institute = "";

  // 📋 Skills / Experiences / Projects
  static List<String> skills = [];
  static List<Map<String, String>> experiences = [];
  static List<Map<String, String>> projects = [];
static bool skillsSectionVisited = false;
static List<String> relevantCoursework = [];


  // 🎯 Hobbies / Languages / Custom Sections
  static List<String> hobbies = [];
  static List<Map<String, dynamic>> languages = []; // [{"lang": "English", "level": 5}]
  static List<Map<String, String>> customSections = []; // [{"title": "Conferences", "desc": "Presented paper..."}]

  // 🌐 Social Links
  static String github = "";
  static String linkedin = "";
  static String portfolio = "";

  // 📜 Declaration
  static String declaration = "";
  static String place = "";
  static String date = "";

  // 🧠 TextEditingControllers
  static final namec = TextEditingController();
  static final emailc = TextEditingController();
  static final numberc = TextEditingController();
  static final address1c = TextEditingController();
  static final address2c = TextEditingController();
  static final address3c = TextEditingController();
  static final coursec = TextEditingController();
  static final schoolc = TextEditingController();
  static final resultc = TextEditingController();
  static final passc = TextEditingController();
  static final r_namec = TextEditingController();
  static final designationc = TextEditingController();
  static final institutec = TextEditingController();
  static final dobc = TextEditingController();
  static final nationalityc = TextEditingController();
  static final careerc = TextEditingController();
  static final currentdesc = TextEditingController();
  static final githubc = TextEditingController();
  static final linkedinc = TextEditingController();
  static final portfolioc = TextEditingController();
  static final declarationc = TextEditingController();
  static final placec = TextEditingController();
  static final datec = TextEditingController();
  static final hobbyc = TextEditingController();

  // 📁 Section List
  static final List<Map<String, dynamic>> alldetails = [
    {'name': 'Profile Picture', 'icon': 'assets/Icon/user.png', 'names': 'profile_picture'},
    {'name': 'Contact Info', 'icon': 'assets/Icon/contact-books.png', 'names': 'contact_info'},
    {'name': 'Summary', 'icon': 'assets/Icon/briefcase.png', 'names': 'carrier_objective'},
    {'name': 'Career Objective', 'icon': 'assets/Icon/briefcase.png', 'names': 'carrier_objective'},
    {'name': 'Personal Details', 'icon': 'assets/Icon/user.png', 'names': 'personal_details'},
    {'name': 'Education', 'icon': 'assets/Icon/mortarboard.png', 'names': 'education'},
    {'name': 'Experience', 'icon': 'assets/Icon/thinking.png', 'names': 'experiences'},
    {'name': 'Experiences', 'icon': 'assets/Icon/thinking.png', 'names': 'experiences'},
    {'name': 'Internships', 'icon': 'assets/Icon/experience.png', 'names': 'experiences'},
    {'name': 'Projects', 'icon': 'assets/Icon/experience.png', 'names': 'projects'},
    {'name': 'Achievements', 'icon': 'assets/Icon/achievement.png', 'names': 'achievements'},
    {'name': 'Awards', 'icon': 'assets/Icon/achievement.png', 'names': 'achievements'},
    {'name': 'References', 'icon': 'assets/Icon/handshake.png', 'names': 'references'},
    {'name': 'Technical Skills', 'icon': 'assets/Icon/declaration.png', 'names': 'technical_skills'},
    {'name': 'Work Experience', 'icon': 'assets/Icon/thinking.png', 'names': 'experiences'},
    {'name': 'Certifications', 'icon': 'assets/Icon/achievement.png', 'names': 'achievements'},
    {'name': 'Clinical Experience', 'icon': 'assets/Icon/stethoscope.png', 'names': 'experiences'},
    {'name': 'Interest/Hobbies', 'icon': 'assets/Icon/open-book.png', 'names': 'interest_hobbies'},
    {'name': 'Objective', 'icon': 'assets/Icon/briefcase.png', 'names': 'carrier_objective'},
    {'name': 'Awards/Honors', 'icon': 'assets/Icon/achievement.png', 'names': 'achievements'},
    {'name': 'Business Skills', 'icon': 'assets/Icon/declaration.png', 'names': 'technical_skills'},
    {'name': 'Languages', 'icon': 'assets/Icon/open-book.png', 'names': Routes.languagesPage},
    {'name': 'Extracurriculars', 'icon': 'assets/Icon/open-book.png', 'names': 'interest_hobbies'},
    {'name': 'Portfolio', 'icon': 'assets/Icon/experience.png', 'names': 'projects'},
    {'name': 'Profile', 'icon': 'assets/Icon/briefcase.png', 'names': 'carrier_objective'},
    {'name': 'Moot Court', 'icon': 'assets/Icon/thinking.png', 'names': 'achievements'},
    {'name': 'Research Projects', 'icon': 'assets/Icon/experience.png', 'names': 'projects'},
    {'name': 'Volunteering', 'icon': 'assets/Icon/thinking.png', 'names': 'experiences'},
    {'name': 'Publications', 'icon': 'assets/Icon/experience.png', 'names': 'projects'},
    {'name': 'Relevant Coursework', 'icon': 'assets/Icon/experience.png', 'names': 'projects'},
    {'name': 'Activities', 'icon': 'assets/Icon/open-book.png', 'names': 'interest_hobbies'},
    {'name': 'Customer Service Experience', 'icon': 'assets/Icon/thinking.png', 'names': 'experiences'},
    {'name': 'Field/Lab Experience', 'icon': 'assets/Icon/experience.png', 'names': 'experiences'},
    {'name': 'professional development', 'icon': 'assets/Icon/briefcase.png', 'names': 'carrier_objective'},
    {'name': 'Research Experience', 'icon': 'assets/Icon/experience.png', 'names': 'experiences'},
    {'name': 'Teaching Experience', 'icon': 'assets/Icon/experience.png', 'names': 'experiences'},
    {'name': 'SOP Evaluator', 'icon': 'assets/Icon/open-book.png', 'names': Routes.sopInputScreen},
  ];

  // 🔁 Reset All Data
  static void resetData() {
    course = school = result = pass = "";
    dob = nationality = career = careerObjective = currentdes = "";
    r_name = designation = institute = "";
    city = imagePath = "";
    selectedField = selectedTemplate = selectedDomain = "";
    github = linkedin = portfolio = declaration = place = date = "";
    skills.clear();
    projects.clear();
    experiences.clear();
    achievements.clear();
    certifications.clear();
    hobbies.clear();
    languages.clear();
    customSections.clear();
    profileImage = null;

    // Optional: Clear controllers
    namec.clear();
    emailc.clear();
    numberc.clear();
    address1c.clear();
    address2c.clear();
    address3c.clear();
    coursec.clear();
    schoolc.clear();
    resultc.clear();
    passc.clear();
    r_namec.clear();
    designationc.clear();
    institutec.clear();
    dobc.clear();
    nationalityc.clear();
    careerc.clear();
    currentdesc.clear();
    githubc.clear();
    linkedinc.clear();
    portfolioc.clear();
    declarationc.clear();
    placec.clear();
    datec.clear();
    hobbyc.clear();
    relevantCoursework.clear();
  }

  // 📤 Compact Resume Data
  static Map<String, dynamic> get allData => {
        "name": name,
        "email": email,
        "number": number,
        "dob": dob,
        "nationality": nationality,
        "career": career,
        "course": course,
        "school": school,
        "result": result,
        "pass": pass,
        "skills": skills,
        "projects": projects,
        "experiences": experiences,
        "achievements": achievements,
        "certifications": certifications,
        "hobbies": hobbies,
        "languages": languages,
        "customSections": customSections,
        "r_name": r_name,
        "designation": designation,
        "institute": institute,
        "template": selectedTemplate,
        "github": github,
        "linkedin": linkedin,
        "portfolio": portfolio,
        "declaration": declaration,
        "place": place,
        "date": date,
        "profileImage": profileImage,
        "relevantCoursework": relevantCoursework,
      };

  // 🧹 Dispose Controllers
  static void disposeControllers() {
    namec.dispose();
    emailc.dispose();
    numberc.dispose();
    coursec.dispose();
    schoolc.dispose();
    resultc.dispose();
    passc.dispose();
    r_namec.dispose();
    designationc.dispose();
    institutec.dispose();
    dobc.dispose();
    nationalityc.dispose();
    careerc.dispose();
    currentdesc.dispose();
    githubc.dispose();
    linkedinc.dispose();
    portfolioc.dispose();
    declarationc.dispose();
    placec.dispose();
    datec.dispose();
    hobbyc.dispose();
  }

  // 📚 Dynamic Resume Guide per Field
  static Map<String, Map<String, dynamic>> fieldResumeGuide = {
    "Computer Science & IT": {
      "template": "Modern",
      "sections": [
        "Contact Info", "Summary", "Education", "Projects",
        "Technical Skills", "Internships", "Certifications"
      ],
      "keywords": ["Python", "ML", "Git", "API", "REST", "Flask", "SQL"],
    },
    "Business & Management": {
      "template": "Professional",
      "sections": [
        "Contact Info", "Summary", "Education", "Business Skills",
        "Experience", "Languages", "Certifications"
      ],
      "keywords": ["ROI", "Market Research", "CRM", "Strategy"],
    },
    "Medical & Healthcare": {
      "template": "Modern",
      "sections": [
        "Contact Info", "Summary", "Education", "Clinical Experience",
        "Skills", "Certifications"
      ],
      "keywords": ["Lab Testing", "Clinical", "Patient Care", "Bioinformatics"],
    },
    "Engineering": {
      "template": "Modern",
      "sections": [
        "Contact Info", "Summary", "Education", "Technical Skills",
        "Internships", "Relevant Coursework", "Awards"
      ],
      "keywords": ["CAD", "ANSYS", "MATLAB", "Simulation"],
    },
    "Science (All Branches)": {
      "template": "Simple",
      "sections": [
        "Contact Info", "Summary", "Education", "Research Experience",
        "Technical Skills", "Publications", "Certifications"
      ],
      "keywords": ["PCR", "Lab Testing", "Bioinformatics", "Research"],
    },
    "Arts & Creative": {
      "template": "Creative",
      "sections": [
        "Contact Info", "Profile", "Education",
        "Projects", "Skills", "Awards", "Experience"
      ],
      "keywords": ["Adobe", "UI/UX", "Figma", "Branding", "Typography"],
    },
    "Education": {
      "template": "Simple",
      "sections": [
        "Contact Info", "Education", "Teaching Experience",
        "Skills", "Professional Development", "Awards"
      ],
      "keywords": ["Curriculum", "Pedagogy", "Lesson Planning"],
    },
    "Social Sciences": {
      "template": "Professional",
      "sections": [
        "Contact Info", "Summary", "Education", "Research Projects",
         "Volunteering", "Skills", "Awards"
      ],
      "keywords": ["Sociology", "Policy", "Case Study", "Qualitative"],
    },
    "Law & Legal Studies": {
      "template": "Professional",
      "sections": [
        "Contact Info", "Summary", "Education", "Moot Court",
        "Internships", "Research Projects", "Skills"
      ],
      "keywords": ["Legal Writing", "Debate", "Constitution", "Case Law"],
    },
    "Hospitality & Tourism": {
      "template": "Creative",
      "sections": [
        "Contact Info", "Summary", "Education", "Customer Service Experience",
        "Skills", "Awards"
      ],
      "keywords": ["Hospitality", "Customer Care", "Management", "Front Desk"],
    },
    "Agriculture & Environmental": {
      "template": "Modern",
      "sections": [
        "Contact Info", "Summary", "Education", "Field/Lab Experience",
        "Projects", "Skills", "Certifications"
      ],
      "keywords": ["Soil Analysis", "Lab Testing", "Environmental Impact"],
    },
    "General College Application": {
      "template": "Simple",
      "sections": [
        "Contact Info", "Objective", "Education", "Activities",
        "Skills", "Awards/Honors"
      ],
      "keywords": ["Scholarships", "Leadership", "Clubs", "Extracurriculars"],
    },
  };

  static var reference;
}

