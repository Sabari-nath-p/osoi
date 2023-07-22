// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class cartProductModelAdapter extends TypeAdapter<cartProductModel> {
  @override
  final int typeId = 1;

  @override
  cartProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return cartProductModel(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
      slug: fields[2] as String,
      subTotal: fields[5] as double,
      save: fields[6] as double,
      image: fields[7] as String,
      unit: fields[8] as String,
      subscription: fields[10] as String,
      deliveryOption: fields[13] as int,
      subscriptionID: fields[11] as int,
      Des: fields[12] as String,
      vid: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, cartProductModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.subTotal)
      ..writeByte(6)
      ..write(obj.save)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.unit)
      ..writeByte(9)
      ..write(obj.vid)
      ..writeByte(10)
      ..write(obj.subscription)
      ..writeByte(11)
      ..write(obj.subscriptionID)
      ..writeByte(12)
      ..write(obj.Des)
      ..writeByte(13)
      ..write(obj.deliveryOption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is cartProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
