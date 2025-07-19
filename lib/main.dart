import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Import dotenv
import 'package:resume_fix/utils/routes/routes.dart'; // ✅ Your existing route import

Future<void> main() async {
  // ✅ Load the .env file before running the app
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: Routes.splashScreen,
      routes: Routes.myRoutes,
    ),
  );
}
