import 'package:flutter/material.dart';

class AppTheme {
  static const primaryGreen = Color(0xFF1A9357);
  static const lightGreen = Color(0xFF97DFC0);
  static const skyBlue = Color(0xFFB0DCF9);
  static const backgroundStart = Color(0xFFEDF9F3);
  static const backgroundEnd = Color(0xFFE3F4FC);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Rounded',
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Color(0x22228B22)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      );
}

class EcoBackground extends StatelessWidget {
  final Widget child;
  const EcoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _blob(220, AppTheme.lightGreen.withOpacity(0.28)),
        ),
        Positioned(
          top: -60,
          left: -80,
          child: _blob(190, AppTheme.skyBlue.withOpacity(0.24)),
        ),
        Positioned(
          bottom: 120,
          left: -40,
          child: Icon(Icons.eco, size: 72, color: Colors.green.withOpacity(0.10)),
        ),
        Positioned(
          bottom: 200,
          right: -20,
          child: Icon(Icons.water_drop, size: 52, color: Colors.blue.withOpacity(0.12)),
        ),
        Positioned(
          top: 220,
          right: 20,
          child: Icon(Icons.recycling, size: 60, color: Colors.green.withOpacity(0.10)),
        ),
        Positioned(
          top: 380,
          left: 10,
          child: Icon(Icons.public, size: 56, color: Colors.teal.withOpacity(0.10)),
        ),
        child,
      ],
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      );
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;

  const AppCard({super.key, required this.child, this.padding, this.color, this.elevation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }
}
