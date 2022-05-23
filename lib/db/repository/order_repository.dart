import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/set_options.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:swap_mate_mobile/db/db_util.dart';
import 'package:swap_mate_mobile/db/model/order.dart';

import '../model/item.dart';

class OrderRepository extends FirebaseRepository<Order> {
  @override
  fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    return Order(
      ref: snapshot.reference,
      customerId: data['cid'] ?? '',
      orderId: data['oid'] ?? '',
      date: data['date'] ?? '',
      showroomId: data['sid'] ?? '',
      status: data['status'] ?? "In Progress",
    );
  }

  @override
  Map<String, Object?> toMap(value, SetOptions? options) {
    return {
      "sid": value.showroomId,
      "oid": value.orderId,
      "cid": value.customerId,
      "date": value.date,
      "status": value.status,
    };
  }

  @override
  Stream<Iterable<Order>> query(
      {required QueryTransformer<Order> spec,
      String? type,
      DocumentReference? parent,
      bool includeMetadataChanges = false}) {
    return super.query(spec: spec, type: DBUtil.ORDERS);
  }

  @override
  Future<Iterable<Order>> querySingle(
      {required QueryTransformer<Order> spec,
      String? type,
      DocumentReference? parent,
      Source source = Source.serverAndCache}) {
    return super.querySingle(spec: spec, type: DBUtil.ORDERS);
  }
}
