import 'package:easy_invoice_qlhd/base/base_page_search_controller.dart';
import 'package:easy_invoice_qlhd/base/base_refresh_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BasePageSearchWidget<T extends BasePageSearchController>
    extends BaseRefreshWidget<T> {
  /// Widget cài đặt appbar có thể scroll.
  ///
  ///  `listSLiverAppBar`, danh sách sliverappbar.
  ///
  ///  `widgetBody` widget chính của page dưới appbar.
  Widget buildAppBarScroll({
    required List<Widget> listSliverAppBar,
    required Widget widgetBody,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        KeyBoard.hide();
      },
      child: NestedScrollView(
        physics: const PageScrollPhysics(),
        controller: controller.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return listSliverAppBar;
        },
        body: widgetBody,
      ),
    );
  }

  /// list sliver appbar.
  ///
  ///  `titleAppBar` chuỗi tiêu đề trên appbar.
  ///
  ///  `hintTextSearch` chuỗi tiêu đề ẩn trên inputtext.
  List<Widget> listSliverAppBar({
    required String titleAppBar,
    required String hintTextSearch,
    Widget? widgetDesc,
    List<Widget>? actions,
  }) {
    return <Widget>[
      Obx(
        () => SliverAppBar(
          backgroundColor: AppColors.appBarColor(),
          floating: false,
          pinned: false,
          elevation: 0,
          automaticallyImplyLeading: controller.isScrollToTop(),
          actions: actions,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: GetPlatform.isAndroid,
              collapseMode: CollapseMode.parallax,
              title: BaseWidget.buildAppBarTitle(titleAppBar),
            );
          }),
        ),
      ),
      Obx(
        () => SliverAppBar(
          backgroundColor: AppColors.appBarColor(),
          pinned: true,
          floating: true,
          elevation: 0,
          centerTitle: true,
          expandedHeight: widgetDesc != null
              ? AppDimens.sizeAppBarBig
              : AppDimens.sizeAppBar,
          collapsedHeight: widgetDesc != null
              ? AppDimens.sizeAppBarBig
              : AppDimens.sizeAppBar,
          automaticallyImplyLeading: !controller.isScrollToTop(),
          actions: !controller.isScrollToTop() ? actions : null,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: BuildInputText(
                  InputTextModel(
                    prefixIconColor: AppColors.hintTextColor(),
                    controller: controller.searchController,
                    currentNode: null,
                    submitFunc: (v) => controller.functionSearch(),
                    iconNextTextInputAction: TextInputAction.search,
                    hintText: hintTextSearch,
                    iconLeading: Icons.search,
                    fillColor: AppColors.inputTextWhite(),
                  ),
                ),
              ).paddingOnly(
                  left: !controller.isScrollToTop()
                      ? AppDimens.paddingSearchBarBig
                      : AppDimens.paddingSearchBarSmall,
                  right: !controller.isScrollToTop()
                      ? AppDimens.paddingSearchBarBig
                      : AppDimens.paddingSearchBarSmall,
                  top: AppDimens.paddingVerySmall,
                  bottom: AppDimens.paddingSmall),
              if (widgetDesc != null) widgetDesc
            ],
          ),
        ),
      ),
    ];
  }

  /// widget cấu hình từng item trong listview
  Widget widgetItemList(int index);
}
