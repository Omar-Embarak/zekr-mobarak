import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:azkar_app/main.dart';
import 'package:azkar_app/model/azkar_model/azkar_model/azkar_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Prepare dummy Azkar data
    const String dummyAzkarJson = '''
    [
      {"id": 1, "title": "Azkar 1", "description": "Description 1"},
      {"id": 2, "title": "Azkar 2", "description": "Description 2"}
    ]
    ''';

    // Parse dummy Azkar data to a List<AzkarModel>
    final List<AzkarModel> preloadedAzkar = (jsonDecode(dummyAzkarJson) as List)
        .map((json) => AzkarModel.fromJson(json))
        .toList();

    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp(preloadedAzkar: preloadedAzkar));

    // Verify the initial state of the app.
    expect(find.text('0'), findsOneWidget); // Replace this with actual expectations if different
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify the counter has incremented.
    expect(find.text('0'), findsNothing); // Replace this with actual expectations if different
    expect(find.text('1'), findsOneWidget);
  });
}
