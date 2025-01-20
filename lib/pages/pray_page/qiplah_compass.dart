import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants.dart';
import '../../utils/app_style.dart';
import 'location_error_widget.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key});

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();
  // late ConnectivityResult _connectivityStatus;

  @override
  void initState() {
    super.initState();
    _initializeLocationStream();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    // final List<ConnectivityResult> connectivityResults =
    //     await Connectivity().checkConnectivity();

    // if (mounted) {
    //   setState(() {
    //     _connectivityStatus =
    //         connectivityResults.contains(ConnectivityResult.none)
    //             ? ConnectivityResult.none
    //             : connectivityResults.first;
    //   });
    // }
  }

  Future<void> _initializeLocationStream() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
    }
    _locationStreamController.sink
        .add(await FlutterQiblah.checkLocationStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<LocationStatus>(
        stream: _locationStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          }
          if (snapshot.data?.enabled == true) {
            return _buildLocationPermissionContent(snapshot.data!.status);
          } else {
            return LocationErrorWidget(
              error: "الرجاء تفعيل خدمة الموقع",
              callback: _initializeLocationStream, // Retry logic
            );
          }
        },
      ),
    );
  }

  Widget _buildLocationPermissionContent(LocationPermission status) {
    switch (status) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return const QiblahCompassWidget();
      case LocationPermission.denied:
        return LocationErrorWidget(
          error: "تم رفض الوصول إلى الموقع",
          callback: _initializeLocationStream,
        );
      case LocationPermission.deniedForever:
        return LocationErrorWidget(
          error: "تم رفض الوصول إلى الموقع بشكل دائم",
          callback: _initializeLocationStream,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Text('حدث خطأ أثناء التحميل...');
        }

        final qiblahDirection = snapshot.data!;
        final angle = qiblahDirection.direction * (pi / 180) * -1;
        final qibla = qiblahDirection.qiblah * (pi / 180) * -1;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: angle,
              child: SvgPicture.asset(
                'assets/compass.svg',
                colorFilter: AppStyles.themeNotifier.value == darkTheme
                    ? ColorFilter.mode(Colors.grey[200]!, BlendMode.srcIn)
                    : null,
              ),
            ),
            Transform.rotate(
              angle: qibla,
              child: SvgPicture.asset(
                'assets/needle.svg',
              ),
            ),
          ],
        );
      },
    );
  }
}
