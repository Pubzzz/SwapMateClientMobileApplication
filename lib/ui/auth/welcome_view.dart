import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_provider.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_colors.dart';
import 'login_page/login.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: HPrimarycolor,
            ),
            onPressed: () {
              _makePhoneCall('tel://0779115101');
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "SwapMate",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: HPrimarycolor,
                    fontSize: size.height * 0.08),
              ),
              SizedBox(
                height: 24,
              ),
              SizedBox(
                  height: size.height * 0.45,
                  child: Image.asset(
                    "assets/images/woman.png",
                  )),
              SizedBox(height: size.height * 0.05),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: TextButton(
                      child: Text("LOGIN".toUpperCase(),
                          style: TextStyle(fontSize: 16)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(HWhite),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(HPrimarycolor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: HWhite)))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginProvider()),
                        );
                      }),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Center(
                child: Container(
                  width: 250,
                  height: 50,
                  child: TextButton(
                      child: Text("Signup".toUpperCase(),
                          style: TextStyle(fontSize: 16)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(HPrimarycolor),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(HWhite),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: HPrimarycolor)))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpProvider()),
                        );
                      }),
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
