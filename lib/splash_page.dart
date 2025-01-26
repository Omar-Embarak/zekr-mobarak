// Example of Animated App Icon
import 'package:flutter/material.dart';

class AppIconLoader extends StatefulWidget {
  const AppIconLoader({super.key});

  @override
  _AppIconLoaderState createState() => _AppIconLoaderState();
}

class _AppIconLoaderState extends State<AppIconLoader>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/images/ic_launcher.png', // Replace with your app icon path
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
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
