import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'signin.dart';
import 'home.dart';
import 'find_doctor.dart';
import 'doctors_list.dart';
import 'profile.dart';
import 'settings.dart';
import 'doctor_details.dart';
import 'signup.dart';
import 'theme/colors.dart';
import 'splash_screen.dart'; // ✅ Add this import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Finder',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryBlue,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryBlue,
          secondary: AppColors.healingGreen,
          error: AppColors.emergencyRed,
          surface: AppColors.background,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textDark),
          bodyMedium: TextStyle(color: AppColors.textGray),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      locale: const Locale('ar', ''), // ✅ Fixed typo "ars"
      // Start at splash screen
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/find_doctor': (context) => const FindDoctorPage(),
        '/doctors_list': (context) => const DoctorsListPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/clinic_details') {
          final clinic = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ClinicDetailsPage(clinic: clinic),
          );
        }
        return null;
      },
    );
  }
}
