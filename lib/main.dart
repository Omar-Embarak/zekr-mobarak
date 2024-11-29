import 'package:azkar_app/cubit/add_fav_surahcubit/add_fav_surah_item_cubit.dart';
import 'package:azkar_app/cubit/ruqiya_cubit/ruqiya_cubit.dart';
import 'package:azkar_app/pages/droos_pages/fav_dars_provider.dart';
import 'package:azkar_app/simple_bloc_observer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'cubit/azkar_cubit/azkar_cubit.dart';
import 'cubit/praying_cubit/praying_cubit.dart';
import 'pages/home_page/home_page.dart';
import 'pages/quran_pages/book_mark_provider.dart';
import 'pages/quran_pages/quran_data_provider.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
               ChangeNotifierProvider(create: (_) => QuranDataProvider()),
               ChangeNotifierProvider(create: (_) => FavDarsProvider()),

        BlocProvider(
          create: (context) => AddFavSurahItemCubit(),
        ),
        BlocProvider(
          create: (context) => AzkarCubit(),
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
          appBarTheme:
              const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
          fontFamily: "Cairo",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePages(),
      ),
    );
  }
}
