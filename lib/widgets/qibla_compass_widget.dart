import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import '../pages/pray_page/qiplah_compass.dart';

Widget buildQiblahCompass(context) {
    return SingleChildScrollView(
      child: SizedBox(
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
      ),
    );
  }
