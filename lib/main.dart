import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management/firebase_options.dart';
import 'package:project_management/provider/theme_provider.dart';
import 'package:project_management/screens/authentication/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 255, 255),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 66, 66, 66),
);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        scaffoldBackgroundColor: kDarkColorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.tinos(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.tinos(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkColorScheme.onBackground,
          ),
          titleMedium: GoogleFonts.tinos(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kDarkColorScheme.onBackground,
          ),
          titleSmall: GoogleFonts.tinos(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: kDarkColorScheme.onBackground,
          ),
          bodyMedium: GoogleFonts.tinos(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: kDarkColorScheme.onBackground,
          ),
        ),
      ),

      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.tinos(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kColorScheme.onPrimaryContainer,
          ),
        ),
        
        textTheme: TextTheme(
          titleLarge: GoogleFonts.tinos(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.tinos(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          titleSmall: GoogleFonts.tinos(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.tinos(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      themeMode: themeMode,
      home: const Authenticate(),
    );
  }
}
