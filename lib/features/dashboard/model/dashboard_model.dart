import 'dart:ui';

// class DashBoard {
//   final String totalAmout;
//   final String totalInvoice;
//   final String totalInvoiceExist;

//   DashBoard(this.totalAmout, this.totalInvoice, this.totalInvoiceExist);
// }

class BarChartModel {
  final String month;
  final int financial;

  BarChartModel(this.month, this.financial);
}

class PieChartModel {
  final String title;
  final int financial;
  final Color color;

  PieChartModel(this.title, this.financial, this.color);
}

// class SerialCouterModel {
//   final String pattern;
//   final String serial;
//   final int usedInvoice;
//   final int totalInvoice;

//   SerialCouterModel(
//       {this.pattern, this.serial, this.usedInvoice, this.totalInvoice});
// }
