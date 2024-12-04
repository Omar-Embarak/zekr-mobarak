import 'package:azkar_app/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database_helper.dart';

class ThemeCubit extends Cubit<String> {
  ThemeCubit() : super(defaultTheme) {
    _loadTheme(); // Load theme from database when cubit is initialized
  }

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Load the theme from database
  void _loadTheme() async {
    final themeMode = await _dbHelper.fetchTheme();
    if (themeMode == lightTheme || themeMode == darkTheme) {
      _updateTheme(themeMode!); // Emit the saved theme
    } else {
      _updateTheme(defaultTheme); // Default theme if no saved theme exists
    }
  }

  // Save and emit new theme
  void setTheme(String themeMode) async {
    _updateTheme(themeMode); // Emit new theme immediately
    await _dbHelper.saveTheme(themeMode); // Save to database
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    if (state == lightTheme) {
      setTheme(darkTheme);
    } else {
      setTheme(lightTheme);
    }
  }

  // Private helper to update theme and notify AppStyles
  void _updateTheme( themeMode) {
    AppColors.themeNotifier.value = themeMode; // Notify the theme change
    emit(themeMode); // Emit new state
  }
}
