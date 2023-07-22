import 'package:hive_flutter/hive_flutter.dart';
part 'cartmodel.g.dart';

@HiveType(typeId: 1)
class cartProductModel {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String name = "";
  @HiveField(2)
  String slug = "";
  @HiveField(3)
  double price = 0;
  @HiveField(4)
  int quantity = 0;
  @HiveField(5)
  double subTotal = 0;
  @HiveField(6)
  double save = 0;
  @HiveField(7)
  String image;
  @HiveField(8)
  String unit;
  @HiveField(9)
  int vid = 0;
  @HiveField(10)
  String subscription;
  @HiveField(11)
  int subscriptionID;
  @HiveField(12)
  String Des;
  @HiveField(13)
  int deliveryOption = 2;

  cartProductModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.slug,
      required this.subTotal,
      required this.save,
      required this.image,
      required this.unit,
      required this.subscription,
      required this.deliveryOption,
      required this.subscriptionID,
      required this.Des,
      this.vid = 0});
}
