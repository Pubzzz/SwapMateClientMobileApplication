import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_button/sign_button.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_cubit.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_state.dart';
import 'package:swap_mate_mobile/ui/widgets/common_snack_bar.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_view.dart';

import '../../../theme/app_colors.dart';

import '../../reset_password_page/reset_password_view.dart';

var scaffoldkey = GlobalKey<ScaffoldState>();

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final loginBloc = BlocProvider.of<LoginCubit>(context);
    final rootBloc = BlocProvider.of<RootCubit>(context);

    void _loginClicked() {
      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.loadingSnackBar);

      final email = (_emailController.text).trim();
      final password = (_passwordController.text).trim();
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar.showErrorSnackBar("Email or Password is Empty!"));

        return;
      }

      loginBloc.userLogin(email, password);
    }

    final scaffold = Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HWhite,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: HPrimarycolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                SignInButton(
                  buttonType: ButtonType.google,
                  btnText: "Log in with Google",
                  onPressed: () async {
                    await loginBloc.googleLogin();
                  },
                  buttonSize: ButtonSize.large,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SignInButton(
                  buttonType: ButtonType.facebook,
                  btnText: "Log in with Facebook",
                  onPressed: () {
                    loginBloc.facebookLogin();
                  },
                  buttonSize: ButtonSize.large,
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                const Text(
                  'or',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                const Text(
                  'Login with your e-mail',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please enter your E-mail");
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
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
                        hintText: "Username"),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Password is required to login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Password must be longer than 6 characters");
                      }
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
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
                        hintText: "Password"),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: TextButton(
                            child: Text("login".toUpperCase(),
                                style: const TextStyle(fontSize: 16)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(HWhite),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HPrimarycolor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: const BorderSide(
                                            color: HPrimarycolor)))),
                            onPressed: () {
                              _loginClicked();
                            }),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextButton(
                          child: Text("cancel".toUpperCase(),
                              style: const TextStyle(fontSize: 16)),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(15)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  HPrimarycolor),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(HWhite),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: const BorderSide(
                                          color: HPrimarycolor)))),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: loginBloc,
                              child: const ResetPasswordView(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot your password ? ",
                        style: TextStyle(
                            color: HPrimarycolor,
                            decoration: TextDecoration.underline,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (pre, current) => pre.processing != current.processing,
          listener: (context, state) {
            if (state.processing) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.loadingSnackBar);
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (pre, current) =>
              pre.email != current.email && current.email.isNotEmpty,
          listener: (context, state) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            rootBloc.handleUserLogged(state.email);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RootView(
                  email: state.email,
                ),
              ),
            );
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => true,
        child: scaffold,
      ),
    );
  }
}
