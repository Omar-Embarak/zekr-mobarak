import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import '../../model/praying_model/praying_model/timings.dart';
import 'package:intl/intl.dart';
import '../pray_page/pray_page.dart';
import 'azkar_main_page.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final context = globalNavigatorKey.currentContext!;
          if (details.payload == 'اذكار') {
            // Navigate to AzkarPage
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AzkarPage(),
            ));
          } else {
            // Navigate to PrayPage
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const PrayPage(),
            ));
          }
        }
      },
    );
  }

  static Future<void> schedulePrayerNotifications(Timings timings) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    Map<String, String?> prayers = {
      "الفجر": timings.fajr,
      "الظهر": timings.dhuhr,
      "العصر": timings.asr,
      "المغرب": timings.maghrib,
      "العشاء": timings.isha,
    };

    Map<String, String> prayerSounds = {
      "الفجر": "fajr_soon.mp3",
      "الظهر": "dhuhr_soon.mp3",
      "العصر": "asr_soon.mp3",
      "المغرب": "maghrib_soon.mp3",
      "العشاء": "isha_soon.mp3",
    };

    int notificationId = 0;

    for (var entry in prayers.entries) {
      if (entry.value != null) {
        final tz.TZDateTime prayerTime =
            _convertToTZDateTime(entry.value!, now);

        // Daily notifications for prayer times
        await _scheduleDailyNotification(
          notificationId++,
          entry.key,
          'اقتربت صلاة ${entry.key}',
          prayerTime.subtract(const Duration(minutes: 5)),
          prayerSounds[entry.key]!.split('.').first,
          payload: 'صلاة',
        );

        await _scheduleDailyNotification(
          notificationId++,
          entry.key,
          'حان الآن وقت صلاة ${entry.key}',
          prayerTime,
          'call',
          payload: 'صلاة',
        );

        await _scheduleDailyNotification(
          notificationId++,
          entry.key,
          'اقامت صلاة ${entry.key}',
          prayerTime.add(const Duration(minutes: 15)),
          'establish',
          payload: 'صلاة',
        );
      }
    }

    // Add custom Zekr notifications
    if (timings.asr != null) {
      await _scheduleDailyNotification(
        notificationId++,
        'أذكار المساء',
        'وقت قراءة أذكار المساء',
        _convertToTZDateTime(timings.asr!, now).add(const Duration(hours: 1)),
        'default',
        payload: 'اذكار',
      );
    }

    if (timings.sunrise != null) {
      await _scheduleDailyNotification(
        notificationId++,
        'أذكار الصباح',
        'وقت قراءة أذكار الصباح',
        _convertToTZDateTime(timings.sunrise!, now)
            .add(const Duration(hours: 1)),
        'default',
        payload: 'اذكار',
      );
    }

    await _scheduleDailyNotification(
      notificationId++,
      'أذكار النوم',
      'وقت قراءة أذكار النوم',
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 0, 0),
      'default',
      payload: 'اذكار',
    );

    await _scheduleDailyNotification(
      notificationId++,
      'أذكار الاستيقاظ',
      'وقت قراءة أذكار الاستيقاظ',
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0),
      'default',
      payload: 'اذكار',
    );
  }

  static Future<void> _scheduleDailyNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledTime,
    String sound, {
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'notification_channel_$id',
      'Notifications $title',
      channelDescription: 'Notifications for $title',
      importance: Importance.max,
      priority: Priority.high,
      sound: sound == 'default'
          ? null
          : RawResourceAndroidNotificationSound(sound),
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload, // Pass payload for navigation
    );
  }

  static tz.TZDateTime _convertToTZDateTime(String time, tz.TZDateTime now) {
    String cleanedTime = time.replaceAll(RegExp(r'\s*\(.*\)'), '').trim();
    DateFormat inputFormat = DateFormat("HH:mm");
    DateTime dateTime = inputFormat.parse(cleanedTime);

    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dateTime.hour,
      dateTime.minute,
    );

    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }
}
