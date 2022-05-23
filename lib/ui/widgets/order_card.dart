import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  String date;
  String sid;
  String oid;
  String status;

  OrderCard({
    required this.date,
    required this.sid,
    required this.oid,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white60,
          // leading: Image(
          //   image: NetworkImage(
          //       'https://jardin-secrets.com/image.php?/12435/photo-dracaena-fragrans_krzysztof-ziarnek.jpg'),
          // ),
          leading: Text(
            oid,
            style: TextStyle(fontSize: 17),
          ),
          title: Text("Order Date : ${date}"),
          // subtitle: Text(sid),
          style: ListTileStyle.list,
          trailing: Text(
            status,
            style: TextStyle(color: HPrimarycolor, fontWeight: FontWeight.w500),
          ),
        ),
        Divider()
      ],
    );
  }
}
