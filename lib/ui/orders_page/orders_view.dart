import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/widgets/order_card.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';

import '../../theme/app_colors.dart';

class OrdersView extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Orders ',
          style: TextStyle(color: HPrimarycolor, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: HPrimarycolor),
      ),
      body: BlocBuilder<RootCubit, RootState>(
          buildWhen: (pre, current) => pre.orders != current.orders,
          builder: (context, state) {
            List<Widget> children = [];

            if (state.orders == null) {
              return loadingWidget;
            }

            for (int i = 0; i < state.orders!.length; i++) {
              final order = state.orders![i];
              final card = OrderCard(
                  date: order.date,
                  sid: order.showroomId,
                  oid: order.orderId,
                  status: order.status);
              children.add(card);
            }

            if (children.isEmpty) {
              return const Center(
                child: Text('No ongoing orders for you..'),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: children,
                  )),
                ],
              ),
            );
          }),
    );
  }
}
