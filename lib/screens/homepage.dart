import 'package:flutter/material.dart';
import 'package:resume_fix/utils/routes/routes.dart'; // ✅ Route constants import

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Resume Builder",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "RESUMES",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.buildOptionPage);
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 📦 Illustration Icon
            Image.asset("assets/Icon/open-cardboard-box.png", height: 100),

            const SizedBox(height: 30),

            const Text(
              "Create New Resumes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 🎯 Action Buttons
            buildMainButton(
              text: "Start Building Resume",
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.fieldSelectionPage);
              },
            ),

            const SizedBox(height: 12),

            buildMainButton(
              text: "Edit Existing Resume",
              color: Colors.grey.shade800,
              onPressed: () {
                // TODO: Implement saved resume list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Coming Soon...")),
                );
              },
            ),

            const SizedBox(height: 12),

            buildMainButton(
              text: "Preview Resume",
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.resumePreviewPage);
              },
            ),

            const SizedBox(height: 12),

            buildMainButton(
              text: "Download PDF",
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.pdfScreenPage);
              },
            ),
            const SizedBox(height: 12),

buildMainButton(
  text: "SOP Evaluator",
  color: Colors.deepPurple,
  onPressed: () {
    Navigator.of(context).pushNamed(Routes.sopEvaluatorPage); // ✅ Make sure this route is defined
  },
),

          ],
        ),
      ),
    );
  }

  Widget buildMainButton({
    required String text,
    required VoidCallback onPressed,
    Color color = Colors.black,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
