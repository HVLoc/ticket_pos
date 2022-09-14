// import 'package:easy_invoice_qlhd/application/app.dart';
// import 'package:easy_invoice_qlhd/base/base.dart';
// import 'package:easy_invoice_qlhd/const/all_const.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/dashboard_controller.dart';
// import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
// import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
// import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
// import 'package:easy_invoice_qlhd/features/invoice_history/model/invoice_history_request.dart';
// import 'package:easy_invoice_qlhd/features/qr_detail/qr_detail_page.dart';
// import 'package:easy_invoice_qlhd/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sticky_header/flutter_sticky_header.dart';
// import 'package:get/get.dart';
// import 'package:loading_overlay_pro/loading_overlay_pro.dart';
// import 'package:string_validator/string_validator.dart';

// import 'filter/filter_pattern_page.dart';
// import 'invoice.dart';

// class InvoiceController extends BaseRefreshGetxController {
//   late InvoiceRepository _invoiceRepository;

//   InvoiceController() {
//     this._invoiceRepository = InvoiceRepository(this);
//   }

//   bool isOnLoading = true;

//   List<Widget> invoiceWidgets = [];

//   SliverStickyHeader? lastHeader = SliverStickyHeader();

//   // mẫu số, kí hiệu lấy sau khi login
//   List<InvoicePattern> listPatternInvoices = [];

//   // bộ lọc hiện tại;
//   late FilterInvoiceModel filter;

//   RxString patternSerialStr = "".obs;

//   List<String> listSearchHistory = [];

//   List<String> listSearchNoHistory = [];

//   RxDouble totalMoney = 0.0.obs;

//   RxBool isFilter =
//       false.obs; // true: trạng thái bộ lọc đang hoạt động, false: ngược lại

//   RxBool isSelectState = false.obs;

//   RxList<InvoiceList> listSelected = <InvoiceList>[].obs;
//   RxList<InvoiceList> listSelectedGoWrong = <InvoiceList>[].obs;

//   HomeController homeController = Get.find<HomeController>();

//   AppController appController = Get.find<AppController>();

//   // late InvoicePattern invoicePatternInvoices;

//   //Show case
//   RxBool isShowCasePattern = false.obs;

//   RxBool isShowCaseFilter = false.obs;

//   RxBool isShowCaseAction = false.obs;

//   RxBool isShowNoSerialCert = false.obs;

//   bool isNeededProfileCode = false;

//   @override
//   Future<void> onInit() async {
//     // Map arg = Get.arguments;

//     // invoicePatternInvoices = listPatternInvoices.firstWhereOrNull(
//     //       (element) =>
//     //           element.pattern == HIVE_APP.get(AppConst.keyPatternFilter) &&
//     //           element.serial == HIVE_APP.get(AppConst.keySerialFilter),
//     //     ) ??
//     //     listPatternInvoices[0];
//     filter = FilterInvoiceModel();

//     await searchInvoice(isShowLoading: true);
//     appController.isSys78.value = filter.serial.trim().isEmpty;

//     var _listHive = HIVE_APP.get(AppConst.hiveFindHistory);
//     if (_listHive != null) {
//       listSearchHistory = _listHive;
//     }

//     var _listNoHive = HIVE_APP.get(AppConst.hiveFindNoHistory);
//     if (_listNoHive != null) {
//       listSearchNoHistory = _listNoHive;
//     }
//     // isShowNoSerialCert.value = !arg["isSerialCert"];
//     // isNeededProfileCode = invoicePatternInvoices.pattern.startsWith('C', 1) &&
//     //     invoicePatternInvoices.pattern.startsWith('L', 4);

//     super.onInit();
//   }

//   @override
//   Future<void> onRefresh() async {
//     // await homeController.getListPattern();
//     refreshListPattern();
//   }

//   @override
//   Future<void> onLoadMore() async {
//     if (isOnLoading) {
//       filter..page += 1;
//       searchInvoice(loadMore: true);
//     } else {
//       refreshController.loadComplete();
//     }
//   }

//   Future<void> searchInvoice(
//       {bool isRefresh = false,
//       bool loadMore = false,
//       bool isShowLoading = false}) async {
//     bool needToShowLoading = (!isRefresh && !loadMore) || isShowLoading;
//     if (needToShowLoading) showLoading();
//     InvoiceModel? _invoicesResponse;
//     try {
//       // _invoicesResponse =
//       //     await _invoiceRepository.getInvoice(filter).whenComplete(() {
//       refreshController.refreshCompleted();
//       refreshController.loadComplete();
//       // });
//     } catch (e) {
//       print(e.toString());
//     }

