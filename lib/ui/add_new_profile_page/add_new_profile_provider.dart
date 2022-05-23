import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_cubit.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_profile_view.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_cubit.dart';

class AddNewProfileProvider extends BlocProvider<AddNewProfileCubit> {
  AddNewProfileProvider({
    Key? key,
  }) : super(
    key: key,
    create: (context) => AddNewProfileCubit(context),
    child: const AddProfileView(),
  );
}
