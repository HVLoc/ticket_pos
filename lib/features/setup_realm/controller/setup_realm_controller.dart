import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/enums.dart';
import '../../../application/app.dart';
import '../../../base/base.dart';
import '../model/introduction_setting_model.dart';

abstract class SetupRealmController extends BaseGetxController {
  var activeStep = 0.obs;
  var dotCount = 4.obs;
  var idPage = 0.obs;
  Rx<SetupModel> listSetupModel = SetupModel().obs;
  AppController appController = Get.find<AppController>();
  @override
  void onInit() {
    super.onInit();
  }

  void save();

  void getSetup();
  Rx<Setting> objectChange = Setting().obs;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController fontSizeController = TextEditingController();
  FocusNode nodeTextSize = FocusNode();
  RxInt actionTypeIndex = 0.obs;
  FocusNode nodeSizeQR = FocusNode();
  RxList<Setting> list = <Setting>[].obs;
  List<String> keySettingUserUse = [];
  List<String> valueOfKeyUserUse = [];
  late List<TextEditingController> listTextEditingController;
  List<String> keyOldOfSetting = [];

  void back();

  void next();
  String getKeyFromString(String text);

  void gotoHome();

  SunmiPrintAlign alignSunmi(int? alignOptions);

  bool checkSettingContainsKey(String text);

  void getDataToListValue();

  void getKeySettingUserUse();

  void deleteSetting(int index);

  //FillData vào setting với các giá trị key tương ứng
  String fillDataWithKey(String str);

  //Lấy keySetting cũ
  void getKeyBeforeFixSetting(String text);

  int countKey(String key);

  //Khi truyền vào keyNew tức là ta đang xét trường hợp sửa lại setting có chứa key
  //Không truyền tức là trường hợp xoá key của setting đó
  void deletekeyOldOfSetting({List<String>? keyNew});

  //lấy key mới sau khi user xác nhận thông tin đã được thay đổi
  void fixKeyWhenUserFixSetting(String text);

  Future<void> configPrinter(RxList<Setting> listSetting);

  String getDay({DateTime? dateTime});

  String getHour({DateTime? dateTime});

  //Hàm này trả về giá trị của setting trong bottomsheet
  //Khi gán giá trị trực tiếp vào -> trùng hashcode -> sửa 1 thành sửa 2
  Setting fillSettingToBottomSheet(Setting setting);

  Setting resultValue();

  void getSettingPrint();

  void getListSettingWithArg();

  void settingCoach();

  void settingBus();

  void settingPark();

  void settingGames();

  void settingCustom();
}