//     if (isRefresh) {
//       /// xoá data cũ
//       lastHeader = null;
//       updateWidget();
//       invoiceWidgets.clear();
//       HIVE_APP.put(AppConst.keyPatternFilter, filter.pattern);
//       HIVE_APP.put(AppConst.keySerialFilter, filter.serial);

//       listPatternInvoices[0];
//     }

//     // xử lý data
//     if (_invoicesResponse != null) {
//       isOnLoading = filter.page != _invoicesResponse.totalRecords ~/ 10 + 1;
//       _addInvoiceWidgets(_invoicesResponse);
//       isShowCasePattern.value =
//           HIVE_APP.get(AppConst.keyShowCaseInvoicesPattern) ?? true;
//       if ((HIVE_APP.get(AppConst.keyShowCaseInvoicesFilter) ?? true) &&
//           invoiceWidgets.length >= 10) {
//         isShowCaseFilter.value = true;
//       }
//     }

//     if (needToShowLoading) {
//       hideLoading();
//       updatePatternSerialStr();
//     } else {
//       refreshController.refreshCompleted();
//       refreshController.loadComplete();
//     }
//   }

//   void updateWidget() {
//     invoiceWidgets.forEach((element) {
//       if (element is SliverStickyHeader) {
//         SliverStickyHeader header = element;
//         Key? valueKey = header.header?.key;
//         if (Get.isRegistered<RxList<InvoiceList>>(tag: valueKey.toString()))
//           Get.find<RxList<InvoiceList>>(tag: valueKey.toString()).clear();
//       }
//     });
//   }

//   void _addInvoiceWidgets(InvoiceModel invoiceModel) {
//     listSelected.clear();

//     Map groupByDate = _groupBy<InvoiceList, String>(
//         invoiceModel.data, (obj) => obj.arisingDate ?? '');

//     void addList(dynamic key, dynamic value) {
//       Get.find<RxList<InvoiceList>>(tag: key.toString()).addAll(value);
//     }

//     groupByDate.forEach((key, value) {
//       Key? valueKey = lastHeader?.header?.key;
//       if (valueKey == Key(key)) {
//         addList(Key(key), value);
//       } else {
//         // nếu pull to refresh, cập nhật lại list đã put thay vì xoá instance trong GetX
//         if (!Get.isRegistered<RxList<InvoiceList>>(tag: Key(key).toString()))
//           Get.put<RxList<InvoiceList>>(value, tag: Key(key).toString());
//         else // refresh
//           addList(Key(key), value);

//         invoiceWidgets.add(buildStickyHeader(key));

//         lastHeader = invoiceWidgets.last as SliverStickyHeader?;
//       }
//     });
//   }

//   Map<T, RxList<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
//     var map = <T, RxList<S>>{};
//     for (var element in values) {
//       (map[key(element)] ??= RxList()).add(element);
//     }
//     return map;
//   }

//   void updatePatternSerialStr() {
//     patternSerialStr.value =
//         "${filter.pattern} ${filter.serial.isNotEmpty ? '| ${filter.serial}' : ''} ";
//   }

//   void setCurrentListSearch(
//       List<String> listHistory, String constHiveList, String value) {
//     if (value.isNotEmpty) {
//       if (listHistory.contains(value)) {
//         listHistory.remove(value);
//       }
//       listHistory.insert(0, value);

//       listHistory.length = listHistory.length < 10 ? listHistory.length : 10;
//       HIVE_APP.put(constHiveList, listHistory);
//     }
//   }

//   void showFilterPattern() {
//     Get.bottomSheet<InvoicePattern>(FilterPatternPage(),
//             isScrollControlled: true)
//         .then((value) {
//       if (value != null) {
//         if (value.pattern != filter.pattern || value.serial != filter.serial) {
//           filter
//             ..pattern = value.pattern
//             ..serial = value.serial
//             ..page = 1;

//           appController.isSys78.value = filter.serial.trim().isEmpty;

//           updatePatternSerialStr();

//           searchInvoice(isRefresh: true, isShowLoading: true);
//         }
//       }
//     });
//   }

