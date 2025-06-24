import 'package:flutter/material.dart';
import 'package:projectketiga/aplikasi/welcome_screen.dart';
import 'package:projectketiga/utils/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 void changePage(){
  Future.delayed(Duration(seconds: 3), () async {
    bool isLogin = await PreferenceHandler.getLogin();
    print("isLogin: $isLogin");
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (route)=> false,
      );
  });
 } 

 @override
 void initState(){
  changePage();
  super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/image/splash.jpg'),
            SizedBox(height: 20),
            Spacer(),
            SafeArea(
              child: Text("v 4.0.0", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10)),
              )
          ],
        ),
      ),
    );
  }
}