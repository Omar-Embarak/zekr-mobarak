import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:azkar_app/cubit/fav_surah_cubit/fav_surah_item_cubit.dart';
import 'package:azkar_app/cubit/ruqiya_cubit/ruqiya_cubit.dart';
import 'package:azkar_app/pages/islamic_lessons_pages/fav_islamic_lessons_provider.dart';
import 'package:azkar_app/simple_bloc_observer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'cubit/azkar_cubit/azkar_cubit.dart';
import 'cubit/praying_cubit/praying_cubit.dart';
import 'cubit/theme_cubit/theme_cubit.dart';
import 'model/azkar_model/azkar_model/azkar_model.dart';
import 'pages/azkar_pages/notification_service.dart';
import 'pages/home_page/home_page.dart';
import 'pages/quran_pages/book_mark_provider.dart';
import 'pages/quran_pages/quran_data_provider.dart';
import 'pages/quran_pages/quran_font_size_provider.dart';
import 'pages/sevices/audio_handler.dart';
import 'splash_page.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
Future<List<AzkarModel>> loadResources() async {
  final String jsonContent =
      await rootBundle.loadString('assets/db/adhkar.json');
  final jsonData = jsonDecode(jsonContent) as List;
  return jsonData.map((json) => AzkarModel.fromJson(json)).toList();
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $errorMessage'),
      ),
    );
  }
}

late AudioPlayerHandler globalAudioHandler;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final db = await DatabaseHelper().database;
  // await db.close();
  // Initialize database factory for desktop platforms
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize notification service
  await NotificationService.init();

  await ThemeCubit().loadInitialTheme();
  Bloc.observer = SimpleBlocObserver();
  // Initialize the global audio handler.
  globalAudioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.omar.zekr_mobarak.channel.audio',
      androidNotificationChannelName: 'تشغيل القرآن',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_notification',
      notificationColor: Color(0xff6a564f),
    ),
  );

  runApp(
    FutureBuilder(
      future: loadResources(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppIconLoader(); // Use your animated app icon here
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: ErrorScreen(snapshot.error.toString()),
          );
        }
        return MyApp(preloadedAzkar: snapshot.data as List<AzkarModel>);
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.preloadedAzkar});
  final List<AzkarModel> preloadedAzkar;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuranDataProvider()),
        ChangeNotifierProvider(create: (_) => FavDarsProvider()),
        ChangeNotifierProvider(create: (_) => QuranFontSizeProvider()),
        BlocProvider(
          create: (_) => ThemeCubit()..loadInitialTheme(),
        ),
        BlocProvider(
          create: (context) => FavSurahItemCubit(),
        ),
        BlocProvider(
          create: (context) => AzkarCubit(preloadedAzkar),
        ),
        BlocProvider(
          create: (context) => RuqiyaCubit(),
        ),
        BlocProvider(
          create: (context) => PrayingCubit(),
        ),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ],
      child: MaterialApp(
        navigatorKey: globalNavigatorKey, // Attach the global navigator key

        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("ar", "AE"),
        ],
        // locale: const Locale("ar", "AE"),
        debugShowCheckedModeBanner: false,
        title: 'Azkar App',
        theme: ThemeData(
          fontFamily: "Cairo",
          useMaterial3: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        home: const HomePages(),
      ),
    );
  }
}