//   InvoiceStatus getColorCreation(int type) {
//     switch (type) {
//       case 1:
//         return InvoiceStatus(
//           1,
//           AppStr.invoiceReplaceTitle.tr,
//           AppColors.colorInvoicesReplace,
//           colorTitle: const Color(0xFF4A2E99),
//         );

//       case 2:
//       case 3:
//       case 4:
//         return InvoiceStatus(
//           2,
//           AppStr.adjusted.tr,
//           AppColors.colorInvoicesAdjusted,
//           colorTitle: const Color(0xFF001217),
//         );

//       default:
//         return InvoiceStatus(
//           3,
//           '',
//           null,
//         );
//     }
//   }

//   String textHandleOrReplace(int type) {
//     switch (type) {
//       case 1:
//         return AppStr.invoiceReplaceTitle.tr;

//       case 2:
//         return AppStr.statusHandleUp.tr;

//       case 3:
//         return AppStr.statusHandleDown.tr;

//       case 4:
//         return AppStr.statusHandleInfo.tr;

//       default:
//         return '';
//     }
//   }

//   InvoiceStatus getTCTStatus(int? type) {
//     switch (type) {
//       case -2:
//         return InvoiceStatus(
//           -2,
//           AppStr.invoicesTCTCheckStatusInvalid,
//           AppColors.colorError,
//           colorTitle: Colors.white,
//         );

//       case -1:
//         return InvoiceStatus(
//           -1,
//           AppStr.invoicesTCTCheckStatusTesting,
//           const Color(0xFF03A9F4),
//           colorTitle: const Color(0xFF001217),
//         );
//       case 1:
//         return InvoiceStatus(
//           -1,
//           AppStr.invoicesTCTCheckStatusDataValid.tr,
//           const Color(0xFF8DBD26),
//           colorTitle: const Color(0xFFffffff),
//         );

//       default:
//         return InvoiceStatus(
//           0,
//           '',
//           null,
//         );
//     }
//   }

//   void clearListSelect() {
//     listSelected.forEach((element) {
//       RxList<InvoiceList> _invoices = Get.find<RxList<InvoiceList>>(
//           tag: Key(element.arisingDate!).toString());
//       _invoices.forEach((e) {
//         e.isSelected?.value = false;
//       });
//     });

//     listSelected.clear();
//   }

//   void selectInvoices(InvoiceList item) {
//     //Nếu hóa đơn hợp lệ chuyển qua thành chọn hóa đơn gửi thông báo sai sót
//     if (item.status == listSelected.first.status &&
//         item.tCTCheckStatus == null) {
//       if (item.type == listSelected.first.type) {
//         // Chỉ chọn phát hành nhiều hóa đơn với trường hợp tạo lập thông thường
//         if ((item.type == 0) || item.id == listSelected.first.id) {
//           choiceItem(item);
//         } else {
//           showSnackBar(AppStr.invoicesNotSelectHandle.tr);
//         }
//       } else {
//         showSnackBar(AppStr.invoicesNotSelect.tr);
//       }
//     } else if (item.tCTCheckStatus != null) {
//       selectInvoiceNotice(item);
//     } else
//       showSnackBar(AppStr.invoicesNotSelect.tr);
//   }

//   void selectInvoiceNotice(InvoiceList item) {
//     //Hóa đơn hợp lệ sẽ có thể gửi thông báo sai sót
//     if (listSelected.first.status == -1 || listSelected.first.status == 0) {
//       showSnackBar(AppStr.invoicesNotSelect.tr);
//     } else if (item.tCTCheckStatus != 1 ||
//         item.tCTCheckStatus != listSelected.first.tCTCheckStatus) {
//       showSnackBar(AppStr.invoicesNotStatusSelect.tr);
//     } else {
//       choiceItem(item);
//     }
//   }

//   void choiceItem(InvoiceList item) {
//     item.isSelected?.toggle();
//     if (item.isSelected?.value ?? false) {
//       listSelected.add(item);
//       if (!item.ikey.isStringNotEmpty)
//         item.invoiceError.value = AppStr.invoiceIkeyNullIssue.tr;
//     } else {
//       listSelected.removeWhere((e) => e.id == item.id);
//     }
//   }

