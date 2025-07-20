import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- ye import add kiya
import 'dart:convert';

class SoPEvaluatorScreen extends StatefulWidget {
  const SoPEvaluatorScreen({super.key});

  @override
  State<SoPEvaluatorScreen> createState() => _SoPEvaluatorScreenState();
}

class _SoPEvaluatorScreenState extends State<SoPEvaluatorScreen> {
  final TextEditingController _sopController = TextEditingController();
  String? feedback;
  String? plagiarismScore;
  bool isLoading = false;

  final String openRouterApiKey = dotenv.env['OPENROUTER_API_KEY']!;
  final String rapidApiKey = dotenv.env['RAPIDAPI_KEY']!;

  Future<void> evaluateSOP() async {
    final text = _sopController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please paste your SOP before evaluating"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      feedback = null;
      plagiarismScore = null;
    });

    await Future.wait([_getSOPFeedback(text), _checkPlagiarism(text)]);
    setState(() => isLoading = false);
  }

  Future<void> _getSOPFeedback(String text) async {
    final prompt =
        """
You are an admissions officer at a top university.
Please evaluate the following Statement of Purpose (SOP) on:

1. Clarity (0–10)
2. Motivation (0–10)
3. Originality (0–10)

Also suggest 2–3 specific improvements.

SOP:
$text
""";

    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openRouterApiKey",
          "HTTP-Referer": "https://yourappname.com",
          "X-Title": "SOP Evaluator App",
        },
        body: jsonEncode({
          "model": "mistralai/devstral-small-2505",
          "messages": [
            {"role": "system", "content": "You are a helpful SOP evaluator."},
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() => feedback = reply.trim().replaceAll("**", ""));
      } else {
        setState(
          () => feedback =
              "❌ SOP Evaluation failed.\nStatus: ${response.statusCode}\n${response.body}",
        );
      }
    } catch (e) {
      setState(() => feedback = "❌ SOP Evaluation Error: $e");
    }
  }

  Future<void> _checkPlagiarism(String text) async {
    final url = Uri.parse(
      "https://plagiarism-source-checker-with-links.p.rapidapi.com/data",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-rapidapi-host':
              'plagiarism-source-checker-with-links.p.rapidapi.com',
          'x-rapidapi-key': rapidApiKey,
        },
        body: {'text': text},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final links = result['duplicate_content_found_on_links'];

        if (result['status'] == "duplicate_content_found" &&
            links is List &&
            links.isNotEmpty) {
          int estimatedScore = (links.length * 10).clamp(0, 100);
          setState(() => plagiarismScore = "$estimatedScore%");
        } else {
          setState(() => plagiarismScore = "0% (No Matches Found)");
        }
      } else {
        setState(() => plagiarismScore = "❌ Failed (${response.statusCode})");
      }
    } catch (e) {
      setState(() => plagiarismScore = "❌ Error: $e");
    }
  }

  @override
  void dispose() {
    _sopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOP Evaluator"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "📄 Paste your SOP below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sopController,
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Paste your SOP content here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : evaluateSOP,
              icon: const Icon(Icons.analytics_outlined),
              label: Text(isLoading ? "Evaluating..." : "Evaluate SOP"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading && (feedback != null || plagiarismScore != null))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plagiarismScore != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "🧬 Plagiarism Score: $plagiarismScore",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              (int.tryParse(
                                        plagiarismScore!.replaceAll('%', ''),
                                      ) ??
                                      0) >
                                  20
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  if (feedback != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        feedback!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
