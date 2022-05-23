import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class Item extends DBModel {
  String? category;
  String? date;
  String? name;
  String? notes;
  List<String> pictures;
  String? points;
  String? size;
  bool isAvailable;

  Item({
    required DocumentReference? ref,
    this.category,
    this.date,
    this.name,
    this.notes,
    required this.pictures,
    this.points,
    this.size,
    required this.isAvailable,
  }) : super(ref: ref);

  @override
  Item clone() {
    return Item(
      ref: ref,
      size: size,
      points: points,
      name: name,
      category: category,
      date: date,
      notes: notes,
      pictures: pictures,
      isAvailable: isAvailable
    );
  }
}
