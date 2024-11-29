import 'package:azkar_app/cubit/praying_cubit/praying_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import '../../methods.dart';
import 'qiplah_compass.dart';

class ParyPage extends StatefulWidget {
  const ParyPage({super.key});

  @override
  State<ParyPage> createState() => _ParyPageState();
}

class _ParyPageState extends State<ParyPage> {
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Requests location permission and fetches the user's location.
  Future<void> _initializeLocation() async {
    if (await requestPermission(Permission.location)) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latitude = position.latitude;
        longitude = position.longitude;

        // Fetch prayer times using cubit
        context.read<PrayingCubit>().getPrayerTimesByAddress(
              year: "${DateTime.now().year}",
              month: "${DateTime.now().month}",
              latitude: latitude!,
              longitude: longitude!,
            );
      } catch (e) {
        showMessage('فشل الحصول علي الموقع: $e');
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
        backgroundColor: AppColors.kSecondaryColor,
        centerTitle: true,
        title: const Text(
          "الصلاة",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildPrayerInfoCard(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _buildQiblahCompass(),
          ],
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
          if (state is PrayingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayingLoaded) {
            return _buildPrayerDetails(context, state);
          } else if (state is PrayingError) {
            return Text(
              state.error,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              "لا يوجد داتا متاحة",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }

  /// Displays detailed prayer information.
  Widget _buildPrayerDetails(BuildContext context, PrayingLoaded state) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Image.asset(
                "assets/images/next_prayer.png",
                height: 50,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "صلاة ${state.nextPrayerName}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.kSecondaryColor,
                    ),
                  ),
                  Text(
                    state.nextPraying,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.kSecondaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildPrayerTimes(state),
          ),
        ),
      ],
    );
  }

  /// Builds prayer times columns.
  List<Widget> _buildPrayerTimes(PrayingLoaded state) {
    final prayerTimes = [
      {"name": "الفجر", "time": state.timings.fajr},
      {"name": "الظهر", "time": state.timings.dhuhr},
      {"name": "العصر", "time": state.timings.asr},
      {"name": "المغرب", "time": state.timings.maghrib},
      {"name": "العشاء", "time": state.timings.isha},
    ];

    return prayerTimes
        .map(
          (prayer) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  prayer["name"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  prayer["time"]!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  /// Builds the Qiblah Compass widget.
  Widget _buildQiblahCompass() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FutureBuilder(
        future: FlutterQiblah.androidDeviceSensorSupport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطا ما: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const QiblaCompass();
          } else {
            return const Text(
              'الجهاز لا يدعم القبلة, استخدم جهاز احدث',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}
