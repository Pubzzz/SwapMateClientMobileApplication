import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/set_options.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:swap_mate_mobile/db/db_util.dart';

import '../model/item.dart';

class ItemRepository extends FirebaseRepository<Item> {
  @override
  fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    return Item(
      ref: snapshot.reference,
      name: data['name'] ?? '',
      notes: data['notes'] ?? '',
      size: data['size'],
      date: data['date'] ?? '',
      points: data['points'],
      category: data['category'],
      pictures: List.from(
        data['pictures'] ?? [],
      ),
      isAvailable: data['isAvailable'] ?? true
    );
  }

  @override
  Map<String, Object?> toMap(value, SetOptions? options) {
    return {
      "name": value.name,
      "size": value.size,
      "notes": value.notes,
      "points": value.points,
      "category": value.category,
      "date": value.date,
    };
  }

  @override
  Future<DocumentReference> update(
      {required Item item,
      SetOptions? setOptions,
      String? type,
      DocumentReference? parent,
      MapperCallback<Item>? mapper}) {
    return super.update(
      item: item,
      type: DBUtil.ITEM,
      mapper: mapper,
    );
  }

  @override
  Stream<Iterable<Item>> query(
      {required QueryTransformer<Item> spec,
      String? type,
      DocumentReference? parent,
      bool includeMetadataChanges = false}) {
    return super.query(spec: spec, type: DBUtil.ITEM);
  }

  @override
  Future<DocumentReference> add(
      {required Item item,
      SetOptions? setOptions,
      String? type,
      DocumentReference? parent}) {
    return super.add(item: item, type: DBUtil.ITEM);
  }
}
