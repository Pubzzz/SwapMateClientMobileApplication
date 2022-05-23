import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_cubit.dart';
import 'package:swap_mate_mobile/ui/add_new_profile_page/add_new_profile_state.dart';
import 'package:swap_mate_mobile/ui/widgets/common_snack_bar.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_state.dart';
import '../../theme/app_colors.dart';
import '../home_page.dart';

class AddProfileView extends StatefulWidget {
  const AddProfileView({Key? key}) : super(key: key);

  @override
  _AddProfileViewState createState() => _AddProfileViewState();
}

class _AddProfileViewState extends State<AddProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final sizeController = TextEditingController();
  final lastNameController = TextEditingController();

  String dropdownValue = 'Male';
  String dropdownValue2 = 'M';

  @override
  Widget build(BuildContext context) {
    final rootCubit = BlocProvider.of<RootCubit>(context);
    final newProfileCubit = BlocProvider.of<AddNewProfileCubit>(context);

    Size size = MediaQuery.of(context).size;

    var _currencies = ["Male", "Female"];

    final scaffold = Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Add New Profile",
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
                      pre.relatedSizes != current.relatedSizes ||
                      pre.relatedSizeMap != current.relatedSizeMap,
                  builder: (context, snapshot) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      controller: firstnameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Enter proper name");
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
                                          labelText: 'First Name'),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      controller: lastNameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Enter proper name");
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
                                          labelText: 'Last Name'),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    TextFormField(
                                      controller: ageController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Enter proper age");
                                        }
                                      },
                                      onChanged: (value) {
                                        rootCubit.changeRelatedSizes(
                                            value, dropdownValue);
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
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.person_outline,
                                              color: HGrey,
                                            ),
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
                                              value: dropdownValue,
                                              isDense: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  dropdownValue = value!;
                                                });
                                                rootCubit.changeRelatedSizes(
                                                    ageController.text, value!);
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
                                            prefixIcon: const Icon(
                                              Icons.person_outline,
                                              color: HGrey,
                                            ),
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
                                              value: dropdownValue2,
                                              isDense: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  dropdownValue2 = value!;
                                                });
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
                                      height: size.height * 0.02,
                                    ),
                                    Text(
                                        'Chest : ${snapshot.relatedSizeMap["chest"] ?? 0} cm'),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                        'Hip : ${snapshot.relatedSizeMap["hip"] ?? 0} cm'),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                        'Waist : ${snapshot.relatedSizeMap["waist"] ?? 0} cm'),
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
                                        child: Text("Add Profile".toUpperCase(),
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
                                          newProfileCubit.createProfile(
                                            age: ageController.text,
                                            firstName: firstnameController.text,
                                            lastName: lastNameController.text,
                                            size: dropdownValue2,
                                            gender: dropdownValue
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
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<AddNewProfileCubit, AddNewProfileState>(
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
        BlocListener<AddNewProfileCubit, AddNewProfileState>(
          listenWhen: (pre, current) => pre.addingState != current.addingState,
          listener: (context, state) {
            if (state.addingState == 1) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppSnackBar.loadingSnackBar);
            } else if (state.addingState == 2) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              // ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.showSnackBar('New Profile Added'));
              Fluttertoast.showToast(msg: "User profile added successfully");
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: scaffold,
    );
  }

}
