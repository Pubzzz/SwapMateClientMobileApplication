import 'package:flutter/material.dart';

@immutable
class UserManagementState {
  final String error;
  final String email;
  final int addingState;


  UserManagementState({
    required this.error,
    required this.email,
    required this.addingState,
  });

  UserManagementState clone({String? error, String? email, int? addingState}) {
    return UserManagementState(
      error: error ?? this.error,
      email: email ?? this.email,
      addingState: addingState ?? this.addingState,
    );
  }

  static UserManagementState get initialState => UserManagementState(
    error: "",
    email: "",
    addingState: 0,
  );
}
