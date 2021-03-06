import 'package:bloc/bloc.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import 'package:swap_mate_mobile/db/authentication.dart';
import 'package:swap_mate_mobile/db/model/user.dart';
import 'package:swap_mate_mobile/db/repository/user_repository.dart';
import 'package:swap_mate_mobile/ui/auth/login_page/login_state.dart';
import 'package:swap_mate_mobile/ui/auth/signup_page/signup_state.dart';
import 'package:swap_mate_mobile/db/model/user.dart' as r;

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(BuildContext context) : super(SignUpState.initialState);

  final auth = Authentication();
  final userRepo = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  Future<void> createUser(
      String email, String password, String confirmPassword) async {
    if (email.isEmpty) {
      errorEvent("Email can`t be Empty");
      emit(state.clone(processing: false));
      return;
    }

    if (!isValidEmail(email)) {
      errorEvent("Please Enter valid Email");
      emit(state.clone(processing: false));
      return;
    }

    final fetchEmail =
        await a.FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    if (fetchEmail.isNotEmpty) {
      errorEvent("Email is already exist");
      emit(state.clone(processing: false));
      return;
    }

    if (password.length < 6 || password.isEmpty) {
      errorEvent("Password must have minimum 6 characters");
      emit(state.clone(processing: false));
      return;
    }

    if (password != confirmPassword) {
      errorEvent("Please Check the  Password Again...!");
      emit(state.clone(processing: false));
      return;
    }

    try {

      final formatter =  DateFormat('dd-MM-yyyy');
      String formattedDate = formatter.format(DateTime.now());

      final register = await auth.register(email, password);

      if (register!.isNotEmpty) {
        final user = r.User(
          isProfileCompleted: false,
          email: email,
          points: '0',
          regdate:formattedDate,
        );

        await userRepo.add(
          item: user,
        );

        emit(state.clone(email: email, registered: true, processing: false));
      }
    } catch (e) {
      emit(state.clone(email: '', registered: false, processing: false));
      return;
    }
  }

  Future<void> signUpUsingGoogle() async {
    try {

      a.AuthCredential? authUser = await auth.signInWithGoogle();

      emit(state.clone(processing: true));

      if (authUser != null) {

        final UserCredential userCredential =
        await _auth.signInWithCredential(authUser);

        a.User? user1 = userCredential.user;

        if(user1!=null){
          final usersList = await userRepo.querySingle(
              spec: MultiQueryTransformer(
                  [ComplexWhere('email', isEqualTo: user1.email)]));

          if (usersList.isNotEmpty) {
            emit(state.clone(processing: false));
            errorEvent('This email is already exist..please login');
            return;
          }

          final formatter =  DateFormat('dd-MM-yyyy');
          String formattedDate = formatter.format(DateTime.now());


          final user = r.User(
            isProfileCompleted: false,
            email: user1.email,
            firstname: user1.displayName ?? '',
            points: '0',
            regdate: formattedDate
          );

          await userRepo.add(
            item: user,
          );

          emit(state.clone(
              email: user.email, registered: true, processing: false));
        }

      }
    } on a.FirebaseAuthException catch (e) {
      emit(state.clone(email: '', registered: false, processing: false));

      if (e.code == 'account-exists-with-different-credential') {
        errorEvent('The account already exists with a different credential');
      } else if (e.code == 'invalid-credential') {
        errorEvent('Error occurred while accessing credentials. Try again.');
      }
    } catch (e) {
      print('ERROR ${e}');
      emit(state.clone(email: '', registered: false, processing: false));
      errorEvent('Error occurred using Google Sign In. Try again.');
    }
  }


  signUpUsingFaceBook() async {
    final LoginResult result = await FacebookAuth.i.login();

    if (result.status == LoginStatus.success) {
      try {

        final data = await FacebookAuth.i.getUserData();

        final AuthCredential facebookCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);


        emit(state.clone(processing: true));

        if (userCredential.user != null) {

          final list=await userRepo.querySingle(
            spec: MultiQueryTransformer(
                [ComplexWhere('email', isEqualTo: userCredential.user!.email)]),
          );

          if(list.isEmpty){

            final formatter =  DateFormat('dd-MM-yyyy');
            String formattedDate = formatter.format(DateTime.now());

            final user = r.User(
              isProfileCompleted: false,
              email: userCredential.user!.email,
              profileImg: userCredential.user!.photoURL ?? '',
              firstname: data['name'] ?? '',
              points: '0',
              regdate: formattedDate,
            );

            await userRepo.add(
              item: user,
            );

            emit(state.clone(
                email: user.email, registered: true, processing: false));
          }else{

            emit(state.clone(processing: true));

            errorEvent('This email is already exist..please login');
            await auth.logout();
            return;
          }
        } else {
          emit(state.clone(processing: false));
          errorEvent('The account already exists with a different credential');
          return;
        }

      } on FirebaseAuthException catch (e) {
        emit(state.clone(processing: false));

        if (e.code == 'account-exists-with-different-credential') {
          errorEvent('The account already exists with a different credential');
        } else if (e.code == 'invalid-credential') {
          errorEvent('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        emit(state.clone(processing: false));

        errorEvent('Error occurred using Facebook  SignIn. Try again.');
      }
    } else {
      errorEvent('Error occurred using Facebook  SignIn. Try again.');
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
