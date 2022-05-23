import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/db/authentication.dart';
import 'package:swap_mate_mobile/db/db_util.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/db/repository/item_repository.dart';
import 'package:swap_mate_mobile/db/repository/order_repository.dart';
import 'package:swap_mate_mobile/db/repository/sub_user_repository.dart';
import 'package:swap_mate_mobile/db/repository/user_repository.dart';
import 'package:swap_mate_mobile/ui/cons/default_sizes.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';

import '../../db/model/item.dart';
import '../../db/model/user.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit(BuildContext context) : super(RootState.initialState);

  final _userRepository = UserRepository();
  final _subUserRepository = SubUserRepository();
  final _itemRepository = ItemRepository();
  final _orderRepository = OrderRepository();
  final auth = Authentication();

  void initialize() async {
    if (state.initialized) {
      return;
    }
    await Firebase.initializeApp();
    emit(state.clone(initialized: true));
  }

  void _getUsersByEmail(final String email) {
    _userRepository
        .query(
            spec: MultiQueryTransformer(
                [ComplexWhere('email', isEqualTo: email)]))
        .listen((users) {
      users.isNotEmpty ? _changeCurrentUser(users.first) : null;
    });
  }

  void _getSubUsers(User user) {
    _subUserRepository
        .query(spec: MultiQueryTransformer([]), parent: user.ref)
        .listen((subUsers) {
      subUsers.isNotEmpty ? _changeSubUsers(subUsers.toList()) : null;
    });
  }

  _changeSubUsers(List<SubUser> users) {
    emit(state.clone(profiles: users));
  }

  void handleUserLogged(String email) {
    if (state.userLogged) {
      return;
    }
    emit(state.clone(userLogged: true));
    _getUsersByEmail(email);
  }

  bool isUserAvailable() {
    if (state.currentUser == null) {
      return false;
    }
    return true;
  }

  changeUserProfile(SubUser user) {
    emit(state.clone(currentSubUser: [user]));
    _getItems();
  }

  backToMainProfile() {
    emit(state.clone(currentSubUser: []));
    _getItems();
  }

  _changeCurrentUser(User user) {
    emit(state.clone(
      currentUser: user,
      firstName: user.firstname,
      lastName: user.lastname,
      nic: user.nic,
      contact: user.contact,
      address: user.address,
      age: user.age?.toString() ?? '',
      currentUserGender: user.gender ?? "Male",
    ));

    _getSubUsers(user);
    _changeUserOrders(user.ref!.id);
    _getItems();
    changeCurrentUserRelatedSizeMap(user.size, user.age, user.gender);
  }

  changeCurrentUserGender(String gender) {
    emit(state.clone(currentUserGender: gender));
  }

  void _getItems() {
    _itemRepository.query(spec: MultiQueryTransformer([])).listen((event) {
      emit(state.clone(allItems: event.toList(growable: false)));
      changeCurrentUserItem(event.toList(growable: false));
    });
  }

  void changeRelatedSizes(String age, String gender) {
    if (int.parse(age) < 12) {
      emit(state.clone(relatedSizes: DefaultSizes.kidsDefault));
      return;
    } else if (gender == 'Male') {
      emit(state.clone(relatedSizes: DefaultSizes.mensDefault));
      return;
    } else {
      emit(state.clone(relatedSizes: DefaultSizes.ladiesDefault));
      return;
    }
  }

  void changeCurrentUserRelatedSizeMap(String? size, int? age, String? gender) {
    if (size == '' && age == null && gender == '') {
      emit(state.clone(
          relatedSizes: DefaultSizes.mensDefault, currentUserGender: 'Male'));
      final current =
          state.relatedSizes.where((element) => element.id == "M").first;
      emit(
        state.clone(relatedSizeMap: {
          'hip': current.hip,
          "chest": current.chest,
          'waist': current.waist,
        }),
      );
      return;
    } else {
      if (age! < 12) {
        emit(state.clone(relatedSizes: DefaultSizes.kidsDefault));
      } else if (gender == 'Male') {
        emit(state.clone(relatedSizes: DefaultSizes.mensDefault));
      } else {
        emit(state.clone(relatedSizes: DefaultSizes.ladiesDefault));
      }
    }

    final current =
        state.relatedSizes.where((element) => element.id == size).first;

    emit(state.clone(currentUserSize: size));
    emit(
      state.clone(relatedSizeMap: {
        'hip': current.hip,
        "chest": current.chest,
        'waist': current.waist,
      }),
    );
  }

  void changeRelatedSizeMap(String id) {
    final current =
        state.relatedSizes.where((element) => element.id == id).first;

    emit(state.clone(currentUserSize: id));
    emit(
      state.clone(relatedSizeMap: {
        'hip': current.hip,
        "chest": current.chest,
        'waist': current.waist,
      }),
    );
  }

  Future<void> addProfile({
    required String firstName,
    required String lastName,
    required int age,
    required String size,
    required String gender,
  }) async {
    final subUser = SubUser(
      size: size,
      age: age,
      firstname: firstName,
      lastname: lastName,
      gender: gender,
    );

    await _subUserRepository.add(item: subUser, parent: state.currentUser!.ref);
  }

  void changeCurrentUserItem(List<Item> items) {
    List<Item> list = [];
    items = items.where((element) => element.isAvailable == true).toList();

    final gender = state.currentUser!.gender;
    final age = state.currentUser!.age;

    final wearType = gender == 'Male' ? "Mens' Wear" : "Ladies' Wear";

    if (state.currentSubUser!.isNotEmpty) {
      final subUser = state.currentSubUser!.first;

      final size = subUser.size ?? '';

      final gender2 = subUser.gender;
      final age2 = subUser.age;

      final wearType2 = gender2 == 'Male' ? "Mens' Wear" : "Ladies' Wear";

      if (age2 == null) {
        if (items.isNotEmpty) {
          list = items
              .where((e) => (e.size == 'General' && e.category == "General"))
              .toList();
        }
        emit(state.clone(currentUserItems: list, type: 'all'));
      } else if (age2 < 12) {
        if (items.isNotEmpty) {
          list = items
              .where((e) =>
                  (e.size == size || e.size == 'General') &&
                  (e.category == "Kids' Wear" || e.category == "General"))
              .toList();
        }
      } else {
        if (items.isNotEmpty) {
          list = items
              .where((e) =>
                  (e.size == size || e.size == 'General') &&
                  (e.category == wearType2 || e.category == "General"))
              .toList();
        }
      }

      emit(state.clone(currentUserItems: list, type: 'all'));
    } else {
      if (state.currentUser != null) {
        final size = state.currentUser!.size ?? 'General';

        if (age == null) {
          if (items.isNotEmpty) {
            list = items
                .where((e) => (e.size == 'General' && e.category == "General"))
                .toList();
          }
          emit(state.clone(currentUserItems: list, type: 'all'));
        } else if (age < 12) {
          if (items.isNotEmpty) {
            list = items
                .where((e) =>
                    (e.size == size || e.size == 'General') &&
                    (e.category == "Kids' Wear" || e.category == "General"))
                .toList();
          }
        } else {
          if (items.isNotEmpty) {
            list = items
                .toList()
                .where((e) =>
                    (e.size == size || e.size == 'General') &&
                    (e.category == wearType || e.category == "General"))
                .toList();
          }
        }

        emit(state.clone(currentUserItems: list, type: 'all'));
      }
    }
  }

  void changeType(String type) {
    emit(state.clone(type: type));
  }

  Future<void> handleUserLoggedOut() async {
    await auth.logout();
    emit(RootState.initialState);
  }

  changeUserValues(String key, String value) {
    if (key == 'firstName') {
      emit(state.clone(firstName: value));
    } else if (key == 'lastName') {
      emit(state.clone(lastName: value));
    } else if (key == 'address') {
      emit(state.clone(address: value));
    } else if (key == 'nic') {
      emit(state.clone(nic: value));
    } else if (key == 'age') {
      emit(state.clone(age: value));
    } else if (key == 'contact') {
      emit(state.clone(contact: value));
    }
  }

  _changeUserOrders(String userId) {
    _orderRepository
        .query(
            spec:
                MultiQueryTransformer([ComplexWhere('cid', isEqualTo: userId)]))
        .listen((event) {
      if (event.isNotEmpty) {
        emit(state.clone(orders: event.toList(growable: false)));
      } else {
        emit(state.clone(orders: []));
      }
    });
  }
}
