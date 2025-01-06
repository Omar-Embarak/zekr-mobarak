import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../model/praying_model/praying_model/timings.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> schedulePrayerNotifications(Timings timings) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Set local time zone
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Prayer times and corresponding sounds
    Map<String, String?> prayers = {
      "الفجر": timings.fajr,
      "الظهر": timings.dhuhr,
      "العصر": timings.asr,
      "المغرب": timings.maghrib,
      "العشاء": timings.isha,
    };

    Map<String, String> soonSounds = {
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

        // Notification for "soon" time (5 minutes before)
        await _scheduleNotification(
          notificationId++,
          entry.key,
          'اقتربت صلاة ${entry.key}',
          prayerTime.subtract(const Duration(minutes: 5)),
          soonSounds[entry.key]!.split('.').first,
        );

        // Notification for "now" time
        await _scheduleNotification(
          notificationId++,
          entry.key,
          'حان الآن وقت صلاة ${entry.key}',
          prayerTime,
          'call', // "call.mp3" for the Adhan
        );

        // Notification for "Iqamah" time (15 minutes after)
        await _scheduleNotification(
          notificationId++,
          entry.key,
          'اقامت صلاة ${entry.key}',
          prayerTime.add(const Duration(minutes: 15)),
          'establish', // "establish.mp3" for Iqamah
        );
      }
    }
  }

  static Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledTime,
    String sound,
  ) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'prayer_notification_channel',
      'Prayer Notifications',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(sound),
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
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static tz.TZDateTime _convertToTZDateTime(String time, tz.TZDateTime now) {
    final parts = time.split(':');
    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }

  // Function to test notification sound immediately
  static Future<void> testNotificationSound() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'prayer_notification_channel',
        'Prayer Notifications',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('call'), // Use "call.mp3"
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        0,
        'اختبار الإشعارات',
        'هذا إشعار اختبار مع صوت مخصص.',
        notificationDetails,
      );
      debugPrint('Notification triggered successfully!');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
