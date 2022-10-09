class AppConst {
  // --------- EasyInvoiceMobile ----------
  static const String urlBase =
      'http://2802415041.softdreams.vn/'; // Server Test
  static const String urlBasePortalLink =
      'http://2802415041hd.softdreams.vn'; // Server Test
  // static const String urlBase =
  //     'http://test7802.softdreams.vn'; // Server Test 78
  // static const String urlBase =
  //     'http://mobimgr.easyinvoice.com.vn/'; // Server Invoice

  static const String urlCheckTaxCode =
      'http://sadmin208.softdreams.vn/api/manager/getcompany';
  // static const String urlCheckTaxCode =
  //     'http://sadmin78.softdreams.vn/api/manager/getcompany';

  // static const String urlCheckTaxCode =
  //     'https://sadmin.easyinvoice.vn/api/manager/getcompany';

  static const String urlLogin = '/api/account/verify';

  static const String urlProductSearch = '/api/product/search';
  static const String urlCustomerSearch = '/api/customer/search';
  static const String urlInvoiceDetail = '/api/invoice/getdetail';
  static const String urlInvoiceStrip = '/api/invoice-strip/search';
  static const String urlInvoiceSearch = '/api/invoice/search';
  static const String urlCustomerDetail = '/api/customer/getDetail';
  static const String urlUpdateCustomer = '/api/publish/updateCustomer';
  static const String urlInvoiceViewInvoice = '/api/publish/viewInvoice';
  static const String urlRemoveUnsignedInvoice =
      '/api/business/removeUnsignedInvoice';
  static const String urlIssueInvoices = '/api/publish/issueInvoices';
  static const String urlSendIssuanceNotice = '/api/business/sendMailNotice';
  static const String urlGetInvoicePdf = '/api/publish/getInvoicePdf';
  static const String urlCheckInvoiceState = '/api/publish/checkInvoiceState';
  static const String urlHistoryInvoice = '/api/invoice/invoiceHistory';

  //password
  static const String urlChangePassword = '/api/account/changePassword';

  //invoice creation
  static const String urlPublishImportInvoice = '/api/publish/importInvoice';
  static const String urlSendErrorNotice = '/api/business/sendErrorNotice';
  static const String urlExtraInfo = '/api/company/extraInfo';
  static const String urlSearchAllProvince =
      'https://cic.gov.vn/api/p/areas/searchall';

  static const String urlPublishImportAndIssueInvoice =
      '/api/publish/importAndIssueInvoice';
  static const String urlGetListBank = 'https://api.vietqr.io/v2/banks';

  //handle, replace, cancle
  static const String urlHandleInvoice = '/api/business/adjustInvoice';
  static const String urlReplaceInvoice = '/api/business/replaceInvoice';
  static const String urlCancelInvoice = '/api/business/cancelInvoice';
  static const String urlDeleteCustomer = '/api/customer/delete';
  static const String checkTaxCode =
      'http://utilsrv.easyinvoice.com.vn/api/company/info';
  static const String urlUnsignedAdjustment =
      '/api/business/importUnsignedAdjustment';
  static const String urlUnsignedReplacement =
      '/api/business/importUnsignedReplacement';

  static const String urlUpdateProduct = '/api/publish/updateProduct';
  static const String urlDeleteProduct = '/api/product/delete';

  //notification
  static const String urlNotification = '/api/business/expiredWarning';

//dashboard
  static const String urlDashboardModel = '/api/invoice/invoiceStatistics';
  static const String urlPieChartModel = '/api/invoice-strip/countInvoiceType';
  static const String urlBarChartModel =
      '/api/invoice-strip/countInvoiceEachMonth';
  static const String urlPublishViewInvoiceTemplate =
      '/api/publish/viewInvoiceTemplate';

  // api search
  static const String urlBaseSearch = 'http://mobileapi.easyinvoice.com.vn/api';
  static const String urlSearchInvoiceByQr =
      '$urlBaseSearch/invoice/getpdfbyqrcode';
  static const String urlSearchInvoicebyKey = '$urlBaseSearch/invoice/getpdf';

  //app
  static const String appName = "Hoá đơn điện tử";
  static const String appStoreId = "1556784655";
  static const String aboutUsUrl = "https://easyinvoice.vn/";
  static const String facebook =
      "https://www.facebook.com/groups/phanmemhoadondientu";
  static const String youtube =
      "https://www.youtube.com/channel/UCfvaQ1YDoHIknMPdOR-jl_A";
  static const String zalo = "https://zalo.me/3525050476090793203";

  //crm url
  static const String accessToCRM = "https://testcrm.softdreams.vn/api/auth";
  static const String sendFeedback =
      "https://testcrm.softdreams.vn/api/createCustomerFeedback";

  //base
  static const int pageSize = 10;
  static const int defaultPage = 1;
  static const int requestTimeOut = 15000 * 2; //ms

  static const int millisecondsDefault = 1000;
  static const int limitPhone = 10;
  static const int responseSuccess = 2;
  static const int codeSuccess = 200;
  static const int currencyUtilsMaxLength = 12;

  //login
  static const int codeBlocked = 400;
  static const int codeAccountNotExist = 401;
  static const int codePasswordNotCorrect = 402;

  // hive
  static const String keyUserName = 'key_user_name';
  static const String keyShowIntro = 'key_show_intro';
  static const String keySesionLogin = 'key_sesion_login';
  static const String keyPassword = 'key_password';
  static const String keyComName = 'key_com_name';
  static const String keyTokenDevice = "key_token_device";
  static const String keyTheme = 'key_theme';
  static const String keyEmail = 'key_email';
  static const String keyPatternFilter = 'key_pattern_filter';
  static const String keySerialFilter = 'key_serial_filter';
  static const String keyUrl = 'key_url';
  static const String keyUrlPortalLink = 'key_url_portal_link';
  static const String keyPaymentMethod = 'key_payment_method';
  static const String keyTaxCodeCompany = 'key_taxcode_company';
  static const String keyLanguageIsVN = 'key_language_isVN';
  static const String keyIsDarkTheme = "keyIsDarkTheme";
  static const String keyOldTaxCodeCompany = 'key_old_taxcode_company';
  static const String keyLoginFirstTimeSesion = 'key_login_firsttime_sesion';
  static const String keyTimeOfDay = 'key_time_of_day';
  static const String keyInvoiceModel = 'key_invoice_model';
  static const String keyCurrentAccount = 'key_current_account';
  static const String keyCurrentShift = 'key_current_shift';
  static const String keyCurrentNameAccount = 'key_name_account';
  static const String keyAddress = 'key_address_company';
  static const String keyLicensePlates = 'key_licensePlates';
  static const String keyIdPage = 'key_id_page';
  static const String keyCurrentAccountDriver = "key_current_account_driver";
  static const String keyRouteBusNumber = "key_current_route_bus";
  static const String keyCarNo = "key_current_car_No";


  //show case hive
  static const String keyShowCaseInvoicesPattern =
      'key_show_case_invoices_pattern';
  static const String keyShowCaseInvoicesFilter =
      'key_show_case_invoices_filter';
  static const String keyShowCaseInvoicesAction =
      'key_show_case_invoices_action';
  static const String keyShowCaseCreationInvoiceDateTimeSerial =
      'key_show_case_creation_invoice_datetime_pattern';
  static const String keyShowCaseCreationInvoiceProduct =
      'key_show_case_creation_invoice_product';
  static const String keyShowCaseCreationInvoiceProductSwipe =
      'key_show_case_creation_invoice_product_swipe';
  static const String keyShowCaseCreationInvoiceTitle =
      'key_show_case_creation_invoice_title';

// routes enum: các đường dẫn chuyển màn trong app
  static const String routeHome = '/home';
  static const String routeLogin = '/login';

  static const String routePdf = '/pdf';
  static const String routeProfile = '/profile';
  static const String routeProduct = '/product';
  static const String routeInvoice = '/invoice';
  static const String routeCustomer = '/customer';
  static const String routeInvoiceCreation = '/invoiceCreation';
  static const String routeProductDetail = '/productDetail';
  static const String routeCustomerDetail = '/customerDetail';
  static const String routeInvoiceDetail = '/invoiceDetail';
  static const String routeInvoiceHtml = '/invoiceHtml';
  static const String routeErrorNotice = '/errorNotice';
  static const String routeHistoryInvoice = '/historyPage';
  static const String routeTicketPage = '/ticketPage';
  static const String routeSetupPage = '/setupPage';
  static const String routeInvoiceUpdateTotalAmount =
      '/invoiceUpdateTotalAmount';
  static const String routeQrCode = '/qrCode';
  static const String routeSearchInvoice = '/searchInvoice';
  static const String routeChangeAccount = '/changeAccount';

  //error
  static const int error500 = 500;
  static const int error404 = 404;
  static const int error401 = 401;
  static const int error400 = 400;
  static const int error502 = 502;
  static const int error503 = 503;

  static const String invoiceSeparator = " | ";
  static const String vnd = "VNĐ";
  static const String millionSort = 'tr';
  static const String billion = 'tỷ';
  static const String moneySpaceStr = ",";
  static const int moneySpacePos = 3;

  //hive
  static const String hiveFindHistory = "hiveFind";
  static const String hiveFindNoHistory = "hiveFindNo";

  //product detail
  static const String detailProduct = "detail_product";
  static const String createProduct = "create_product";
  static const String editProduct = "edit_product";
  static const String duplicateProduct = "duplicate_product";

  //transalte parameter
  static const String invoiceCancelInvoiceWarn = 'invoiceCancelInvoiceWarn';
  static const String deleteProductNumber = 'deleteProductNumber';
  static const String invoiceIssueSuccessNumber = "invoiceIssueSuccessNumber";
  static const String selectedStr = "selectedStr";
  static const String newVersionContentStr = "newVersionContentStr";
}
