import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/theme/app_colors.dart';

class newPw extends StatefulWidget {
  const newPw({Key? key}) : super(key: key);

  @override
  _newPwState createState() => _newPwState();
}

class _newPwState extends State<newPw> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Create a new Password",
                  style: TextStyle(
                    fontSize: 25,
                    color: HPrimarycolor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
