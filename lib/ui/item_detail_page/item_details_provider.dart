import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/db/model/item.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_cubit.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_page.dart';


class ItemDetailsProvider extends BlocProvider<ItemDetailsCubit> {
  ItemDetailsProvider({
    Key ?key,
    required Item currentItem,
  }) : super(
          key: key,
          create: (context) => ItemDetailsCubit(context, currentItem),
          child: ItemDetailsPage(),
        );
}
