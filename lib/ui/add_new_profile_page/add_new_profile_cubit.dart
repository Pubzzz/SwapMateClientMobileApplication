import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';
import 'package:swap_mate_mobile/db/repository/sub_user_repository.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_state.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';

class AddNewProfileCubit extends Cubit<AddNewProfileState> {
  AddNewProfileCubit(BuildContext context)
      : rootCubit = BlocProvider.of<RootCubit>(context),
        super(AddNewProfileState.initialState);

  final RootCubit rootCubit;
  final subUserRepo = SubUserRepository();

  Future<void> createProfile(
      {required String age,
      required String firstName,
      required String lastName,
      required String gender,
      required String size}) async {
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
      final profile = SubUser(
        firstname: firstName,
        lastname: lastName,
        gender: gender,
        size: size,
        age: int.parse(age),
      );


      await subUserRepo.add(
        parent: rootCubit.state.currentUser!.ref,
        item: profile,
      );

      emit(state.clone(addingState: 2));
    } catch (e) {
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
