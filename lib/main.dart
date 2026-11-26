import 'package:material_ui/material_ui.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GeoNotesApp());
}

class GeoNotesApp extends StatelessWidget {
  const GeoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoNotes AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryIndigo,
          primary: AppColors.primaryIndigo,
          secondary: AppColors.accentOrange,
        ),
        fontFamily: 'sans-serif',
      ),
      home: const LoginScreen(),
    );
  }
}
