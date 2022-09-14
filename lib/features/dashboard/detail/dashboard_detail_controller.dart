// import 'package:easy_invoice_qlhd/application/firebase_database.dart';
// import 'package:easy_invoice_qlhd/base/base.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/hmtl_view_page/html_viewer_model/html_viewer_repository.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/hmtl_view_page/html_viewer_model/html_viewer_request.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/hmtl_view_page/html_viewer_model/html_viewer_response.dart';
// import 'package:get/get.dart';

// import '../dashboard.dart';

// class DashBoardDetailController extends BaseGetxController {
//   Rx<InvoiceExtendRetStr> invoiceExtend = InvoiceExtendRetStr([]).obs;
//   late HtmlViewerRepository htmlViewerRepository;
//   final String pattern;
//   final String serial;
//   final DashboardController dashBoardController =
//       Get.find<DashboardController>();

//   DashBoardDetailController(this.pattern, this.serial) {
//     this.htmlViewerRepository = HtmlViewerRepository(this);
//   }

//   @override
//   void onInit() {
//     getInvoiceExtend();
//     super.onInit();
//   }

//   void getInvoiceExtend() async {
//     invoiceExtend.value =
//         await FirebaseDataBase.getLastInvoiceStr(pattern, serial);
//   }

//   Future<HtmlViewerResponse?> getHtmlViewer() async {
//     try {
//       showLoadingOverlay();
//       var res = await htmlViewerRepository.getInvoicePreview(HtmlViewerRequest(
//         pattern: pattern,
//       ));
//       return res;
//     } catch (e) {
//     } finally {
//       hideLoadingOverlay();
//     }
//     return null;
//   }
// }
