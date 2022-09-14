import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:easy_invoice_qlhd/utils/widgets/keyboard_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

abstract class BaseProductAddController extends BaseGetxController {
  Rx<ProductItem> product = Rx<ProductItem>(ProductItem(quantity: 0.0));

  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Rx<TextEditingController> unitController = TextEditingController().obs;
  Rx<TextEditingController> prodQuantityController =
      TextEditingController(text: '1').obs;
  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<TextEditingController> totalController = TextEditingController().obs;
  Rx<TextEditingController> vatAmountController = TextEditingController().obs;
  Rx<TextEditingController> discountController = TextEditingController().obs;
  Rx<TextEditingController> discountAmountController =
      TextEditingController().obs;

  RxBool isVisibleBtn = true.obs;

  FocusNode totalFocus = FocusNode();
  FocusNode vatAmountFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode discountAmountFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  late ValueNotifier<TextEditingController> priceNotifier;
  late ValueNotifier<TextEditingController> totalNotifier;
  late ValueNotifier<TextEditingController> vatAmountNotifier;
  late ValueNotifier<TextEditingController> discountNotifier;
  late ValueNotifier<TextEditingController> discountAmountNotifier;
  late ValueNotifier<TextEditingController> quantityNotifier;

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();

  late bool isTaxBill;

  RxInt properties = 1.obs;

  RxBool isSale = false.obs;
  RxBool isEnableTextFieldTotal = true.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    setUpNotifer();
    super.onInit();
  }

  void onAccept();
  void setVatAmount();
  void setDiscountAmount();
  void setTotal();

  void changePrice(String value) {
    setDiscountAmount();
    setVatAmount();
    setTotal();
    isEnableTextFieldTotal.value =
        priceController.value.text.isEmpty || priceController.value.text == '0';
  }

  void setUpNotifer() {
    priceNotifier = ValueNotifier<TextEditingController>(priceController.value);
    totalNotifier = ValueNotifier<TextEditingController>(totalController.value);
    vatAmountNotifier =
        ValueNotifier<TextEditingController>(vatAmountController.value);
    discountAmountNotifier =
        ValueNotifier<TextEditingController>(discountAmountController.value);
    discountNotifier =
        ValueNotifier<TextEditingController>(discountController.value);
    quantityNotifier =
        ValueNotifier<TextEditingController>(prodQuantityController.value);
  }

  KeyboardActionsConfig buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: priceFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            typeFormatInput: 1,
            focusNode: priceFocus,
            notifier: priceNotifier,
            onChange: changePrice,
            buttonBar: buildBtnBottom(),
          ),
        ),
        KeyboardActionsItem(
          focusNode: totalFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            typeFormatInput: 0,
            focusNode: totalFocus,
            notifier: totalNotifier,
            onChange: changeTotal,
            buttonBar: buildBtnBottom(),
          ),
        ),
        KeyboardActionsItem(
          focusNode: vatAmountFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            focusNode: vatAmountFocus,
            notifier: vatAmountNotifier,
            buttonBar: buildBtnBottom(),
          ),
        ),
        KeyboardActionsItem(
          focusNode: quantityFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            focusNode: quantityFocus,
            notifier: quantityNotifier,
            buttonBar: buildBtnBottom(),
            onChange: changePrice,
          ),
        ),
        KeyboardActionsItem(
          focusNode: discountAmountFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            focusNode: discountAmountFocus,
            notifier: discountAmountNotifier,
            buttonBar: buildBtnBottom(),
            onChange: changeDiscountAmount,
          ),
        ),
        KeyboardActionsItem(
          focusNode: discountFocus,
          displayActionBar: false,
          footerBuilder: (_) => NumericKeyboard(
            focusNode: discountFocus,
            notifier: discountNotifier,
            buttonBar: buildBtnBottom(),
            onChange: changeDiscount,
            lastDecimal: 6,
            maxlengthNum: 2,
          ),
        ),
      ],
    );
  }

  bool isNote() => properties.value == 4;
  bool isDiscount() => properties.value == 3;
  bool isProductOrSale() => !(isNote() || isDiscount());

  Widget buildBtnBottom();

  void changeVAT(String value) {
    KeyBoard.hide();

    product.update((val) {
      val!.vatRate = AppStr.listVAT.entries
          .firstWhere((element) => element.value == value)
          .key;
    });
    setVatAmount();
  }

  void changeProperties(int value) {
    properties.value = value;
    isSale.value = properties.value == 2;
  }

  void changeTotal(String value) {
    setVatAmount();
  }

  void changeDiscount(String value) {
    setDiscountAmount();
    setVatAmount();
    setTotal();
  }

  void changeDiscountAmount(String value) {
    setVatAmount();
    setTotal();
  }
}
