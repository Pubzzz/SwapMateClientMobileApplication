import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/cupertino.dart';

class User extends DBModel {
  String? nic;
  String? email;
  String? address;
  int? age;
  String? contact;
  String? firstname;
  String? gender;
  String? lastname;
  String? points;
  String? size;
  String? regdate;
  bool isProfileCompleted;

  User({
    DocumentReference? ref,
    this.nic,
    this.email,
    this.address,
    this.age,
    this.contact,
    this.firstname,
    this.gender,
    this.lastname,
    this.points,
    this.size,
    this.regdate,
    required this.isProfileCompleted,
  }) : super(ref: ref);

  @override
  User clone() {
    return User(
        ref: ref,
        email: email,
        address: address,
        age: age,
        contact: contact,
        firstname: firstname,
        lastname: lastname,
        gender: gender,
        nic: nic,
        points: points,
        size: size,
        isProfileCompleted: isProfileCompleted,
      regdate: regdate
    );
  }
}