//   void goToInvDetail(InvoiceList item) async {
//     // if (!homeController.accountPermission.canViewInv) {
//     //   Fluttertoast.showToast(msg: AppStr.accountPermissionDenied.tr);
//     //   return;
//     // }
//     if (checkIkeyEmpty(item.ikey ?? '')) {
//       Get.to(
//         () => InvoiceDetailPage(),
//         arguments: item,
//       )?.then((value) {
//         if (value != null) {
//           this.refreshListPattern(isShowLoading: true);
//         }
//       });
//     }
//   }

//   void showInvoiceRecent(String mess, String ikey) {
//     showSnackBar(
//       mess,
//       duration: 5.seconds,
//       mainButton: BaseWidget.baseOnAction(
//         onTap: () => goToInvDetail(
//           InvoiceList(
//             pattern: filter.pattern,
//             ikey: ikey,
//           ),
//         ),
//         child: Text(
//           AppStr.view.tr,
//           style: Get.textTheme.bodyText2!.copyWith(
//             color: AppColors.linkText(),
//           ),
//         ),
//       ),
//     );
//   }

// //API
//   /// Truyền thêm controller vì hàm sử dụng ở nhiều màn hình, tránh trường hợp gọi nhầm controller
//   Future<void> pdfInvoice(BaseGetxController controller,
//       PdfInvoiceRequest pdfInvoiceRequest) async {
//     if (checkIkeyEmpty(pdfInvoiceRequest.ikey)) {
//       controller.showLoadingOverlay();
//       await getInvoicePdf(controller, pdfInvoiceRequest)
//           .whenComplete(() => controller.hideLoadingOverlay());
//     }
//   }

//   // Future<void> viewInvoice(
//   //   BaseGetxController controller,
//   //   InvoiceDetailModel invoiceList,
//   // ) async {
//   //   if (checkIkeyEmpty(invoiceList.ikey ?? '')) {
//   //     controller.showLoadingOverlay();

//   //     ViewInvoiceResponse viewInvoiceResponse = await _invoiceRepository
//   //         .viewInvoice(invoiceList)
//   //         .whenComplete(() => controller.hideLoadingOverlay());
//   //     if (viewInvoiceResponse.data.html.isNotEmpty) {
//   //       Get.to(() => HtmlViewerPage(invoiceList: invoiceList),
//   //           arguments: viewInvoiceResponse.data.html);
//   //     } else {
//   //       ShowPopup.showDialogNotification(AppStr.errorInvoiceNotFound.tr);
//   //     }
//   //   }
//   // }

//   /// Truyền thêm controller vì hàm sử dụng ở nhiều màn hình, tránh trường hợp gọi nhầm controller
//   Future<void> removeInvoice(
//     InvoiceList invoiceList,
//     BaseGetxController controller,
//   ) async {
//     if (checkIkeyEmpty(invoiceList.ikey ?? '')) {
//       ShowPopup.showDialogConfirm(
//         AppStr.invoiceDetailRemoveContain,
//         confirm: () {
//           controller.showLoadingOverlay();
//           _invoiceRepository.removeInvoice(invoiceList).then((value) {
//             if (value.status == AppConst.responseSuccess) {
//               if (Get.routing.current == AppConst.routeHome) {
//                 refreshListPattern(isShowLoading: true);
//               } else {
//                 Get.back(result: 'refresh');
//               }

//               showSnackBar(AppStr.invoiceRemoveSuccess.tr);
//             } else {
//               showSnackBar(value.message);
//             }
//           }).whenComplete(() => controller.hideLoadingOverlay());
//         },
//         actionTitle: AppStr.delete,
//       );
//     }
//   }

//   /// Truyền thêm controller vì hàm sử dụng ở nhiều màn hình, tránh trường hợp gọi nhầm controller
//   Future<void> issueInvoice(
//     List<InvoiceList> invoiceLists,
//     BaseGetxController controller,
//   ) async {
//     if (isShowNoSerialCert.value) {
//       showSnackBar(AppStr.loginNotSerialCert.tr);
//       return;
//     }
//     var _sttSerial = listPatternInvoices
//         .firstWhere((e) =>
//             e.pattern == invoiceLists.first.pattern &&
//             e.serial == invoiceLists.first.serial)
//         .statusApp;
//     bool _isAvailableInvoices = !(_sttSerial == 3 || _sttSerial == 4);

//     bool _isListAvailable() {
//       for (var i = 0; i < invoiceLists.length; i++) {
//         if (invoiceLists[i].invoiceError.isNotEmpty) return false;
//       }
//       return true;
//     }

