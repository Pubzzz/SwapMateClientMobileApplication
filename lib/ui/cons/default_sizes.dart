import 'package:swap_mate_mobile/db/model/dress_size.dart';

class DefaultSizes {


  static List<DressSize> kidsDefault = [
    DressSize(chest: 56, id: '2S', hip: 59, waist: 54),
    DressSize(id: "3S", chest: 52, hip: 53, waist: 52),
    DressSize(id: "L", chest: 78, hip: 83, waist: 68),
    DressSize(id: "M", chest: 72, hip: 77, waist: 63.5),
    DressSize(id: "S", chest: 66, hip: 71, waist: 59),
    DressSize(id: "XL", chest: 86, hip: 89, waist: 73),
  ];


  static List<DressSize> mensDefault = [
    DressSize(id: "2XL", chest: 115, hip: 116, waist: 102),
    DressSize(id: "3XL", chest: 112.5, hip: 123.5, waist: 109.5),
    DressSize(id: "L", chest: 102.5, hip: 94, waist: 90),
    DressSize(id: "M", chest: 97, hip: 89, waist: 86),
    DressSize(id: "S", chest: 92.5, hip: 84, waist: 81),
    DressSize(id: "XL", chest: 108.5, hip: 104.5, waist: 95.5),
  ];

  static List<DressSize> ladiesDefault = [
    DressSize(id: "L", chest: 100, hip: 108, waist: 94),
    DressSize(id: "M", chest: 92, hip: 108, waist: 78),
    DressSize(id: "S", chest: 86, hip: 94, waist: 72),
    DressSize(id: "XL", chest: 108, hip: 116, waist: 94),
    DressSize(id: "XS", chest: 80, hip: 80, waist: 65),
    DressSize(id: "XXL", chest: 116, hip: 124, waist: 104),
    DressSize(id: "XXS", chest: 76, hip: 84, waist: 61),
  ];
}
