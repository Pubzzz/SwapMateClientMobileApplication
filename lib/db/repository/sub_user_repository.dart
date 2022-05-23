import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/set_options.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:swap_mate_mobile/db/db_util.dart';
import 'package:swap_mate_mobile/db/model/sub_user.dart';

class SubUserRepository extends FirebaseRepository<SubUser> {
  @override
  SubUser fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final map = snapshot.data()!;

    return SubUser(
        ref: snapshot.reference,
        age: map['age'],
        firstname: map['firstname'],
        lastname: map['lastname'],
        gender: map['gender'],
        size: map['size']);
  }

  @override
  Map<String, Object?> toMap(SubUser value, SetOptions? options) {
    return {
      'age': value.age,
      'firstname': value.firstname,
      'gender': value.gender,
      'size': value.size,
      'lastname': value.lastname
    };
  }

  @override
  Future<DocumentReference> update({
    required SubUser item,
    SetOptions? setOptions,
    String? type,
    DocumentReference? parent,
    MapperCallback<SubUser>? mapper,
  }) {
    return super.update(
      item: item,
      type: DBUtil.SUB_USER,
      parent: parent,
      mapper: mapper,
    );
  }

  @override
  Future<void> remove({required SubUser item}) {
    return super.remove(item: item);
  }

  @override
  Stream<Iterable<SubUser>> query(
      {required QueryTransformer<SubUser> spec,
      String? type,
      DocumentReference? parent,
      bool includeMetadataChanges = false}) {
    return super.query(
      spec: spec,
      type: DBUtil.SUB_USER,
      parent: parent,
    );
  }

  @override
  Future<DocumentReference> add({
    required SubUser item,
    SetOptions? setOptions,
    String? type,
    DocumentReference? parent,
  }) {
    return super.add(item: item, type: DBUtil.SUB_USER,parent: parent);
  }
}
