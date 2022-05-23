import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/db/db_util.dart';
import 'package:swap_mate_mobile/db/model/user.dart';

class UserRepository extends FirebaseRepository<User> {
  UserRepository() : super();

  @override
  User fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    return User(
        ref: snapshot.reference,
        nic: data['nic'] ?? "",
        email: data['email'] ?? '',
        address: data['address'] ?? '',
        age: data['age'],
        contact: data['contact'] ?? '',
        firstname: data['firstname'] ?? '',
        gender: data['gender'] ?? '',
        lastname: data['lastname'] ?? '',
        points: data['points'] ?? '',
        size: data['size'] ?? '',
        isProfileCompleted: data['isProfileCompleted'] ?? false);
  }

  @override
  Map<String, Object?> toMap(User value, SetOptions? options) {
    return {
      'nic': value.nic,
      'email': value.email,
      'address': value.address,
      'age': value.age,
      'contact': value.contact,
      'firstname': value.firstname,
      'gender': value.gender,
      'lastname': value.lastname,
      'points': value.points,
      'size': value.size,
      'isProfileCompleted': false,
    };
  }

  @override
  Future<DocumentReference> update({
    required User item,
    SetOptions? setOptions,
    String? type,
    DocumentReference? parent,
    MapperCallback<User>? mapper,
  }) {
    return super.update(
      item: item,
      type: DBUtil.USER,
      mapper: mapper,
    );
  }

  @override
  Future<Iterable<User>> querySingle({
    required QueryTransformer<User> spec,
    DocumentReference? parent,
    Source source = Source.serverAndCache,
    String? type,
  }) {
    return super.querySingle(
      spec: spec,
      type: DBUtil.USER,
    );
  }

  @override
  Stream<Iterable<User>> query({
    required QueryTransformer<User> spec,
    String? type,
    DocumentReference? parent,
    bool includeMetadataChanges = false,
  }) {
    return super.query(spec: spec, type: DBUtil.USER);
  }

  @override
  Future<DocumentReference> add({
    required User item,
    SetOptions? setOptions,
    DocumentReference? parent,
    String? type,
  }) {
    return super.add(item: item, type: DBUtil.USER);
  }
}
