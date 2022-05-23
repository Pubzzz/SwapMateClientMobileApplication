import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class Order extends DBModel {
  String orderId;
  String customerId;
  String date;
  String showroomId;
  String status;

  Order({
    DocumentReference? ref,
    required this.orderId,
    required this.customerId,
    required this.date,
    required this.showroomId,
    required this.status,
  }) : super(ref: ref);

  @override
  Order clone() {
    return Order(
        ref: ref,
        customerId: customerId,
        date: date,
        orderId: orderId,
        showroomId: showroomId,
        status: status);
  }
}
