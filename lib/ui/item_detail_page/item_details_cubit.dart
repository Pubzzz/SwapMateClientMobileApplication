import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swap_mate_mobile/db/db_util.dart';
import 'package:swap_mate_mobile/db/model/item.dart';
import 'package:swap_mate_mobile/db/repository/item_repository.dart';
import 'package:swap_mate_mobile/db/repository/order_repository.dart';
import 'package:swap_mate_mobile/db/repository/user_repository.dart';
import 'package:swap_mate_mobile/ui/item_detail_page/item_details_state.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';
import 'package:http/http.dart' as http;

import '../../db/model/order.dart';

class ItemDetailsCubit extends Cubit<ItemDetailState> {
  final RootCubit rootBloc;
  final _itemRepository = ItemRepository();
  final _orderRepository = OrderRepository();
  final _userRepository=UserRepository();


  ItemDetailsCubit(BuildContext context, Item item)
      : rootBloc = BlocProvider.of<RootCubit>(context),
        super(ItemDetailState.initialState) {
    var pre = RootState.initialState;

    changeCurrentItem(item);


    rootBloc.stream.listen((current) {
      // _rootBlocChanges(pre, current, item);
      pre = current;
    });
  }

  void _rootBlocChanges(RootState pre, RootState current, Item item) {
    if (current.allItems == null) {
      return;
    }

    if (pre.allItems == current.allItems) {
      return;
    }


    final data = current.allItems!
        .where((element) => element.ref == item.ref)
        .toList(growable: false);

    if (data.isEmpty) {
      return;
    }

    changeCurrentItem(data[0]);
  }

  changeCurrentItem(Item item) {
    emit(state.clone(currentItem: item));
  }

  Future<void> addOrder() async {
    emit(state.clone(status: 1));

    int number = 0;

    final formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(DateTime.now());

    final list = await _orderRepository.querySingle(
      spec: MultiQueryTransformer([]),
    );

    if (list.isNotEmpty) {
      number = list.length + 1;
    }

    try {

      final user=rootBloc.state.currentUser;

      final userPoints=int.parse(user!.points ?? "0");

      final dressPoint=int.parse(state.currentItem!.points ?? "0");



      if(userPoints < dressPoint){
        errorEvent('Sorry..you cant purchase this item..');
        return;
      }


      final order = Order(
        customerId: rootBloc.state.currentUser!.ref!.id,
        date: formattedDate,
        status: "In Progress",
        showroomId: state.currentItem!.ref!.id,
        orderId: number.toString(),
      );

      await _orderRepository.add(item: order, type: DBUtil.ORDERS);

      await _itemRepository.update(item: state.currentItem!,mapper: (_)=>{
        "isAvailable":false
      });


      await _userRepository.update(item: rootBloc.state.currentUser!,mapper: (_)=>{
        "points":(userPoints - dressPoint).toString()
      });



      emit(state.clone(status: 2));
      Future.delayed(const Duration(seconds: 2));
      emit(state.clone(status: 0));
    } catch (e) {
      errorEvent('Error occurred...Order added failed..');
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    _addErr(error);
    super.onError(error, stackTrace);
  }

  void _addErr(e) {
    if (e is StateError) {
      return;
    }
    try {
      errorEvent(
        (e is String)
            ? e
            : (e.message ?? "Something went wrong. Please try again !"),
      );
    } catch (e) {
      errorEvent("Something went wrong. Please try again !");
    }
  }

  void errorEvent(String error) {
    emit(state.clone(error: ''));
    emit(state.clone(error: error));
  }
}
