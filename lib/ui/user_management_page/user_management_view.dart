import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swap_mate_mobile/util/routes.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_cubit.dart';
import 'package:swap_mate_mobile/ui/user_management_page/user_management_state.dart';
import '../widgets/common_snack_bar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_colors.dart';
import '../home_page.dart';

class UserManagementView extends StatelessWidget {
  final bool fromSignUp;

  UserManagementView({
    Key? key,
    this.fromSignUp = false,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final rootCubit = BlocProvider.of<RootCubit>(context);
    final usrCubit = BlocProvider.of<UserManagementCubit>(context);

    Size size = MediaQuery.of(context).size;

    var _currencies = ["Male", "Female"];

    Future<bool> _onWillPop() async {
      if(fromSignUp){

      }
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    final scaffold = WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 25,
                            color: HPrimarycolor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<RootCubit, RootState>(
                    buildWhen: (pre, current) =>
                        pre.currentUser != current.currentUser ||
                        pre.relatedSizes != current.relatedSizes ||
                        pre.relatedSizeMap != current.relatedSizeMap ||
                        pre.currentUserSize != current.currentUserSize ||
                        pre.firstName != current.firstName ||
                        pre.lastName != current.lastName ||
                        pre.address != current.address ||
                        pre.nic != current.nic ||
                        pre.age != current.age,
                    builder: (context, snapshot) {
                      if (snapshot.currentUser == null) {
                        return loadingWidget;
                      }

                      return Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'First Name',
                                      ),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      initialValue: snapshot.firstName,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'firstName', value);
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Last Name',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'lastName', value);
                                      },
                                      initialValue: snapshot.lastName,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Address',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      initialValue: snapshot.address,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'address', value);
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: HPrimarycolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: HPrimarycolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          labelText: 'Contact Number'),
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'contact', value);
                                      },
                                      initialValue: snapshot.contact,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Nic',
                                      ),
                                      textInputAction: TextInputAction.none,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'nic', value);
                                      },
                                      initialValue: snapshot.nic,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: HPrimarycolor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Age',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        rootCubit.changeUserValues(
                                            'age', value);
                                      },
                                      initialValue: snapshot.age,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0,
                                            ),
                                            hintText: 'Gender',
                                            labelText: 'Gender',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          isEmpty: false,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: snapshot.currentUserGender,
                                              isDense: true,
                                              onChanged: (value) {
                                                rootCubit
                                                    .changeCurrentUserGender(
                                                        value!);
                                                rootCubit.changeRelatedSizes(
                                                    snapshot.age!, value);
                                              },
                                              items: _currencies
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0,
                                            ),
                                            labelText: "Size",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          isEmpty: false,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: snapshot.currentUserSize,
                                              isDense: true,
                                              onChanged: (value) {
                                                rootCubit.changeRelatedSizeMap(
                                                    value!);
                                              },
                                              items: snapshot.relatedSizes
                                                  .map((e) {
                                                return DropdownMenuItem<String>(
                                                  value: e.id,
                                                  child: Text(e.id),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Text(
                                        'Chest : ${snapshot.relatedSizeMap["chest"] ?? 0}'),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                        'Hip : ${snapshot.relatedSizeMap["hip"] ?? 0}'),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                        'Waist : ${snapshot.relatedSizeMap["waist"] ?? 0}'),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          SizedBox(
                            height: 140,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SizedBox(
                                    width: 250,
                                    height: 50,
                                    child: TextButton(
                                        child: Text("Update".toUpperCase(),
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        style: ButtonStyle(
                                            padding:
                                                MaterialStateProperty.all<EdgeInsets>(
                                                    const EdgeInsets.all(15)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    HWhite),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    HPrimarycolor),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(50.0),
                                                    side: const BorderSide(color: HPrimarycolor)))),
                                        onPressed: () {
                                          usrCubit.updateProfile(
                                            age: snapshot.age!,
                                            firstName: snapshot.firstName,
                                            lastName: snapshot.lastName,
                                            address: snapshot.address,
                                            nic: snapshot.nic,
                                            gender: snapshot.currentUserGender,
                                            size: snapshot.currentUserSize,
                                            contact: snapshot.contact,
                                          );
                                        }),
                                  ),
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
                                              MaterialStateProperty.all<Color>(
                                                  HPrimarycolor),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  HWhite),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  side: const BorderSide(color: HPrimarycolor)))),
                                      onPressed: () {
                                        if(fromSignUp){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(AppSnackBar.showSnackBar("Please update your profile.."));
                                          return;
                                        }
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<UserManagementCubit, UserManagementState>(
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
        BlocListener<UserManagementCubit, UserManagementState>(
          listenWhen: (pre, current) => pre.addingState != current.addingState,
          listener: (context, state) {
            if (state.addingState == 1) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.loadingSnackBar);
            } else if (state.addingState == 2) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              // ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.showSnackBar('New Profile Added'));
              Fluttertoast.showToast(msg: "User profile Updated successfully");
              if(fromSignUp){
                Future.microtask(
                        () => Navigator.pushReplacementNamed(context, Routes.HOME_ROUTE));
              }else{
                Navigator.pop(context);
              }

            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
