import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_cubit.dart';

class LoginProvider extends BlocProvider<LoginCubit> {
  LoginProvider({
    Key? key,
  }) : super(
    key: key,
    create: (context) => LoginCubit(context),
    child: const LoginView(),
  );
}
