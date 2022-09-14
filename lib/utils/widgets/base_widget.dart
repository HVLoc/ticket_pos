import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_spinbox_fork/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils.dart';

class BaseWidget {
  static DateTime? _dateTime;
  static int _oldFunc = 0;

  static const Widget sizedBox10 = const SizedBox(height: 10);
  static const Widget sizedBox5 = const SizedBox(height: 5);
  static const Widget sizedBoxPaddingHuge =
      const SizedBox(height: AppDimens.paddingHuge);
  static const Widget sizedBoxPadding =
      const SizedBox(height: AppDimens.defaultPadding);

  static Widget buildSafeArea(Widget childWidget,
      {double miniumBottom = 12, Color? color}) {
    return Container(
      color: color ?? AppColors.appBarColor(),
      child: SafeArea(
        bottom: true,
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.only(bottom: miniumBottom),
        child: childWidget,
      ),
    );
  }

  static Widget buildLogo(String imgLogo, double height) {
    return SizedBox(
      height: height,
      child: Image.asset(imgLogo),
    );
  }

  static const Widget buildLoading = CupertinoActivityIndicator();

  static buildAppBarTitle(String title,
      {bool? textAlignCenter, Color? textColor}) {
    textAlignCenter = textAlignCenter ?? GetPlatform.isAndroid;
    return AutoSizeText(
      title.tr,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.left,
      style: AppStyle.textTitleWhiteStyle
          .copyWith(color: textColor ?? AppColors.textColor()),
      maxLines: 2,
    );
  }

  static Widget buildTitle(String title) {
    return Text(
      title.tr,
      textScaleFactor: 1,
      style: AppStyle.textTitleWhiteStyle
          .copyWith(color: AppColors.hintTextColor()),
      textAlign: TextAlign.center,
    );
  }

