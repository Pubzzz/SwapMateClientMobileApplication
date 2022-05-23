import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/db/repository/sub_user_repository.dart';
import 'package:swap_mate_mobile/db/repository/user_repository.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_state.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit(BuildContext context)
      : rootCubit = BlocProvider.of<RootCubit>(context),
        super(UserManagementState.initialState);

  final RootCubit rootCubit;
  final userRepository = UserRepository();

  Future<void> updateProfile({
    required String age,
    required String firstName,
    required String lastName,
    required String address,
    required String nic,
    required String gender,
    required String size,
    required String contact,
  }) async {
    emit(state.clone(addingState: 1));

    if (age.isEmpty) {
      errorEvent("Age can`t be Empty");
      emit(state.clone(addingState: 0));
      return;
    }

    if (firstName.isEmpty) {
      errorEvent("Firstname can`t be Empty");
      emit(state.clone(addingState: 0));
      return;
    }

    if (gender.isEmpty) {
      errorEvent("Gender can`t be Empty");
      emit(state.clone(addingState: 0));
      return;
    }

    if (size.isEmpty) {
      errorEvent("Size can`t be Empty");
      emit(state.clone(addingState: 0));
      return;
    }

    try {

      await userRepository.update(
          item: rootCubit.state.currentUser!,
          mapper: (_) => {
                'firstname': firstName,
                "lastname": lastName,
                'address': address,
                'nic': nic,
                'age': int.parse(age),
                'size': size,
                'gender': gender,
                'contact': contact,
                'isProfileCompleted': true,
              });

      emit(state.clone(addingState: 2));
    } catch (e) {
      print(e);
      emit(state.clone(addingState: 0));
      return;
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
