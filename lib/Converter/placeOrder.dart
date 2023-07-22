import 'package:oso/Converter/verify.dart';

class PlaceOrder {
  String? paymentIntent;
  String? orderType;
  String? deliveryType;
  List<Products>? products;
  int? status;
  double? amount;
  Null? couponId;
  double? discount;
  int? paidTotal;
  String? preOrderDate;
  double? salesTax;
  double? deliveryFee;
  double? total;
  String? customerContact;
  String? paymentGateway;
  bool? useWalletPoints;
  placeAddress? billingAddress;
  placeAddress? shippingAddress;

  PlaceOrder(
      {this.orderType,
      this.deliveryType,
      this.products,
      this.status,
      this.amount,
      this.couponId,
      this.discount,
      this.paidTotal,
      this.salesTax,
      this.deliveryFee,
      this.total,
      this.customerContact,
      this.paymentGateway,
      this.useWalletPoints,
      this.billingAddress,
      this.shippingAddress});

  PlaceOrder.fromJson(Map<String, dynamic> json) {
    orderType = json['order_type'];
    deliveryType = json['delivery_type'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    status = json['status'];
    amount = json['amount'];
    couponId = json['coupon_id'];
    discount = json['discount'];
    paidTotal = json['paid_total'];
    salesTax = json['sales_tax'];
    deliveryFee = json['delivery_fee'];
    total = json['total'];
    customerContact = json['customer_contact'];
    paymentGateway = json['payment_gateway'];
    useWalletPoints = json['use_wallet_points'];
    billingAddress = json['billing_address'] != null
        ? new placeAddress.fromJson(json['billing_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? new placeAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_type'] = this.orderType;
    data['delivery_type'] = this.deliveryType;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['coupon_id'] = this.couponId;
    data['discount'] = this.discount;
    data['paid_total'] = this.paidTotal;
    data['sales_tax'] = this.salesTax;
    if (preOrderDate != null) data['pre_order_date'] = this.preOrderDate;
    data['delivery_fee'] = this.deliveryFee;
    data['total'] = this.total;
    data['customer_contact'] = this.customerContact;
    data['payment_gateway'] = this.paymentGateway;
    data['use_wallet_points'] = this.useWalletPoints;
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    return data;
  }
}

class placeAddress {
  String? zip;
  String? city;
  String? state;
  String? country;
  String? streetAddress;

  placeAddress(
      {this.zip, this.city, this.state, this.country, this.streetAddress});

  placeAddress.fromJson(Map<String, dynamic> json) {
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
