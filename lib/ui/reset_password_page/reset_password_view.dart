import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../auth/login_page/login_cubit.dart';
import '../auth/login_page/login_state.dart';
import '../widgets/common_snack_bar.dart';
import '../../theme/app_colors.dart';
import '../auth/login_page/login.dart';
import 'newPw.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final emailController = TextEditingController();
  final pinController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginCubit>(context);

    Future<void> _loginClicked() async {
      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.loadingSnackBar);

      final email = (emailController.text).trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(AppSnackBar.showErrorSnackBar("Email is Empty"));
        return;
      }

      await loginBloc.restPassword(email);

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.showSnackBar(
          'An email has just been sent to you, Click the link provided to reset your password.'));
      // await Future.delayed(const Duration(seconds: 2));
      // Navigator.pop(context);
    }

    Size size = MediaQuery.of(context).size;
    final scaffold = Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontSize: 25,
                    color: HPrimarycolor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Enter your email address',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("enter valid email address");
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward_outlined),
                      onPressed: () {
                        const ResetPasswordView();
                      },
                      color: HPrimarycolor,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: HGrey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: HPrimarycolor,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: HPrimarycolor,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "E-mail Address"),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                  width: 250,
                  height: 50,
                  child: TextButton(
                      child: Text("Send".toUpperCase(),
                          style: const TextStyle(fontSize: 14)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(HWhite),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(HPrimarycolor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: const BorderSide(
                                          color: HPrimarycolor)))),
                      onPressed: () {
                        _loginClicked();
                      })),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: TextButton(
                  child: Text("Cancel".toUpperCase(),
                      style: const TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(HPrimarycolor),
                      backgroundColor: MaterialStateProperty.all<Color>(HWhite),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(color: HPrimarycolor)))),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.showErrorSnackBar(state.error));
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
