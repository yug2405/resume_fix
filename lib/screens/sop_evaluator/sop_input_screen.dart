import 'package:flutter/material.dart';

class SopInputScreen extends StatefulWidget {
  const SopInputScreen({super.key});

  @override
  State<SopInputScreen> createState() => _SopInputScreenState();
}

class _SopInputScreenState extends State<SopInputScreen> {
  final TextEditingController sopController = TextEditingController();
  bool isLoading = false;

  void handleSubmitSOP() async {
    if (sopController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final sopText = sopController.text.trim();

    // TODO (in Step 3):
    // 1. Save to Firestore (as a new version)
    // 2. Send to Flask API for feedback
    // 3. Navigate to feedback screen

    await Future.delayed(const Duration(seconds: 2)); // temporary

    setState(() => isLoading = false);

    // For now show a dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('SOP Submitted'),
        content: const Text('This is a placeholder until we connect backend in next step.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOP Evaluator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Paste your Statement of Purpose below:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: sopController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Write or paste your SOP here...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : handleSubmitSOP,
              icon: isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  : const Icon(Icons.feedback_outlined),
              label: Text(isLoading ? 'Processing...' : 'Get Feedback'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}
