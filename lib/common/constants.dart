import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

// colors
const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color(0xFF003566);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);

// text style
TextStyle get kHeading5 {
  if (kIsWeb || kDebugMode && _isTestEnvironment) {
    return const TextStyle(fontSize: 23, fontWeight: FontWeight.w400);
  }
  return GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
}

TextStyle get kHeading6 {
  if (kIsWeb || kDebugMode && _isTestEnvironment) {
    return const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    );
  }
  return GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
}

TextStyle get kSubtitle {
  if (kIsWeb || kDebugMode && _isTestEnvironment) {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    );
  }
  return GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );
}

TextStyle get kBodyText {
  if (kIsWeb || kDebugMode && _isTestEnvironment) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    );
  }
  return GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
}

bool _isTestEnvironment = false;

void setTestEnvironment(bool value) {
  _isTestEnvironment = value;
}

// text theme
TextTheme get kTextTheme => TextTheme(
  headlineMedium: kHeading5,
  headlineSmall: kHeading6,
  labelMedium: kSubtitle,
  bodyMedium: kBodyText,
);

DrawerThemeData get kDrawerTheme =>
    DrawerThemeData(backgroundColor: Colors.grey.shade700);

const kColorScheme = ColorScheme(
  primary: kMikadoYellow,
  secondary: kPrussianBlue,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  error: Colors.red,
  onPrimary: kRichBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
