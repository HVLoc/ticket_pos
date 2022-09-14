import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base_refresh_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/model/invoice_detail_response.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'invoice.dart';

part 'invoice_widget.dart';

class InvoicePage extends BaseRefreshWidget<InvoicesController> {
  InvoicePage({Key? key}) : super(key: key);

  @override
  InvoicesController get controller => Get.put(InvoicesControllerImp());

  @override
  Widget buildWidgets() {
    controller.getListInvoiceWithFilter();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: buildLoadingOverlay(
        () => buildPage(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              backgroundColor: AppColors.appBarInvoice(),
              leading: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: controller.showFilterInputSearchInvoiceNo,
              ),
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                child: Text(
                  AppStr.invoicestitle,
                  style: Get.theme.textTheme.bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
              centerTitle: true,
              leadingWidth: 70,
              actions: [
                Container(
                  width: 70,
                  child: Obx(
                    () => IconButton(
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            const Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.white,
                            ),
                            if (controller.isFilter.value)
                              const Positioned(
                                top: 10,
                                right: -3.0,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              )
                          ],
                        ),
                        onPressed: controller.showFilterPage),
                  ),
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child:
                      baseShimmerLoading(() => _buildListInvoice(controller))),
              BaseWidget.buildCardBase(
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppStr.imgProfile1),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.printTicket();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppStr.imgProfile3),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStr.ticketReportPrint,
                                style: Get.textTheme.subtitle1?.copyWith(
                                  color: AppColors.textColorWhite,
                                ),
                              ),
                              const Icon(
                                Icons.print,
                                size: AppDimens.sizeIconLarge,
                                color: AppColors.textColorWhite,
                              ),
                            ],
                          ).paddingAll(AppDimens.paddingVerySmall),
                        ),
                      ),
                      BaseWidget.buildDivider(height: 0),
                      BaseWidget.sizedBox10,
                      rowPayment(
                          AppStr.invoiceCreationTotalPay + ":",
                          CurrencyUtils.formatCurrency(
                              controller.totalMoney.value)),
                      BaseWidget.buildDivider(),
                      rowPayment(AppStr.totalTicket,
                          controller.listInvoiceDetailModel.length.toString()),
                    ],
                  ),
                ),
              )
            ],
          ),
          isShowSupportCus: Get.find<AppController>().isShowSupportCus,
          isNeedUpToPage: true,
          statusBarColor: AppColors.statusBarInvoice(),
        ),
      ),
    );
  }
}
