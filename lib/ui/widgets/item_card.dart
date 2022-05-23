import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String? img;
  final String? title;
  final int? rate;
  GestureTapCallback? onTap;

  ItemCard({
    Key? key,
    this.title = "Placeholder Title",
    this.img,
    this.rate,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height * 0.3,
              width: 160,
              decoration: BoxDecoration(
                image: img != null
                    ? DecorationImage(
                        image: NetworkImage(img!),
                        fit: BoxFit.contain,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/apparel.png'),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
