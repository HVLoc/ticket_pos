// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_detail_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceDetailModelAdapter extends TypeAdapter<InvoiceDetailModel> {
  @override
  final int typeId = 0;

  @override
  InvoiceDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceDetailModel(
      items: (fields[0] as List).cast<ProductItem>(),
      email: fields[1] as dynamic,
      emailCc: fields[2] as dynamic,
      cusEmails: fields[3] as dynamic,
      parentName: fields[4] as dynamic,
      comFax: fields[5] as String?,
      arisingDate: fields[6] as String?,
      invoiceName: fields[7] as String?,
      invoicePattern: fields[8] as String?,
      serialNo: fields[9] as String?,
      invoiceNo: fields[10] as double?,
      paymentMethod: fields[11] as String?,
      comName: fields[12] as String?,
      comTaxCode: fields[13] as String?,
      comAddress: fields[14] as String?,
      comPhone: fields[15] as String?,
      comBankNo: fields[16] as dynamic,
      comBankName: fields[17] as dynamic,
      cusCode: fields[18] as String?,
      cusName: fields[19] as String?,
      cusTaxCode: fields[20] as dynamic,
      cusPhone: fields[21] as dynamic,
      cusAddress: fields[22] as String?,
      cusBankName: fields[23] as dynamic,
      cusBankNo: fields[24] as dynamic,
      total: fields[25] as double,
      vatAmount: fields[26] as double,
      amount: fields[27] as double,
      checkDiscount: fields[34] as bool,
      discountVatRate: fields[35] as double,
      totalDiscount: fields[36] as double?,
      amountInWords: fields[28] as String?,
      buyer: fields[29] as String?,
      exchangeRate: fields[30] as String?,
      currencyUnit: fields[31] as String?,
      extra: fields[32] as String?,
      vatRate: fields[33] as int?,
      processInvNote: fields[37] as String?,
      refID: fields[38] as int?,
      status: fields[39] as int?,
      type: fields[40] as int?,
      ikey: fields[41] as String?,
      refIkey: fields[42] as String?,
      tCTCheckStatus: fields[43] as int?,
      taxAuthorityCode: fields[44] as String?,
      tCTErrorMessage: fields[45] as String?,
    )
      ..accountIdPos = fields[46] as int?
      ..timePos = fields[47] as String?
      ..shiftId = fields[48] as int?
      ..xmlInv = fields[49] as String?;
  }

  @override
  void write(BinaryWriter writer, InvoiceDetailModel obj) {
    writer
      ..writeByte(50)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.emailCc)
      ..writeByte(3)
      ..write(obj.cusEmails)
      ..writeByte(4)
      ..write(obj.parentName)
      ..writeByte(5)
      ..write(obj.comFax)
      ..writeByte(6)
      ..write(obj.arisingDate)
      ..writeByte(7)
      ..write(obj.invoiceName)
      ..writeByte(8)
      ..write(obj.invoicePattern)
      ..writeByte(9)
      ..write(obj.serialNo)
      ..writeByte(10)
      ..write(obj.invoiceNo)
      ..writeByte(11)
      ..write(obj.paymentMethod)
      ..writeByte(12)
      ..write(obj.comName)
      ..writeByte(13)
      ..write(obj.comTaxCode)
      ..writeByte(14)
      ..write(obj.comAddress)
      ..writeByte(15)
      ..write(obj.comPhone)
      ..writeByte(16)
      ..write(obj.comBankNo)
      ..writeByte(17)
      ..write(obj.comBankName)
      ..writeByte(18)
      ..write(obj.cusCode)
      ..writeByte(19)
      ..write(obj.cusName)
      ..writeByte(20)
      ..write(obj.cusTaxCode)
      ..writeByte(21)
      ..write(obj.cusPhone)
      ..writeByte(22)
      ..write(obj.cusAddress)
      ..writeByte(23)
      ..write(obj.cusBankName)
      ..writeByte(24)
      ..write(obj.cusBankNo)
      ..writeByte(25)
      ..write(obj.total)
      ..writeByte(26)
      ..write(obj.vatAmount)
      ..writeByte(27)
      ..write(obj.amount)
      ..writeByte(28)
      ..write(obj.amountInWords)
      ..writeByte(29)
      ..write(obj.buyer)
      ..writeByte(30)
      ..write(obj.exchangeRate)
      ..writeByte(31)
      ..write(obj.currencyUnit)
      ..writeByte(32)
      ..write(obj.extra)
      ..writeByte(33)
      ..write(obj.vatRate)
      ..writeByte(34)
      ..write(obj.checkDiscount)
      ..writeByte(35)
      ..write(obj.discountVatRate)
      ..writeByte(36)
      ..write(obj.totalDiscount)
      ..writeByte(37)
      ..write(obj.processInvNote)
      ..writeByte(38)
      ..write(obj.refID)
      ..writeByte(39)
      ..write(obj.status)
      ..writeByte(40)
      ..write(obj.type)
      ..writeByte(41)
      ..write(obj.ikey)
      ..writeByte(42)
      ..write(obj.refIkey)
      ..writeByte(43)
      ..write(obj.tCTCheckStatus)
      ..writeByte(44)
      ..write(obj.taxAuthorityCode)
      ..writeByte(45)
      ..write(obj.tCTErrorMessage)
      ..writeByte(46)
      ..write(obj.accountIdPos)
      ..writeByte(47)
      ..write(obj.timePos)
      ..writeByte(48)
      ..write(obj.shiftId)
      ..writeByte(49)
      ..write(obj.xmlInv);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductItemAdapter extends TypeAdapter<ProductItem> {
  @override
  final int typeId = 1;

  @override
  ProductItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductItem(
      id: fields[0] as String?,
      invId: fields[1] as int?,
      name: fields[2] as String?,
      price: fields[3] as double?,
      quantity: fields[16] as double,
      unit: fields[4] as String?,
      vatRate: fields[5] as int?,
      vatAmount: fields[6] as double?,
      amount: fields[7] as double?,
      discount: fields[8] as double?,
      discountAmount: fields[9] as double?,
      prodType: fields[10] as double?,
      isSum: fields[11] as bool,
      code: fields[12] as String?,
      total: fields[13] as double?,
      extra: fields[14] as dynamic,
      listExtraValue: (fields[15] as List).cast<String>(),
      desc: fields[17] as String?,
      feature: fields[18] as int,
    )
      ..timeStart = fields[19] as String?
      ..licensePlates = fields[20] as String?;
  }

  @override
  void write(BinaryWriter writer, ProductItem obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.invId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.vatRate)
      ..writeByte(6)
      ..write(obj.vatAmount)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.discountAmount)
      ..writeByte(10)
      ..write(obj.prodType)
      ..writeByte(11)
      ..write(obj.isSum)
      ..writeByte(12)
      ..write(obj.code)
      ..writeByte(13)
      ..write(obj.total)
      ..writeByte(14)
      ..write(obj.extra)
      ..writeByte(15)
      ..write(obj.listExtraValue)
      ..writeByte(16)
      ..write(obj.quantity)
      ..writeByte(17)
      ..write(obj.desc)
      ..writeByte(18)
      ..write(obj.feature)
      ..writeByte(19)
      ..write(obj.timeStart)
      ..writeByte(20)
      ..write(obj.licensePlates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
