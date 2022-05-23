import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup_cubit.dart';


class SignUpProvider extends BlocProvider<SignUpCubit> {
  SignUpProvider({
    Key? key,
  }) : super(
          key: key,
          create: (context) => SignUpCubit(context),
          child: const SignupView(),
        );
}
