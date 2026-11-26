import 'package:material_ui/material_ui.dart';

class AppColors {
  static const Color primaryIndigo = Color(0xFF4A37C8);
  static const Color primaryDeep = Color(0xFF311FA0);
  static const Color primaryLight = Color(0xFF5D4AE0);

  static const Color accentOrange = Color(0xFFFF7A00);
  static const Color accentOrangeLight = Color(0xFFFF9E2C);
  static const Color accentOrangeDark = Color(0xFFEA580C);

  static const Color surfaceWhite = Colors.white;
  static const Color inputBg = Color(0xFFF4F5F8);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color badgeGreenBg = Color(0xFFE6F9F0);
  static const Color badgeGreenText = Color(0xFF10B981);

  static const Color badgeAmberBg = Color(0xFFFEF3C7);
  static const Color badgeAmberText = Color(0xFFD97706);

  static const LinearGradient purpleBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4B39CF),
      Color(0xFF3928B2),
      Color(0xFF2B1B94),
    ],
  );

  static const LinearGradient orangeCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF7A00),
      Color(0xFFFF9A1F),
    ],
  );
}
