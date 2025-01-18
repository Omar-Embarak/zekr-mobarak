import 'package:azkar_app/cubit/praying_cubit/praying_cubit.dart';
import 'package:azkar_app/database_helper.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../model/praying_model/praying_model/timings.dart';
import '../../widgets/build_prayer_details_widget.dart';
import '../../widgets/qibla_compass_widget.dart';

class PrayPage extends StatefulWidget {
  const PrayPage({super.key});

  @override
  State<PrayPage> createState() => _PrayPageState();
}

class _PrayPageState extends State<PrayPage> {
  double? latitude;
  double? longitude;
  final ScrollController scrollController = ScrollController();
  ConnectivityResult? _connectivityStatus;
  String? lastUpdate;
  String? timezoneName;
  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

    _initializeLocation();
  }

  Future<void> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();

    if (mounted) {
      setState(() {
        _connectivityStatus =
            connectivityResults.contains(ConnectivityResult.none)
                ? ConnectivityResult.none
                : connectivityResults.first;
      });
    }
  }

// Future<String?> getTimeZoneName(double latitude, double longitude) async {
//   try {
//     final String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key
//     final String url = 'https://maps.googleapis.com/maps/api/timezone/json?location=$latitude,$longitude&timestamp=${DateTime.now().millisecondsSinceEpoch ~/ 1000}&key=$apiKey';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'OK') {
//         return data['timeZoneId']; // Returns the timezone ID (like "Africa/Cairo")
//       }
//     }
//   } catch (e) {
//     print('Error fetching timezone: $e');
//   }
//   return null; // Return null if there's an error
// }

  /// Requests location permission and fetches the user's location.
  Future<void> _initializeLocation() async {
    if (await requestPermission(Permission.location)) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latitude = position.latitude;
        longitude = position.longitude;
        // timezoneName = await getTimeZoneName(latitude!, longitude!);

        // Fetch prayer times using cubit
        context.read<PrayingCubit>().getPrayerTimesByAddress(
              day: DateTime.now().day,
              year: "${DateTime.now().year}",
              month: "${DateTime.now().month}",
              latitude: latitude!,
              longitude: longitude!,
            );
      } catch (e) {
        showMessage('فشل الحصول علي الموقع');
      }
    } else {
      showMessage('رجاءا اسمح بالوصول للموقع');
    }
  }

  // Stream to update the next prayer time every second
  Stream<String> getNextPrayerTimeStream(String initialTime) async* {
    DateTime targetTime =
        DateTime.now(); // Replace with actual next prayer time
    while (true) {
      final now = DateTime.now();
      final timeDifference = targetTime.difference(now);

      yield timeDifference.isNegative
          ? "قُضيت الصلاة"
          : "${timeDifference.inMinutes} دقيقة متبقية";

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoBold20(context).color,
        ),
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: Text(
          "الصلاة",
          style: AppStyles.styleCairoBold20(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildPrayerInfoCard(context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              buildQiblahCompass(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the prayer information card.
  Widget _buildPrayerInfoCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.kSecondaryColor,
      ),
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PrayingCubit, PrayingState>(
        builder: (context, state) {
          /// Builds a details widget for prayer times.
          Widget buildDetailsWidget(
            BuildContext context,
            Timings timings,
            ScrollController scrollController,
          ) {
            final detailsWidget = buildPrayerDetails(
                context, timings, scrollController, lastUpdate);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  50.0,
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOut,
                );
              }
            });
            return detailsWidget;
          }

          /// Builds an error message widget.
          Widget buildErrorWidget(BuildContext context, String message) {
            return Text(
              message,
              style: AppStyles.styleCairoMedium15white(context),
              textAlign: TextAlign.center,
            );
          }

          if (state is PrayingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayingLoaded) {
            lastUpdate = 'الان';

            return buildDetailsWidget(
              context,
              state.timings,
              scrollController,
            );
          } else if (_connectivityStatus == ConnectivityResult.none) {
            return FutureBuilder<Map<String, String>?>(
              future: DatabaseHelper().getTimings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return buildErrorWidget(
                    context,
                    'حدث خطأ أثناء جلب بيانات الصلاة المحفوظة.',
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  lastUpdate = snapshot.data!['storedAt'];

                  final timings = Timings(
                    fajr: snapshot.data!['fajr'],
                    sunrise: snapshot.data!['sunrise'],
                    dhuhr: snapshot.data!['dhuhr'],
                    asr: snapshot.data!['asr'],
                    maghrib: snapshot.data!['maghrib'],
                    isha: snapshot.data!['isha'],
                  );
                  return buildDetailsWidget(
                    context,
                    timings,
                    scrollController,
                  );
                } else {
                  return buildErrorWidget(
                    context,
                    'لم يتم العثور على بيانات صلاة محفوظة.',
                  );
                }
              },
            );
          } else if (state is PrayingError) {
            return buildErrorWidget(context, state.error);
          } else {
            return buildErrorWidget(
              context,
              'لا يوجد بيانات متاحة للصلاة.',
            );
          }
        },
      ),
    );
  }
}
