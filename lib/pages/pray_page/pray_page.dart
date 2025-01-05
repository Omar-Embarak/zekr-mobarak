import 'package:azkar_app/cubit/praying_cubit/praying_cubit.dart';
import 'package:azkar_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';
import '../../methods.dart';
import '../../widgets/build_prayer_details_widget.dart';
import '../../widgets/qibla_compass_widget.dart';

class ParyPage extends StatefulWidget {
  const ParyPage({super.key});

  @override
  State<ParyPage> createState() => _ParyPageState();
}

class _ParyPageState extends State<ParyPage> {
  double? latitude;
  double? longitude;
  final ScrollController scrollController = ScrollController();

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
        color: AppStyles.styleRajdhaniBold18(context).color,
      ),
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PrayingCubit, PrayingState>(
        builder: (context, state) {
          if (state is PrayingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayingLoaded) {
            // استدعاء `buildPrayerDetails`
            final detailsWidget =
                buildPrayerDetails(context, state.timings, scrollController);

            // إضافة PostFrameCallback لتنفيذ التمرير بعد بناء الواجهة
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  50.0, // التمرير إلى 50 بكسل
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOut,
                );
              }
            });

            return detailsWidget;
          } else if (state is PrayingError) {
            return Text(
              state.error,
              style: AppStyles.styleCairoMedium15white(context),
              textAlign: TextAlign.center,
            );
          } else {
            return Text(
              "لا يوجد داتا متاحة",
              style: AppStyles.styleCairoMedium15white(context),
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}