//     bool _isIkeyAvailable() {
//       for (var i = 0; i < invoiceLists.length; i++) {
//         if (invoiceLists[i].ikey?.isEmpty ?? true) return false;
//       }
//       return true;
//     }

//     bool _isCusAvailable() {
//       for (var i = 0; i < invoiceLists.length; i++) {
//         if (!invoiceLists[i].buyer.isStringNotEmpty &&
//             !invoiceLists[i].cusName.isStringNotEmpty) {
//           invoiceLists[i].invoiceError.value = AppStr.invoiceErrorCusEmpty.tr;
//           return false;
//         }
//       }
//       return true;
//     }

//     if (_isAvailableInvoices) {
//       // Kiểm tra ikey trống
//       if (!_isIkeyAvailable()) {
//         showSnackBar(invoiceLists.length == 1
//             ? AppStr.invoiceIkeyNullIssue.tr
//             : AppStr.invoiceIkeyNullList.tr);
//         return;
//       }
//       //Kiểm tra thông tin khách hàng trong hóa đơn
//       if (!_isCusAvailable()) {
//         showSnackBar(invoiceLists.length == 1
//             ? AppStr.invoiceErrorCusEmptyStr.tr
//             : AppStr.invoiceIkeyNullList.tr);
//         return;
//       }

//       controller.showLoadingOverlay();
//       BaseResponse checkResponse = await _invoiceRepository
//           .checkInvoiceState(invoiceLists)
//           .whenComplete(() => controller.hideLoadingOverlay());
//       if (checkResponse.data is Map &&
//           checkResponse.data['KeyInvoiceMsg'] != null &&
//           checkResponse.data['KeyInvoiceMsg'] is Map) {
//         Map<String, String> _mapError =
//             Map<String, String>.from(checkResponse.data['KeyInvoiceMsg']);
//         _mapError.forEach((key, value) {
//           if (value != '0') {
//             invoiceLists
//                 .firstWhere((element) => element.ikey == key)
//                 .invoiceError
//                 .value = AppStr.invoicePublished.tr;
//           }
//         });
//       } else if (isNeededProfileCode) {
//         controller.showLoadingOverlay();
//         ShowPopup.showDialogInputProfileCode(
//             confirmFuction: (value) async => {
//                   issueInvoiceOnly(invoiceLists, controller, profileCode: value)
//                 });
//         controller.hideLoadingOverlay();
//       }
//       //Kiểm tra hóa đơn khả dụng
//       if (!_isListAvailable()) {
//         showSnackBar(invoiceLists.length == 1
//             ? invoiceLists.first.invoiceError.toString()
//             : AppStr.invoiceIkeyNullList.tr);

//         return;
//       }
//       if (!isNeededProfileCode) {
//         controller.showLoadingOverlay();
//         if (appController.isSys78.value &&
//             (invoiceLists.first.pattern?.startsWith('C', 1) ?? false))
//           controller.isLoadingOverlayIssue.value = true;
//         issueInvoiceOnly(
//           invoiceLists,
//           controller,
//         );
//       }
//     } else {
//       showSnackBar(AppStr.invoiceUnAvailableInvoices.tr);
//     }
//   }

//   //Truyền invoiceList hợp lệ sang màn thông báo hóa đơn sai sót
//   void sendInvoiceListToErrorNotice() {
//     Get.toNamed(AppConst.routeErrorNotice, arguments: listSelected)
//         ?.then((value) {
//       if (value != null) {
//         this.refreshListPattern(isShowLoading: true);
//       }
//     });
//   }

//   /// Truyền thêm controller vì hàm sử dụng ở nhiều màn hình, tránh trường hợp gọi nhầm controller
//   Future<void> sendIssuanceNotice(
//     InvoiceList invoiceList,
//     BaseGetxController controller,
//   ) async {
//     RxBool _isLoadingEmail = false.obs;
//     if (checkIkeyEmpty(invoiceList.ikey ?? '')) {
//       TextEditingController _emailController = TextEditingController();
//       List<String> listEmail =
//           HIVE_APP.get(AppConst.keyEmail) ?? []; // list  lịch sử
//       RxList<String> _listResult = <String>[].obs; // list giá trị hiện tại
//       bool _addEmailSuccess(
//         String email, {
//         bool isNotTextEdit = false,
//       }) {
//         bool _success() {
//           _listResult.add(email.trim());
//           if (!isNotTextEdit) _emailController.text = '';
//           return true;
//         }