  static Widget buildButtonIconBeforeText(
    Widget icon,
    String btnTitle, {
    required onPressed,
    backgroundColor,
    minimumSize,
  }) {
    return ElevatedButton.icon(
      icon: icon,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        shadowColor: MaterialStateProperty.all(AppColors.appBarColor1),
      ),
      label: Text(
        btnTitle,
      ),
      onPressed: onPressed,
    ).paddingAll(
      AppDimens.paddingSmall,
    );
  }

  static Widget buildButtonIconAfterText(
    String btnTitle, {
    IconData? icon,
    required onPressed,
    backgroundColor,
    minimumSize,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        backgroundColor: backgroundColor,
        minimumSize: minimumSize,
        shadowColor: MaterialStateProperty.all(AppColors.appBarColor1),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(btnTitle),
          Icon(icon).paddingOnly(
            left: 5,
          ),
        ],
      ),
    ).paddingAll(
      AppDimens.paddingSmall,
    );
  }

  static Widget buildButton(String btnTitle, Function function,
      {List<Color> colors = AppColors.colorGradientOrange,
      bool isLoading = false,
      bool showLoading = true}) {
    return Container(
      width: double.infinity,
      height: AppDimens.btnMedium,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(8)),
      child: BaseWidget.baseOnAction(
        onTap: !isLoading ? function : () {},
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(btnTitle.tr,
                    style: TextStyle(
                        fontSize: AppDimens.fontMedium(), color: Colors.white)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: isLoading && showLoading,
                  child: Container(
                    height: AppDimens.btnSmall,
                    width: AppDimens.btnSmall,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.colorError,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildGradientText(Text textWidget,
      {LinearGradient linearGradient = const LinearGradient(
          colors: AppColors.colorGradientBlue,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)}) {
    // gradient chỉ hiển thị khi text màu trắng
    textWidget.style?.copyWith(color: Colors.white);
    return ShaderMask(
        shaderCallback: (bounds) => linearGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
        child: textWidget);
  }

  static Widget buildSmartRefresherCustomFooter() {
    return CustomFooter(
      builder: (context, mode) {
        if (mode == LoadStatus.loading) {
          return const CupertinoActivityIndicator();
        } else {
          return const Opacity(
            opacity: 0.0,
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  static Widget buildDivider(
      {double height = 10.0, double thickness = 1.0, double indent = 0.0}) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: indent,
    );
  }

  static Widget buildSpinBox(
    RxDouble value,
    Function(double?) onChanged,
    Icon decrementIcon, {
    double sizeIcon = AppDimens.sizeDialogNotiIcon,
  }) {
    return CupertinoSpinBox(
      min: 0.0,
      max: 999999999.0,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(),
      value: value.value,
      textStyle: Get.textTheme.bodyText1,
      onChanged: onChanged,
      numOfDecimals: 0,
      // numOfDecimals: Get.find<AppController>().isSys78.value ? 6 : 3,
      incrementIcon: Icon(
        Icons.add_box,
        size: sizeIcon,
        color: AppColors.spinboxColor(),
      ),
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      decrementIcon: decrementIcon,
    );
  }

  static List<String> _listVATStr = AppStr.listVAT.values.toList();

  static Widget buildChipVAT(int currentVatRate, Function(String) func,
      {bool isUpperCase = true}) {
    final _width = (Get.size.width - 4 * AppDimens.defaultPadding) / 8;
    return buildCardBase(
      Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              isUpperCase
                  ? AppStr.productDetailVAT.tr.toUpperCase()
                  : AppStr.productDetailVAT.tr,
              style: Get.textTheme.bodyText2,
            ).paddingOnly(bottom: AppDimens.paddingSmall),
            Row(
              // alignment: WrapAlignment.spaceEvenly,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(AppStr.listVAT.length, (index) {
                bool isChoose = AppStr.listVAT.entries
                        .firstWhere((element) => element.key == currentVatRate)
                        .value ==
                    _listVATStr[index];
                return Expanded(
                  child: ChoiceChip(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.chipColorTheme(),
                    selectedColor: AppColors.linkText(),
                    labelStyle: TextStyle(
                        color: isChoose ? Colors.white : AppColors.linkText()),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(
                          color: isChoose
                              ? AppColors.linkText()
                              : Colors.transparent,
                        )),
                    label: SizedBox(
                        width: _width,
                        child: AutoSizeText(
                          _listVATStr[index],
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        )),
                    selected: isChoose,
                    onSelected: (val) {
                      func(_listVATStr[index]);
                    },
                  ).paddingAll(5),
                );
              }),
            ),
          ],
        ).paddingAll(AppDimens.paddingSmall),
      ),
    );
  }

  static Widget buildInvoiceEmpty({
    required Function onRefresh,
    required Function() removeFilter,
    required Map<String, String> emptyStrs,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStr.dataEmptyWhen.tr,
            style: Get.textTheme.headline6!
                .copyWith(color: AppColors.hintTextColor()),
          ),
          Wrap(
              direction: Axis.vertical,
              children: emptyStrs.entries
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key,
                            style: Get.textTheme.bodyText1!
                                .copyWith(color: AppColors.hintTextColor()),
                          ),
                          Text(e.value,
                              style: Get.textTheme.bodyText1!
                                  .copyWith(color: AppColors.textColor()))
                        ],
                      ))
                  .toList()),
          sizedBox10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                height: AppDimens.btnMedium,
                decoration: BoxDecoration(
                    color: AppColors.colorError,
                    borderRadius: BorderRadius.circular(40)),
                child: baseOnAction(
                  onTap: removeFilter,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    child: Text(AppStr.removeFilter.tr,
                        style: Get.textTheme.bodyText1!
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ),
              Container(
                width: 150,
                height: AppDimens.btnMedium,
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(40)),
                child: baseOnAction(
                  onTap: onRefresh,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    child: Text(AppStr.refresh.tr,
                        style: Get.textTheme.bodyText1!
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: AppDimens.defaultPadding),
    );
  }

  static Widget buildEmpty(
      {required Function onRefresh, String emptyStr = AppStr.dataEmpty}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          baseOnAction(
            onTap: onRefresh,
            child: const IconButton(
              icon: Icon(
                Icons.refresh,
                size: AppDimens.sizeIconMedium,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ),
          Center(
            child: Text(
              emptyStr.tr,
              style: Get.theme.textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildListAndBtn({required Widget child, Widget? buildBtn}) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          Visibility(visible: buildBtn != null, child: buildBtn ?? Container())
        ],
      ),
    );
  }

  /// Widget cài đặt việc refresh page
  static Widget buildSmartRefresher({
    required RefreshController refreshController,
    required Widget child,
    ScrollController? scrollController,
    Function()? onRefresh,
    Function()? onLoadMore,
    bool enablePullUp = false,
  }) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: enablePullUp,
      scrollController: scrollController,
      header: const MaterialClassicHeader(),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      footer: BaseWidget.buildSmartRefresherCustomFooter(),
      child: child,
    );
  }

  static Widget buildShimmerLoading() {
    const _padding = AppDimens.defaultPadding;
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: _padding, vertical: _padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: ListView.separated(
                  itemBuilder: (context, index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 24.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          sizedBox10,
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 16.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  height: 16.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          sizedBox10,
                        ],
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 15,
                      ),
                  itemCount: 10),
            ),
          ),
        ],
      ),
    );
  }

  static List<TextSpan> highlightText(
      String source, String query, Color colorHighlight) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
      } else if (match.start <= lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.end),
            style: Get.textTheme.bodyText2!.copyWith(
              color: AppColors.textColor(),
              backgroundColor: colorHighlight,
            ),
          ),
        );
      } else if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.start),
          ),
        );

        children.add(
          TextSpan(
            text: source.substring(match.start, match.end),
            style: Get.textTheme.bodyText2!.copyWith(
              color: AppColors.textColor(),
              backgroundColor: colorHighlight,
            ),
          ),
        );
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(
        TextSpan(
          text: source.substring(lastMatchEnd, source.length),
        ),
      );
    }

    return children;
  }

  static List<TextSpan> textImportantStrings({
    required String source,
    required String textImportants,
  }) {
    int start = source.indexOf(textImportants);
    int end = start + textImportants.length;

    return [
      TextSpan(text: source.substring(0, start)),
      TextSpan(
        text: source.substring(start, end),
        style: Get.textTheme.bodyText1!.copyWith(color: AppColors.chipColor),
      ),
      TextSpan(text: source.substring(end)),
    ];
  }

  static Widget baseBottomSheet(
      {required String title,
      required Widget body,
      Widget? iconTitle,
      bool isSecondDisplay = false}) {
    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(
          top: Get.mediaQuery.padding.top + (isSecondDisplay ? 100 : 20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.bottomSheet(),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 6,
                margin: const EdgeInsets.all(AppDimens.paddingSmall),
                decoration: BoxDecoration(
                    color: AppColors.textColor(),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(title.tr,
                          textAlign: iconTitle == null
                              ? TextAlign.center
                              : TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.headline6!
                              .copyWith(color: AppColors.textColor()))
                      .paddingSymmetric(vertical: AppDimens.paddingSmall),
                ),
                iconTitle ?? const SizedBox(),
              ],
            ),
            Expanded(child: body),
          ],
        ).paddingSymmetric(horizontal: AppDimens.defaultPadding),
      ),
    );
  }

  static Widget buildButtonIcon({
    required IconData icons,
    required Function func,
    required Color colors,
    required String title,
    double sizeIcon = 20,
    double radius = 30,
    double padding = 8.0,
    Color? textColor,
    Color? iconColor = AppColors.hintTextSolidColor,
    String? imgAsset,
  }) =>
      BaseWidget.baseOnAction(
        onTap: func,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: colors,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: imgAsset != null
                  ? Image.asset(
                      imgAsset,
                      fit: BoxFit.cover,
                      height: sizeIcon,
                      width: sizeIcon,
                    )
                  : Icon(
                      icons,
                      color: iconColor,
                      size: sizeIcon,
                    ),
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                title.tr,
                style: Get.theme.textTheme.subtitle2!.copyWith(
                    color: textColor ?? AppColors.textColor(), fontSize: 12),
              ),
            ]
          ],
        ),
      );
  static Widget buildButtonIconGradient({
    required String title,
    required IconData iconData,
    required Function function,
    required List<Color> colorGradient,
    bool isValueNull = false,
  }) =>
      BaseWidget.baseOnAction(
        onTap: function,
        child: Column(children: [
          Container(
            width: AppDimens.sizeIconLarge,
            height: AppDimens.sizeIconLarge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    !isValueNull ? colorGradient : AppColors.colorGradientGray,
              ),
            ),
            child: Icon(iconData),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: Get.textTheme.subtitle2!.copyWith(
                fontSize: AppDimens.fontSmallest(), color: Colors.white54),
          )
        ]),
      );

  static Widget buildCardBase(Widget child,
          {Color? colorBorder, Color? backgroundColor}) =>
      Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.cardBackgroundColor(),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: colorBorder ?? Colors.transparent,
            ),
          ),
          child: child);

  static Widget buildTitleInfo({required String title, String? info}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                Get.textTheme.subtitle1!.copyWith(color: AppColors.titleText),
          ),
          Text('${info?.trim()}', style: Get.textTheme.bodyText1)
              .paddingSymmetric(vertical: AppDimens.paddingVerySmall),
          buildDivider(height: 1)
        ],
      ).paddingOnly(bottom: AppDimens.paddingVerySmall);

  /// Sử dụng để tránh trường hợp click liên tiếp khi thực hiện function
  static Widget baseOnAction({
    required Function onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: () {
        DateTime now = DateTime.now();
        if (_dateTime == null ||
            now.difference(_dateTime ?? DateTime.now()) > 1.seconds ||
            onTap.hashCode != _oldFunc) {
          _dateTime = now;
          _oldFunc = onTap.hashCode;
          onTap();
        }
      },
      child: child,
    );
  }

  static Future<DateTime?> buildDateTimePicker({
    required DateTime dateTimeInit,
    DateTime? minTime,
    DateTime? maxTime,
  }) async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: Get.context!,
      height: 310,
      initialDate: dateTimeInit,
      firstDate: minTime ?? DateTime.utc(DateTime.now().year - 10),
      lastDate: maxTime,
      // barrierDismissible: true,
      theme: ThemeData(
        primaryColor: AppColors.appBarColor(),
        dialogBackgroundColor: AppColors.dateTimeColor(),
        primarySwatch: Colors.deepOrange,
        disabledColor: AppColors.hintTextColor(),
        textTheme: TextTheme(
          caption: Get.textTheme.bodyText1!
              .copyWith(color: AppColors.hintTextColor()),
          bodyText2: Get.textTheme.bodyText1,
        ),
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        paddingMonthHeader: const EdgeInsets.all(15),
        textStyleMonthYearHeader: Get.textTheme.bodyText1,
        colorArrowNext: AppColors.hintTextColor(),
        colorArrowPrevious: AppColors.hintTextColor(),
        textStyleButtonNegative:
            Get.textTheme.bodyText1!.copyWith(color: AppColors.hintTextColor()),
        textStyleButtonPositive:
            Get.textTheme.bodyText1!.copyWith(color: AppColors.linkText()),
      ),
    );
    return newDateTime;
  }

  static Widget buildItemShowBottomSheet({
    required IconData icon,
    required String title,
    required Function function,
    required Color backgroundIcons,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundIcons,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ).marginOnly(left: 5),
      contentPadding: const EdgeInsets.all(8),
      title: Text(title.tr,
          style:
              Get.textTheme.subtitle1!.copyWith(color: AppColors.textColor())),
      onTap: () {
        Get.back();
        function();
      },
    );
  }

  // Show case
  static Widget buildBlur({double blur = 3.0}) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
      ),
      child: Container(color: Colors.transparent),
    );
  }

  static Widget buildTouchApp({IconData iconData = Icons.touch_app}) {
    return Icon(
      iconData,
      size: AppDimens.sizeIconLarge,
      color: AppColors.textColor(),
    );
  }

  static Widget buildAnimationShowCaseHeadShake(Widget child,
      {Duration? duration}) {
    return HeadShake(
      preferences: AnimationPreferences(
          autoPlay: AnimationPlayStates.Loop, duration: duration ?? 1.seconds),
      child: child,
    );
  }

  static Widget buildAnimationShowCaseHeartBeat(Widget child) {
    return HeartBeat(
      preferences:
          const AnimationPreferences(autoPlay: AnimationPlayStates.Loop),
      child: child,
    );
  }

  static Widget buildAnimationShowCaseSlideSlideOutLeft(Widget child) {
    return SlideOutLeft(
      preferences: AnimationPreferences(
        autoPlay: AnimationPlayStates.Loop,
        duration: 10.seconds,
      ),
      child: child,
    );
  }

  static Widget buildMainButtonPhone() {
    return BaseWidget.baseOnAction(
      onTap: () async {
        if (await canLaunchUrlString(AppStr.telSupportNumber.tr)) {
          await launchUrlString(AppStr.telSupportNumber.tr);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingVerySmall),
        decoration: BoxDecoration(
          color: AppColors.appBarColor(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.phone,
          color: AppColors.colorBlueAccent,
          size: 20,
        ),
      ).paddingOnly(right: AppDimens.paddingVerySmall),
    );
  }

//chờ có ảnh không có thông báo để sử dụng dùng tạm icon
  static Widget buildImgError() {
    return Container(
      child: Image.asset(AppStr.imgEmptyNotification.tr),
    );
  }

//chờ có ảnh mất kết nối để thay thế tạm dùng icon
  static Widget buildImgLostConnect() {
    return Container(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.perm_data_setting_rounded,
              size: AppDimens.sizeIconExtraLarge,
              color: AppColors.hintTextColor(),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(AppStr.dashboardCannotConnect.tr,
                style: Get.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }

  static Widget buildEmptyIcon(
    IconData icon,
    String title,
  ) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppDimens.sizeIconExtraLarge,
            color: AppColors.iconEmpty(),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              title.tr,
              style: Get.textTheme.subtitle2!
                  .copyWith(fontSize: AppDimens.fontMedium()),
            ).paddingSymmetric(vertical: AppDimens.paddingSmall),
          ),
        ],
      ),
    );
  }

  static Widget buildDropdown(
    Map<int, String> mapData, {
    required Rx<int?> item,
    double height = 50,
    Color fillColor = AppColors.darkPrimaryColor,
    Function(int?)? onChanged,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: DropdownButtonHideUnderlineCustom(
          child: DropdownButtonCustom<int>(
            dropdownColor: fillColor,
            isExpanded: true,
            items: mapData
                .map((key, value) {
                  return MapEntry(
                      key,
                      DropdownMenuItemCustom<int>(
                        value: key,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mapData[key] ?? "",
                            style: Get.textTheme.subtitle1,
                          ),
                        ),
                      ));
                })
                .values
                .toList(),
            value: item.value,
            onChanged: onChanged,
          ),
        ).paddingOnly(left: AppDimens.paddingSmall),
      ).paddingOnly(
        bottom: AppDimens.paddingTitleAndTextForm,
      ),
    );
  }
}
