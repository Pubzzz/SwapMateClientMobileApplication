import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/db/model/user.dart';

import '../../db/model/item.dart';

@immutable
class ItemDetailState {
  final Item? currentItem;
  final int status;
  final String error;

  const ItemDetailState({
    required this.currentItem,
    required this.status,
    required this.error,
  });

  static ItemDetailState get initialState => const ItemDetailState(
        currentItem: null,
        status: 0,
        error: "",
      );

  ItemDetailState clone({
    Item? currentItem,
    int? status,
    String? error,
  }) {
    return ItemDetailState(
      currentItem: currentItem ?? this.currentItem,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
