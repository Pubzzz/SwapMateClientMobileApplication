import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_button/sign_button.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup_cubit.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup_state.dart';
import 'package:swap_mate_mobile/ui/auth/welcome_view.dart';
import 'package:swap_mate_mobile/ui/widgets/common_snack_bar.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_view.dart';
import '../../../theme/app_colors.dart';
import '../login_page/login.dart';
import '../login_page/login_provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passworController = TextEditingController();
  final cpassworController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final signUpCubit = BlocProvider.of<SignUpCubit>(context);
    final rootBloc = BlocProvider.of<RootCubit>(context);

    void _registerClicked() {
      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.loadingSnackBar);
      final email = (emailController.text).trim();
      final password = (passworController.text).trim();
      final confirmPasswrd = (cpassworController.text).trim();

      signUpCubit.createUser(email, password, confirmPasswrd);
    }

    final scaffold = Scaffold(
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SignInButton(
                    buttonType: ButtonType.google,
                    btnText: "Sign Up with Google",
                    onPressed: () {
                      signUpCubit.signUpUsingGoogle();
                    },
                    buttonSize: ButtonSize.large,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SignInButton(
                    buttonType: ButtonType.facebook,
                    btnText: "Sign Up with Facebook",
                    onPressed: () {
                      signUpCubit.signUpUsingFaceBook();
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
                    'Signup with your E-mail',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("enter valid email address");
                          }
                        },
                        decoration: InputDecoration(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: TextFormField(
                        controller: passworController,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("you need to provide valid password");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Password should be include at least 6 characters");
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: TextFormField(
                        controller: cpassworController,
                        validator: (value) {
                          if (cpassworController.text.length > 6 &&
                              passworController.text != value) {
                            return ("Password dont match");
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
                            hintText: "Re-enter Password"),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: TextButton(
                    child: Text("Register".toUpperCase(),
                        style: const TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(HWhite),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(HPrimarycolor),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(color: HPrimarycolor)))),
                    onPressed: () {
                      _registerClicked();
                    }),
              ),
              SizedBox(
                height: size.height * 0.02,
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(HWhite),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(color: HPrimarycolor)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeView()),
                      );
                    }),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginProvider()),
                  );
                },
                child: const Text(
                  "Allready have an account?",
                  style: TextStyle(
                    color: HPrimarycolor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpCubit, SignUpState>(
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
        BlocListener<SignUpCubit, SignUpState>(
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
        BlocListener<SignUpCubit, SignUpState>(
          listenWhen: (pre, current) =>
              pre.registered != current.registered ||
              pre.email != current.email,
          listener: (context, state) {
            if (state.registered && state.email.isNotEmpty) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              rootBloc.handleUserLogged(state.email);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RootView(
                    email: state.email,
                    fromSignUp: true,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
