import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';

class DataEmpty extends StatelessWidget {
  final String dataEmpty;

  DataEmpty({Key? key, this.dataEmpty = AppStr.dataEmpty}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
            child: Text(
          dataEmpty,
          style: TextStyle(
            fontSize: AppDimens.fontMedium(),
            color: AppColors.textColor(),
          ),
        )),
      ),
    );
  }
}