//         if (email.trim().isNotEmpty) {
//           if (isEmail(email.trim())) {
//             if (_listResult.isNotEmpty) {
//               if (_listResult.contains(email.trim())) {
//                 showSnackBar(AppStr.invoiceNotifyEmailExist.tr);
//               } else {
//                 return _success();
//               }
//             } else {
//               return _success();
//             }
//           } else {
//             showSnackBar(AppStr.errorEmail.tr);
//           }
//         }
//         return false;
//       }

//       void _sendEmail() {
//         KeyBoard.hide();

//         _isLoadingEmail.value = true;

//         _invoiceRepository
//             .sendIssuanceNotice(invoiceList, _listResult.toList())
//             .then((value) {
//           if (value.status == AppConst.responseSuccess) {
//             _listResult.forEach((element) {
//               if (!listEmail.contains(element)) {
//                 listEmail.insert(0, element);
//               }
//             });

//             listEmail.length = listEmail.length < 10 ? listEmail.length : 10;

//             HIVE_APP.put(AppConst.keyEmail, listEmail);
//             Get.back();
//             showSnackBar(AppStr.invoiceDetailMailSuccess.tr);
//           } else {
//             showSnackBar(value.message);
//           }
//         }).whenComplete(() => _isLoadingEmail.value = false);
//       }

// // view inputchips
//       Widget _buildInputchip() {
//         final FocusNode _inputChipFocus = FocusNode();
//         List<Widget> listChip() {
//           List<Widget> _chips = [];
//           for (int i = 0; i < _listResult.length; i++) {
//             InputChip actionChip = InputChip(
//               selected: false,
//               label: Text(_listResult[i]),
//               pressElevation: 5,
//               onDeleted: () {
//                 _listResult.removeAt(i);
//               },
//               backgroundColor: AppColors.appBarColor(),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             );

//             _chips.add(actionChip);
//           }

//           return _chips;
//         }

//         return GestureDetector(
//           onTap: () =>
//               FocusScope.of(Get.context!).requestFocus(_inputChipFocus),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(
//                 horizontal: AppDimens.paddingVerySmall),
//             decoration: BoxDecoration(
//               color: AppColors.inputText(),
//               borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             ),
//             child: Wrap(
//               spacing: 10,
//               children: listChip()
//                 ..add(
//                   TextField(
//                     autofocus: true,
//                     controller: _emailController,
//                     focusNode: _inputChipFocus,
//                     scrollPadding: EdgeInsets.zero,
//                     onSubmitted: (value) {
//                       _addEmailSuccess(value);
//                       FocusScope.of(Get.context!).requestFocus(_inputChipFocus);
//                     },
//                     decoration: InputDecoration(
//                       fillColor: AppColors.inputText(),
//                       contentPadding: EdgeInsets.zero,
//                       border: InputBorder.none,
//                       hintStyle: TextStyle(
//                         fontSize: AppDimens.fontMedium(),
//                         color: AppColors.hintTextColor(),
//                       ),
//                       hintText: AppStr.emailCcHintText.tr,
//                     ),
//                   ),
//                 ),
//             ),
//           ),
//         );
//       }

//       Get.bottomSheet(
//         Obx(
//           () => LoadingOverlayPro(
//             progressIndicator: BaseWidget.buildLoading,
//             isLoading: _isLoadingEmail.value,
//             child: BaseWidget.baseBottomSheet(
//               title: AppStr.invoiceDetailMailInput,
//               iconTitle: TextButton(
//                 onPressed: () {
//                   if (_emailController.text.isStringEmpty) {
//                     if (_listResult.isEmpty) {
//                       showSnackBar(AppStr.customerNotifyEmailNull);
//                     } else {
//                       _sendEmail();
//                     }
//                   } else if (_addEmailSuccess(_emailController.text.trim())) {
//                     _sendEmail();
//                   }
//                 },
//                 style:
//                     TextButton.styleFrom(backgroundColor: AppColors.linkText()),
//                 child: Obx(() => Text(
//                       AppStr.send.tr +
//                           (_listResult.length > 0
//                               ? " (${_listResult.length})"
//                               : ""),
//                       style: Get.textTheme.bodyText2!
//                           .copyWith(color: Colors.white),
//                     )),
//               ),
//               body: SingleChildScrollView(
//                 physics: const ClampingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Obx(
//                       () => _buildInputchip().paddingOnly(
//                           top: AppDimens.paddingSmall,
//                           bottom: AppDimens.paddingHuge),
//                     ),
//                     Visibility(
//                       visible: listEmail.isNotEmpty,
//                       child: Text(
//                         AppStr.invoiceDetaiMailRecent.tr,
//                         style: Get.textTheme.bodyText1!
//                             .copyWith(color: AppColors.hintTextColor()),
//                       ),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: listEmail.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           onTap: () => _addEmailSuccess(listEmail[index],
//                               isNotTextEdit: true),
//                           leading: const Icon(
//                             Icons.mail_outline,
//                             color: AppColors.hintTextSolidColor,
//                           ),
//                           title: Text(
//                             listEmail[index],
//                             style: Get.textTheme.bodyText2!
//                                 .copyWith(color: AppColors.hintTextSolidColor),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         isScrollControlled: true,
//       );
//     }
//   }

