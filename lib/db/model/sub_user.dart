import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class SubUser extends DBModel {
  int? age;
  String? firstname;
  String? lastname;
  String? gender;
  String? size;

  SubUser({
    DocumentReference? ref,
    this.age,
    this.firstname,
    this.lastname,
    this.gender,
    this.size,
  }) : super(ref: ref);

  @override
  SubUser clone() {
    return SubUser(
      ref: ref,
      size: size,
      gender: gender,
      firstname: firstname,
      lastname: lastname,
      age: age,
    );
  }
}
