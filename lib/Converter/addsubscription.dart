import 'package:oso/Converter/verify.dart';

class AddSubscriptionModel {
  String? subscriptionId;
  List<Products>? products;

  AddSubscriptionModel({this.subscriptionId, this.products});

  AddSubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_id'] = this.subscriptionId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
