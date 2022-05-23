import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_cubit.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_cubit.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_view.dart';

class UserManagementProvider extends BlocProvider<UserManagementCubit> {
  UserManagementProvider({
    bool fromSignUp=false,
    Key? key,
  }) : super(
    key: key,
    create: (context) => UserManagementCubit(context),
    child:   UserManagementView(fromSignUp: fromSignUp),
  );
}
