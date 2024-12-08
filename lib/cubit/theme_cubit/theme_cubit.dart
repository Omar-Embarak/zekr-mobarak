import 'package:azkar_app/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database_helper.dart';
import '../../utils/app_style.dart';

class ThemeCubit extends Cubit<String> {
  ThemeCubit() : super(defaultTheme);

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Load the theme from database
  Future<void> loadInitialTheme() async {
    final themeMode = await _dbHelper.fetchTheme();
    _updateTheme(themeMode);
  }

  // Save and emit new theme
  void setTheme(String themeMode) async {
    _updateTheme(themeMode); // Emit new theme immediately
    await _dbHelper.saveTheme(themeMode); // Save to database
  }

  // Private helper to update theme and notify AppStyles
  void _updateTheme(themeMode) {
    AppStyles.themeNotifier.value = themeMode; // Notify the theme change
    emit(themeMode); // Emit new state
  }
}
