import 'package:oso/constant/url.dart';

class checkoutverify {
  String? shippingClassId;
  double? amount;
  List<Products>? products;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;

  checkoutverify(
      {this.shippingClassId,
      this.amount,
      this.products,
      this.billingAddress,
      this.shippingAddress});

  checkoutverify.fromJson(Map<String, dynamic> json) {
    shippingClassId = json['shipping_class_id'];
    amount = json['amount'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? new BillingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipping_class_id'] = this.shippingClassId;
    data['amount'] = this.amount;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    return data;
  }
}

class Products {
  int? productId;
  int? orderQuantity;
  double? unitPrice;
  double? subtotal;
  int? paymentFrequency;
  String? deliveryType;
  String? imgurl;
  String? name;

  Products(
      {this.productId,
      this.orderQuantity,
      this.unitPrice,
      this.subtotal,
      this.paymentFrequency,
      this.imgurl,
      this.name,
      this.deliveryType});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    orderQuantity = json['order_quantity'];
    unitPrice = json['unit_price'];
    subtotal = json['subtotal'];
    paymentFrequency = json['payment_frequency'];
    deliveryType = json['delivery_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['order_quantity'] = this.orderQuantity;
    data['unit_price'] = this.unitPrice;
    data['subtotal'] = this.subtotal;
    data['payment_frequency'] = this.paymentFrequency;
    data['delivery_type'] = this.deliveryType;
    return data;
  }
}

class BillingAddress {
  String? zip;
  String? city;
  String? state;
  String? country;
  String? streetAddress;

  BillingAddress(
      {this.zip, this.city, this.state, this.country, this.streetAddress});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    streetAddress = json['street_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['street_address'] = this.streetAddress;
    return data;
  }
}
