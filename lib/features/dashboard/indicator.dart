import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final String percent;
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.percent,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color,
                  spreadRadius: 1,
                  blurRadius: 9.5,
                  offset: Offset.zero, // changes position of shadow
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              percent,
              style: TextStyle(
                  fontSize: AppDimens.fontBig(),
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: AppDimens.fontMedium(),
                  fontWeight: FontWeight.bold,
                  color: textColor),
            ),
          ],
        )
      ],
    );
  }
}
