import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../utils.dart';

class BuildInputTextWithLabel extends StatelessWidget {
  final BuildInputText buildInputText;
  final String label;
  final TextStyle? textStyle;

  const BuildInputTextWithLabel({
    Key? key,
    required this.label,
    required this.buildInputText,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          label,
          style: textStyle ?? Get.textTheme.bodyText2,
        ),
        const SizedBox(
          height: 5,
        ),
        buildInputText,
      ],
    );
  }
}
