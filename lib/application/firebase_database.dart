// import 'package:easy_invoice_qlhd/const/all_const.dart';
// import 'package:easy_invoice_qlhd/utils/utils.dart';
// import 'package:firebase_database/firebase_database.dart';

// import 'app.dart';

// class FirebaseDataBase {
//   static firebaseRef() => FirebaseDatabase.instance
//       .ref()
//       .child(userCredential.user?.uid ?? 'bSGxIXztcAMZMyT7WBkld5YvtoG3')
//       .child(HIVE_APP.get(AppConst.keyTaxCodeCompany));

//   /// Khi MST chưa được config HSM/Token....
//   static void createCAAccount({String phone = ''}) {
//     String accountName = HIVE_APP.get(AppConst.keyUserName);
//     String accountTaxCode = HIVE_APP.get(AppConst.keyTaxCodeCompany);
//     String createdDate = convertDateToString(DateTime.now(), PATTERN_7);

//     var invoiceHsm = _getInvoiceHSM(accountName);

//     // invoiceHsm.once().then((snap) {
//     //   if (snap.value != null) {
//     //     invoiceHsm.update({
//     //       "modifyDate": createdDate,
//     //       "phone": phone,
//     //       "created": 0 // hardcode by CRM
//     //     });
//     //   } else {
//     //     invoiceHsm.set({
//     //       "MST": accountTaxCode,
//     //       "accountName": accountName,
//     //       "createdDate": createdDate,
//     //       "phone": phone,
//     //       "modifyDate": createdDate,
//     //       "created": 0 // hardcode by CRM
//     //     });
//     //   }
//     // });
//   }

//   /// Khi có nhu cầu mua thêm số hoá đơn
//   static Future<InvoiceExtendRetStr> sendInvoiceExtendData(
//       String pattern, String serial, String invoiceExtendNumber,
//       {String phone = ''}) async {
//     String accountTaxCode = HIVE_APP.get(AppConst.keyTaxCodeCompany);
//     String createdDate = convertDateToString(DateTime.now(), PATTERN_7);

//     var invoiceHsm = _getInvoiceExtend(pattern, serial);

//     invoiceExtendNumber =
//         invoiceExtendNumber.replaceAll(',', '').replaceAll('.', '');

//     List<dynamic> newData = [];

//     // await invoiceHsm.once().then((snap) {
//     //   if (snap.snapshot.value != null) {
//     //     List<dynamic> oldData =
//     //         snap.value['data']; // oldData is fixed Length list
//     //     newData = List.from(oldData)
//     //       ..add({
//     //         "invoiceExtendNumber": invoiceExtendNumber,
//     //         "createdDate": createdDate,
//     //         "phone": phone,
//     //       });
//     //     invoiceHsm.update({
//     //       "lastModifyDate": createdDate,
//     //       "created": 0, // hardcode by CRM
//     //       "data": newData,
//     //     });
//     //   } else {
//     //     newData = [
//     //       {
//     //         "invoiceExtendNumber": invoiceExtendNumber,
//     //         "createdDate": createdDate,
//     //         "phone": phone,
//     //       }
//     //     ];
//     //     invoiceHsm.set({
//     //       "taxCode": accountTaxCode,
//     //       "data": newData,
//     //       "pattern": pattern,
//     //       "serial": serial,
//     //       "createdDate": createdDate,
//     //       "lastModifyDate": createdDate,
//     //       "created": 0 // hardcode by CRM
//     //     });
//     //   }
//     // });
//     return InvoiceExtendRetStr(newData);
//   }

//   static Future<InvoiceExtendRetStr> getLastInvoiceStr(
//       String pattern, String serial) async {
//     DatabaseReference dbRef = _getInvoiceExtend(pattern, serial);
//     List<dynamic> data = [];
//     // await dbRef.child('data').once().then((value) {
//     //   if (value.value != null) data = value.value;
//     // });
//     return InvoiceExtendRetStr(data);
//   }

//   static DatabaseReference _getInvoiceHSM(String accountName) {
//     return firebaseRef()
//         .ref()
//         .child('invoice_hsm')
//         .child('$accountName${HIVE_APP.get(AppConst.keyTaxCodeCompany)}');
//   }

//   static DatabaseReference _getProductChild() {
//     return firebaseRef().ref().child("Products");
//   }

//   static DatabaseReference _getInvoiceExtend(String pattern, String serial) {
//     return firebaseRef().ref().child('invoice_extend').child(
//         '${HIVE_APP.get(AppConst.keyTaxCodeCompany)}_$pattern$serial'
//             .replaceAll('/', '-'));
//   }
// }

// class InvoiceExtendRetStr {
//   final String leadingStr = 'Quý khách đã gửi ';
//   final String subContentStr = ' yêu cầu với tổng số hóa đơn yêu cầu mua thêm ';
//   late String dataLengthStr;
//   late String totalExtendNumber;

//   InvoiceExtendRetStr(List<dynamic> data) {
//     int extendNumber = 0;
//     data.forEach((element) {
//       extendNumber += int.tryParse(element['invoiceExtendNumber']) ?? 0;
//     });
//     this.dataLengthStr = '${data.length}';
//     this.totalExtendNumber = '${CurrencyUtils.formatMoney(extendNumber)}';
//   }
// }
