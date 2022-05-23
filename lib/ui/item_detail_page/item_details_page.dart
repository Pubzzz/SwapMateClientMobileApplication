import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swap_mate_mobile/ui/widgets/common_snack_bar.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_cubit.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../db/model/item.dart';
import '../../theme/app_colors.dart';

class ItemDetailsPage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final titleStyle = TextStyle(
    color: HPrimarycolor.withOpacity(0.6),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  final subtitleStyle = const TextStyle(
    color: HPrimarycolor,
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  final separator = Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    height: 1.2,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [HCatBak.withOpacity(0.3), HPrimarycolor.withOpacity(0.3)],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ItemDetailsCubit>(context);

    final scaffold = Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: HPrimarycolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<ItemDetailsCubit, ItemDetailState>(
          buildWhen: (pre, current) => pre.currentItem != current.currentItem,
          builder: (context, state) {
            if (state.currentItem == null) return loadingWidget;

            final List<String> imgList =
                List.from(state.currentItem?.pictures ?? []);

            final List<Widget> imageSliders = imgList
                .map((item) => Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        child: Image.network(
                          item,
                          fit: BoxFit.contain,
                          height: 200,
                          width: 300,
                        ),
                      ),
                    ))
                .toList();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: [
                  state.currentItem!.pictures.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: 350,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/cover2.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : state.currentItem!.pictures.length == 1
                          ? Container(
                              width: double.infinity,
                              height: 350,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      state.currentItem!.pictures.first),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 350,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 1.2,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: false,
                                ),
                                items: imageSliders,
                              ),
                            ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    title: Text(
                      "Dress Name",
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      state.currentItem!.name ?? '',
                      style: subtitleStyle,
                    ),
                  ),
                  separator,
                  ListTile(
                    title: Text(
                      "Dress Category",
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      state.currentItem!.category ?? '',
                      style: subtitleStyle,
                    ),
                  ),
                  separator,
                  ListTile(
                    title: Text(
                      "Point",
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      state.currentItem!.points ?? '',
                      style: subtitleStyle,
                    ),
                  ),
                  separator,
                  ListTile(
                    title: Text(
                      "Special Note",
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      state.currentItem!.notes!.isEmpty
                          ? '-'
                          : "${state.currentItem!.notes}",
                      style: subtitleStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cubit.addOrder();
                    },
                    child: const Text('Order Now'),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(HWhite),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(HPrimarycolor),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: const BorderSide(color: HPrimarycolor)))),
                  )
                ],
              ),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ItemDetailsCubit, ItemDetailState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.showErrorSnackBar(state.error));
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }
          },
        ),
        BlocListener<ItemDetailsCubit, ItemDetailState>(
          listenWhen: (pre, current) => pre.status != current.status,
          listener: (context, state) {
            if (state.status == 1) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.loadingSnackBar);
            } else if (state.status == 2) {
              Fluttertoast.showToast(msg: "Order added successfully");
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
