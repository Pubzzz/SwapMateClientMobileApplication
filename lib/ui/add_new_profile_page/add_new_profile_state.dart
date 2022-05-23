import 'package:flutter/material.dart';

@immutable
class AddNewProfileState {
  final String error;
  final String email;
  final int addingState;

  AddNewProfileState({
    required this.error,
    required this.email,
    required this.addingState,
  });

  AddNewProfileState clone({String? error, String? email, int? addingState}) {
    return AddNewProfileState(
      error: error ?? this.error,
      email: email ?? this.email,
      addingState: addingState ?? this.addingState,
    );
  }

  static AddNewProfileState get initialState => AddNewProfileState(
        error: "",
        email: "",
        addingState: 0,
      );
}
