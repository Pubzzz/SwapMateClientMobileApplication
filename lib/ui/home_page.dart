import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:swap_mate_mobile/db/model/item.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/ui/cons/categories.dart';
import 'package:swap_mate_mobile/util/routes.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_page.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_provider.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_provider.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_view.dart';

import '../theme/app_colors.dart';
import 'widgets/item_card.dart';
import 'widgets/top_button.dart';
import 'drawer_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    super.initState();
  }

  var on = const Color(0xFFFFFFFF);
  var off = const Color(0xFF003899);
  bool val = true;

  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final rootCubit = BlocProvider.of<RootCubit>(context);

    Size size = MediaQuery.of(context).size;
    final scaffold = Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'SwapMate',
          style: TextStyle(color: HPrimarycolor, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.segment,
            color: HPrimarycolor,
            size: 27,
          ),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
        actions: [
          BlocBuilder<RootCubit, RootState>(
              buildWhen: (previous, current) =>
                  previous.profiles != current.profiles ||
                  previous.currentUser != current.currentUser ||
                  previous.currentSubUser != current.currentSubUser,
              builder: (context, state) {
                if (state.profiles == null) {
                  return Container();
                }

                if (state.profiles!.isEmpty) {
                  return Container();
                }

                final isActive = state.currentSubUser?.isNotEmpty;

                return PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.account_circle,
                    color: HPrimarycolor,
                    size: 30,
                  ),
                  itemBuilder: (BuildContext context) {
                    final list = state.profiles!.map((SubUser user) {
                      return PopupMenuItem<String>(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              color: HPrimarycolor,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                "${user.firstname} ${user.lastname}",
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            if (state.currentSubUser!.length == 1 &&
                                user.ref == state.currentSubUser?.first.ref &&
                                isActive!)
                              const Icon(
                                Icons.brightness_1,
                                color: Colors.green,
                                size: 12,
                              ),
                          ],
                        ),
                        onTap: () {
                          rootCubit.changeUserProfile(user);
                        },
                      );
                    }).toList();

                    list.add(
                      PopupMenuItem<String>(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.red,
                                size: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Back to Account",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: HPrimarycolor),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          rootCubit.backToMainProfile();
                        },
                      ),
                    );
                    return list;
                  },
                );
              }),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SizedBox(
        width: double.infinity,
        child: BlocBuilder<RootCubit, RootState>(
          buildWhen: (previous, current) =>
              previous.currentUserItems != current.currentUserItems ||
              previous.allItems != current.allItems ||
              previous.type != current.type ||
              previous.currentUser != current.currentUser ||
              previous.currentSubUser != current.currentSubUser,
          builder: (context, state) {
            if (state.currentUserItems == null || state.currentUser == null) {
              return loadingWidget;
            }

            List categories = [];
            List<Widget> children = [];

            if (state.currentSubUser!.isNotEmpty) {
              final subUser = state.currentSubUser!.first;

              final gender2 = subUser.gender;
              final age = subUser.age;

              final wearType = gender2 == 'Male' ? "Male" : "Female";

              if (age! < 12) {
                categories.addAll(Categories.kids);
              } else {
                if (wearType == "Male") {
                  categories.addAll(Categories.mens);
                } else if (wearType == "Female") {
                  categories.addAll(Categories.ladies);
                } else {}
              }
            } else {
              if (state.currentUser!.age! < 12) {
                categories.addAll(Categories.kids);
              } else {
                if (state.currentUser!.gender! == "Male") {
                  categories.addAll(Categories.mens);
                } else {
                  categories.addAll(Categories.ladies);
                }
              }
            }

            final list = <Item>[];

            if (state.type == 'all') {
              list.addAll(state.currentUserItems!);
            } else if (state.type == 'General') {
              final l = List<Item>.from(state.currentUserItems ?? []);
              final filterItems = l.where((element) =>
                  element.size == "General" || element.category == "General");
              list.addAll(filterItems);
            } else {
              final l = List<Item>.from(state.currentUserItems ?? []);
              final filterItems =
                  l.where((element) => element.name == state.type);
              list.addAll(filterItems);
            }

            for (int i = 0; i < categories.length; i++) {
              final btn = TopButton(
                title: categories[i]['name'],
                isActive: state.type == categories[i]['key'] ? true : false,
                onPressed: () {
                  rootCubit.changeType(categories[i]['key']);
                },
              );

              children.add(btn);
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: SizedBox(
                    height: size.height * 0.05,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TopButton(
                          title: 'For you',
                          isActive: state.type == "all" ? true : false,
                          onPressed: () {
                            rootCubit.changeType("all");
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                          child: const VerticalDivider(
                            color: HGrey,
                            thickness: 2,
                            width: 20,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ),
                        ...children
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                if (state.currentUserItems!.isNotEmpty)
                  if (list.isNotEmpty)
                    Expanded(
                      child: AlignedGridView.count(
                        itemCount: list.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 0,
                        itemBuilder: (context, index) {
                          return ItemCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailsProvider(
                                    currentItem: list[index],
                                  ),
                                ),
                              );
                            },
                            title: list[index].name,
                            img: list[index].pictures.isNotEmpty
                                ? list[index].pictures[0]
                                : null,
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Text('No Items found for you.'),
                      ),
                    )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text('No Items to Show'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<RootCubit, RootState>(
          listenWhen: (pre, current) =>
              pre.currentUser?.ref != current.currentUser?.ref ||
              pre.userLogged != current.userLogged,
          listener: (context, state) async {
            if (state.currentUser == null) {
              await rootCubit.handleUserLoggedOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.WELCOME_ROUTE, (route) => false);
            } else {
              print(state.currentUser!.isProfileCompleted);
              if (!state.currentUser!.isProfileCompleted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserManagementProvider(),
                  ),
                );
              }
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
