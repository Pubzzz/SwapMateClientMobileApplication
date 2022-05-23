import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopButton extends StatelessWidget {
  bool isActive = false;
  final String title;
  final VoidCallback? onPressed;

  TopButton({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isActive
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: OutlinedButton(
              onPressed: onPressed,
              child: Text(title),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: const TextStyle(
                 fontSize: 14,
                  fontWeight: FontWeight.w700
                ),
                primary:Color(0xFF003899),
                side: const BorderSide(
                  color: Color(0xFF003899),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              child: Text(title),
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF003899),
                shape: const StadiumBorder(),
                side: const BorderSide(
                  color: Color(0xFF003899),
                ),
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),
              ),

            ),
          );
  }
}
