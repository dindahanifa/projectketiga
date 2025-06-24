import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/welcome.png', fit: BoxFit.cover)),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white)),
                      backgroundColor: Color(0xFF0b1d51)
                      ),
                    onPressed: () {
                    }, 
                    child: Text('Sudah memiliki akun', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white))),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        
                      }, 
                    style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white)
                    ),
                    backgroundColor:  Color(0xFF0b1d51),
                    ),
                    child: Text('Belum memiliki akun', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white))
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              ),
        ],
      ),
    );
  }
}