//   Future<void> getInvoicePdf(BaseGetxController controller,
//       PdfInvoiceRequest pdfInvoiceRequest) async {
//     if (pdfInvoiceRequest.ikey.isStringNotEmpty) {
//       var res = await _invoiceRepository.getInvoicePdf(pdfInvoiceRequest);
//       openFile(controller, res);
//     } else
//       showSnackBar(AppStr.invoiceIkeyNull.tr);
//   }

//   void closeNotiNoSerialCert() {
//     isShowNoSerialCert.value = false;
//   }

//   void refreshListPattern({bool isShowLoading = false}) {
//     Get.find<DashboardController>().onRefresh();
//     filter..page = 1;
//     searchInvoice(isRefresh: true, isShowLoading: isShowLoading);
//   }

//   void showQrDetail(
//     BaseGetxController controller,
//     InvoiceList invoiceList,
//   ) {
//     Get.to(
//       () => QRDetailInvoicePage(
//         qrImage: '',
//         invoiceList: invoiceList,
//       ),
//     );
//   }

//   void publishWithProfileCode(InvoiceList item) {
//     if (listSelected.isEmpty) {
//       choiceItem(item);
//     } else if (listSelected.length == 1) {
//       if (item.isSelected?.value ?? false) {
//         choiceItem(item);
//       } else {
//         showSnackBar(AppStr.invoicePublishOnlyInvError, duration: 5.seconds);
//       }
//     }
//   }

//   void issueInvoiceOnly(
//     List<InvoiceList> invoiceLists,
//     BaseGetxController controller, {
//     String? profileCode,
//   }) async {
//     BaseResponse res;
//     res = await _invoiceRepository
//         .issueInvoice(invoiceLists, profileCode)
//         .whenComplete(() {
//       controller.hideLoadingOverlay();
//       if (appController.isSys78.value &&
//           (invoiceLists.first.pattern?.startsWith('C', 1) ?? false))
//         controller.isLoadingOverlayIssue.value = false;
//     });
//     if (res.status == AppConst.responseSuccess) {
//       controller.isIssueSuccess.value = true;
//       await 1.seconds.delay();
//       controller.isIssueSuccess.value = false;
//       if (Get.routing.current == AppConst.routeHome) {
//         searchInvoice(isRefresh: true, isShowLoading: true);
//         showSnackBar(AppConst.invoiceIssueSuccessNumber
//             .trParams({'length': invoiceLists.length.toString()}).toString());
//         listSelected.clear();
//       } else {
//         Get.back(result: 'refresh');
//         showSnackBar(AppStr.invoiceIssueSuccess.tr);
//       }
//       refreshListPattern();
//     } else if (res.status != AppConst.error400) {
//       if (res.data.keyInvoiceMsg != null && res.data.keyInvoiceMsg is Map) {
//         Map<String, String> _mapError =
//             Map<String, String>.from(res.data.keyInvoiceMsg);
//         _mapError.forEach((key, value) {
//           invoiceLists
//               .firstWhere((element) => element.ikey == key)
//               .invoiceError
//               .value = value;
//         });
//       }
//       showSnackBar(formatMessError(res.data.keyInvoiceMsg),
//           duration: 5.seconds);
//     }
//   }

//   void getToHistory(InvoiceList item) {
//     Get.toNamed(AppConst.routeHistoryInvoice,
//         arguments: HistoryRequest(
//             pattern: item.pattern, no: int.parse(item.invoiceNo ?? '')));
//   }
// }
