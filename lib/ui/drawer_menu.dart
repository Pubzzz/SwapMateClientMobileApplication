import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/util/routes.dart';
import 'package:swap_mate_mobile/ui/orders_page/orders_view.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_provider.dart';
import 'add_new_profile_page/add_new_profile_provider.dart';
import 'user_management_page/user_management_view.dart';
import 'add_new_profile_page/add_profile_view.dart';
import '../theme/app_colors.dart';
import 'auth/login_page/login.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final rootCubit = BlocProvider.of<RootCubit>(context);

    return Drawer(
      child: BlocBuilder<RootCubit, RootState>(
          buildWhen: (pre, current) => pre.currentUser != current.currentUser,
          builder: (context, state) {
            final user = state.currentUser;

            if (user == null) {
              return Container();
            }

            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    "${user.firstname} ${user.lastname}".toUpperCase(),
                    style: const TextStyle(fontSize: 17),
                  ),
                  accountEmail: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.email}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Points : ${user.points}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/pp.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: HPrimarycolor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      //sample cover photo
                      image: AssetImage("assets/images/cover2.jpg"),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_search_outlined,
                    color: HPrimarycolor,
                  ),
                  title: const Text(
                    'Manage Profile',
                    style: TextStyle(color: HPrimarycolor, fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserManagementProvider()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.person_add,
                    color: HPrimarycolor,
                  ),
                  title: const Text(
                    'Add Profile',
                    style: TextStyle(color: HPrimarycolor, fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewProfileProvider()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: HPrimarycolor,
                  ),
                  title: const Text(
                    'Showroom',
                    style: TextStyle(color: HPrimarycolor, fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.star_border,
                    color: HPrimarycolor,
                  ),
                  title: const Text(
                    'Ongoing Orders',
                    style: TextStyle(color: HPrimarycolor, fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersView(),
                          fullscreenDialog: true),
                    );
                  },
                ),
                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red, fontSize: 17),
                  ),
                  onTap: () async {
                    await rootCubit.handleUserLoggedOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.WELCOME_ROUTE, (route) => false);
                  },
                ),
              ],
            );
          }),
    );
  }
}
