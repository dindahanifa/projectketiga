import 'package:flutter/material.dart';
import 'package:projectketiga/aplikasi/welcome_screen.dart';
import 'package:projectketiga/utils/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changePage();
  }

  void changePage() async {
    await Future.delayed(Duration(seconds: 3));
    bool isLogin = await PreferenceHandler.getLogin();
    print("isLogin: $isLogin");
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => WelcomeScreen()), 
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('assets/image/splash.jpg'),
            const SizedBox(height: 20),
            const Spacer(),
            const SafeArea(
              child: Text(
                "v 4.0.0",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
