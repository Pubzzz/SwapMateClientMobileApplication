import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/db/model/dress_size.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/db/model/user.dart';

import '../../db/model/item.dart';
import '../../db/model/order.dart';

@immutable
class RootState {
  final bool initialized;
  final User? currentUser;
  final List<SubUser>? profiles;
  final bool userLogged;
  final String? currentSize;
  final String? currentGender;
  final List<Item>? allItems;
  final List<Item>? currentUserItems;
  final List<SubUser>? currentSubUser;
  final List<DressSize> relatedSizes;
  final List<Order>? orders;
  final Map<String, dynamic> relatedSizeMap;
  final String type;
  final String authError;
  final String currentUserGender;
  final String currentUserSize;

  /////uservalues//////////

  final String firstName;
  final String lastName;
  final String address;
  final String? age;
  final String nic;
  final String contact;

  const RootState(
      {required this.initialized,
      this.currentUser,
      this.profiles,
      this.currentGender,
      this.currentSize,
      required this.userLogged,
      this.allItems,
      this.currentUserItems,
      this.currentSubUser,
      required this.relatedSizes,
      required this.relatedSizeMap,
      required this.type,
      required this.authError,
      required this.currentUserGender,
      required this.currentUserSize,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.contact,
      required this.age,
      required this.nic,
      this.orders});

  static RootState get initialState => const RootState(
        initialized: false,
        currentUser: null,
        profiles: null,
        userLogged: false,
        currentGender: null,
        currentSize: null,
        allItems: null,
        currentUserItems: null,
        currentSubUser: [],
        relatedSizes: [],
        relatedSizeMap: {"hip": 0, "chest": 0, "waist": 0},
        type: 'all',
        authError: '',
        currentUserGender: "Male",
        currentUserSize: "M",
        firstName: '',
        lastName: '',
        address: '',
        contact: '',
        nic: '',
        age: null,
        orders: null,
      );

  RootState clone({
    bool? initialized,
    User? currentUser,
    List<SubUser>? profiles,
    bool? userLogged,
    String? currentSize,
    String? currentGender,
    List<Item>? allItems,
    List<Item>? currentUserItems,
    List<SubUser>? currentSubUser,
    List<DressSize>? relatedSizes,
    Map<String, dynamic>? relatedSizeMap,
    String? type,
    String? authError,
    String? currentUserGender,
    String? currentUserSize,
    String? firstName,
    String? lastName,
    String? address,
    String? age,
    String? nic,
    String? contact,
    List<Order>? orders,
  }) {
    return RootState(
      initialized: initialized ?? this.initialized,
      currentUser: currentUser ?? this.currentUser,
      profiles: profiles ?? this.profiles,
      userLogged: userLogged ?? this.userLogged,
      currentGender: currentGender ?? this.currentGender,
      currentSize: currentSize ?? this.currentSize,
      allItems: allItems ?? this.allItems,
      currentUserItems: currentUserItems ?? this.currentUserItems,
      currentSubUser: currentSubUser ?? this.currentSubUser,
      relatedSizes: relatedSizes ?? this.relatedSizes,
      relatedSizeMap: relatedSizeMap ?? this.relatedSizeMap,
      type: type ?? this.type,
      authError: authError ?? this.authError,
      currentUserGender: currentUserGender ?? this.currentUserGender,
      currentUserSize: currentUserSize ?? this.currentUserSize,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      nic: nic ?? this.nic,
      age: age ?? this.age,
      orders: orders ?? this.orders,
    );
  }
}
