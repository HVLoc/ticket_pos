import 'package:easy_invoice_qlhd/features/setup_realm/model/introduction_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../application/app.dart';
import '../../../const/all_const.dart';
import '../../../hive_local/setup.dart';
import '../../../utils/utils.dart';
import '../setup_realm.dart';

class SetupRealmControllerImp extends SetupRealmController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void save() {}

  @override
  void getSetup() {
    HIVE_APP.put(AppConst.keyIdPage, idPage.value);
    if (HIVE_APP.get(AppConst.keyIdPage) != null) {
      SetupModel getSetup =
          HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage)) ?? SetupModel();
      listSetupModel.value = getSetup;
    }
  }

  @override
  void back() {
    if (activeStep.value > 0) {
      activeStep.value--;
    }
  }

  @override
  void next() {
    if (activeStep.value < dotCount.value - 1) {
      activeStep.value++;
    }
  }

  @override
  String getKeyFromString(String text) {
    return text.substring(
      text.indexOf('{'),
      text.indexOf('}') + 1,
    );
  }

  @override
  void gotoHome() {
    appController.isLogin.value = true;
    HIVE_SETUP.put(idPage.value, listSetupModel.value);
    Get.offAllNamed(AppConst.routeHome);
  }

  @override
  SunmiPrintAlign alignSunmi(int? alignOptions) {
    if (alignOptions == 1) return SunmiPrintAlign.CENTER;
    if (alignOptions == 2) return SunmiPrintAlign.RIGHT;
    return SunmiPrintAlign.LEFT;
  }

  @override
  bool checkSettingContainsKey(String text) {
    return text.contains('{') && text.contains('}');
  }

  @override
  Future<void> configPrinter(RxList<Setting> listSetting) async {
    for (int index = 0; index < listSetting.length; index++) {
      String str = fillDataWithKey(listSetting[index].title!);
      if (listSetting[index].isQRCode) {
        await SunmiPrinter.setAlignment(
            alignSunmi(listSetting[index].alignText));
        await SunmiPrinter.printQRCode(
          str,
          size: listSetting[index].fontSize,
          errorLevel: SunmiQrcodeLevel.LEVEL_L,
        ); //
      } else {
        await SunmiPrinter.setCustomFontSize(listSetting[index].fontSize);
        await SunmiPrinter.printText(
          listSetting[index].isToUpper == true ? str.toUpperCase() : str,
          style: SunmiStyle(
              align: alignSunmi(listSetting[index].alignText),
              bold: listSetting[index].isBoldText),
        );
      }
    }
    await SunmiPrinter.setCustomFontSize(12);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printText(
      '',
      style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true),
    );
  }

  @override
  int countKey(String key) {
    String stringPairing =
        list.map((element) => element.title ?? "").toList().join('');
    List<String> listKeyDuplicate = [];
    while (checkSettingContainsKey(stringPairing)) {
      listKeyDuplicate.add(getKeyFromString(stringPairing));
      stringPairing =
          stringPairing.replaceFirst(getKeyFromString(stringPairing), "");
    }
    var map = Map();
    listKeyDuplicate.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    return map.keys.contains(key) ? map[key] : -1;
  }

  @override
  void deleteSetting(int index) {
    String text = list[index].title!;
    while (checkSettingContainsKey(text)) {
      String keyInSetting = getKeyFromString(text);
      int index = keySettingUserUse.indexOf(keyInSetting);
      if (index != -1 && countKey(keyInSetting) <= 1) {
        valueOfKeyUserUse.removeAt(index);
        keySettingUserUse.remove(keyInSetting);
      }

      text = text.replaceAll(keyInSetting, "");
    }
    list.removeAt(index);
  }

  @override
  void deletekeyOldOfSetting({List<String>? keyNew}) {
    if (keyNew != null) {
      keyOldOfSetting.forEach((element) {
        //Ki???m tra key m???i c?? ch???a key c?? v?? kay c?? c?? s??? d???ng ??? setting kh??c hay kh??ng
        if (!keyNew.contains(element) && countKey(element) <= 1) {
          int index = keySettingUserUse.indexOf(element);
          if (index != -1) {
            keySettingUserUse.removeAt(index);
            valueOfKeyUserUse.removeAt(index);
          }
        }
      });
      keyNew.forEach((element) {
        //Khi th??m key m???i v??o c???n ph???i ki???m tra key m???i ???? c?? h???p l??? hay kh??ng
        if (!keySettingUserUse.contains(element) &&
            AppStr.keySetting.containsKey(element)) {
          keySettingUserUse.add(element);
          valueOfKeyUserUse.add("");
        }
      });
    } else {
      keyOldOfSetting.forEach((element) {
        int index = keySettingUserUse.indexOf((element));
        if (index != -1 && countKey(element) <= 1) {
          keySettingUserUse.removeAt(index);
          valueOfKeyUserUse.removeAt(index);
        }
      });
    }
  }

  @override
  String fillDataWithKey(String str) {
    String temp = str;
    while (checkSettingContainsKey(temp)) {
      String keyInSetting = getKeyFromString(temp);
      if (keyInSetting.contains(AppStr.keyAmount)) {
        String moneyConverted = CurrencyUtils.formatCurrency(
          CurrencyUtils.formatNumberCurrency(
            valueOfKeyUserUse[keySettingUserUse.indexOf(keyInSetting)],
          ),
        );
        temp = temp.replaceAll(keyInSetting, moneyConverted);
      } else {
        temp = temp.replaceAll(
          keyInSetting,
          valueOfKeyUserUse[keySettingUserUse.indexOf(keyInSetting)],
        );
      }
      temp.replaceAll(keyInSetting, '');
    }
    return temp;
  }

  @override
  Setting fillSettingToBottomSheet(Setting setting) {
    textEditingController.text = setting.title ?? "";
    fontSizeController.text = setting.fontSize.toString();
    actionTypeIndex.value = setting.isQRCode ? 1 : 0;
    return Setting(
      title: textEditingController.text,
      fontSize: double.parse(fontSizeController.text).floor(),
      alignText: setting.alignText,
      convertNumber: setting.convertNumber,
      isBoldText: setting.isBoldText,
      isQRCode: setting.isQRCode,
      isToUpper: setting.isToUpper,
    );
  }

  @override
  void fixKeyWhenUserFixSetting(String text) {
    String str = text;
    List<String> keyNew = [];
    //tr?????ng h???p s???a kh??ng c?? key.
    if (!checkSettingContainsKey(str)) {
      deletekeyOldOfSetting();
    } else {
      while (checkSettingContainsKey(str)) {
        keyNew.add(getKeyFromString(str));
        str = str.replaceAll(getKeyFromString(str), "");
        //S???a t??? m???t chu???i ch???a key ( 1 ho???c nhi???u key ) sang chu???i key kh??c
      }
      keyNew.forEach((element) {
        //S???a t??? m???t chu???i kh??ng ch???a key sang chu???i c?? ch???a key ch??a t???n t???i
        if (keyOldOfSetting.isEmpty) {
          //Ki???m tra key m???i c?? tr??ng v???i key ???? c?? hay kh??ng. N???u kh??ng th?? th??m key m???i v?? value m???i.
          if (!keySettingUserUse.contains(element)) {
            keySettingUserUse.add(element);
            valueOfKeyUserUse.add("");
          }
        } else {
          //Ki???m tra tr?????ng h???p n???u key c?? kh??ng ch???a key m???i ???? ???????c s???a
          if (!keyOldOfSetting.contains(element)) {
            //Xo?? nh???ng key c??
            keyOldOfSetting.forEach((element) {
              //check tr?????ng h???p 1 key d??ng cho nhi???u setting
              if (countKey(element) <= 1) {
                deletekeyOldOfSetting(keyNew: keyNew);
              }
            });

            //Ki???m tra ti???p tr?????ng h???p n???u key ???????c s???a ch??a c?? trong keySetting m?? user s??? d???ng
            if (!keySettingUserUse.contains(element) &&
                AppStr.keySetting.containsKey(element)) {
              keySettingUserUse.add(element);
              valueOfKeyUserUse.add("");
            }
          }
          //S???a t??? m???t chu???i ch???a key ( 1 ho???c nhi???u key ) sang chu???i key kh??c
        }
      });
    }
  }

  @override
  void getDataToListValue() {
    valueOfKeyUserUse = listTextEditingController.map((e) => e.text).toList();
  }

  @override
  String getDay({DateTime? dateTime}) {
    return 'Ng??y ' + DateFormat.yMMMMd('vi').format(DateTime.now());
  }

  @override
  String getHour({DateTime? dateTime}) {
    String hourAndMinutes =
        convertDateToString(dateTime ?? DateTime.now(), PATTERN_HM);
    return '${hourAndMinutes.split(':').first} gi??? ${hourAndMinutes.split(':').last} ph??t';
  }

  @override
  void getKeyBeforeFixSetting(String text) {
    keyOldOfSetting.clear();
    String str = text;
    while (checkSettingContainsKey(str)) {
      keyOldOfSetting.add(getKeyFromString(str));
      str = str.replaceAll(getKeyFromString(str), "");
    }
  }

  @override
  void getKeySettingUserUse() {
    // n???i c??c chu???i l???i v???i nhau.
    String stringPairing =
        list.map((element) => element.title ?? "").toList().join('');

    //L???y ra nh???ng key m?? kh??ch h??ng s??? d???ng
    AppStr.keySetting.keys.forEach((element) {
      keySettingUserUse.addIf(
          !keySettingUserUse.contains(element) &&
              stringPairing.contains(element),
          element);
    });

    //ch??? th??m c??c gi?? tr??? c???a key m???i m?? trong key c???a user ch??a c??
    if (valueOfKeyUserUse.length < keySettingUserUse.length) {
      valueOfKeyUserUse.addAll(List.generate(
          keySettingUserUse.length - valueOfKeyUserUse.length, (index) => ""));
    }
    //generate nh???ng textEditingController ?????i di???n cho gi?? tr??? c???a key
    listTextEditingController = List.generate(
      keySettingUserUse.length,
      (i) => TextEditingController(text: valueOfKeyUserUse[i]),
    );
  }

  @override
  void getListSettingWithArg() {
    {
      list.addAll([
        Setting(
          title: AppStr.companyName,
          isBoldText: true,
          isToUpper: true,
        ),
        Setting(title: AppStr.companyAddress, fontSize: 18),
        Setting(
            title: '${AppStr.taxCode}: ${AppStr.companyTaxCode} ',
            isBoldText: true,
            fontSize: 18),
      ]);
      switch (idPage.value) {
        case 0:
          settingCoach();
          break;
        case 1:
          settingBus();
          break;
        case 2:
          settingPark();
          break;
        case 3:
          settingGames();
          break;
        default:
          settingCustom();
      }
      list.addAll([
        Setting(
          title: AppStr.companyRelease,
          isBoldText: true,
          alignText: 1,
          fontSize: 18,
        ),
        Setting(
          title: AppStr.supportText,
          alignText: 1,
          isBoldText: true,
          fontSize: 18,
        ),
      ]);
    }
  }

  @override
  void settingCoach() {
    list.addAll([
      Setting(
          title: AppStr.ticketCoach,
          alignText: 1,
          fontSize: 36,
          isToUpper: true),
      Setting(
        title: '${AppStr.routeInfo}: ${AppStr.keyName}',
        alignText: 1,
        fontSize: 36,
        isToUpper: true,
      ),
      Setting(
        title: '${AppStr.amount}: ${AppStr.keyAmount}',
        alignText: 1,
        isBoldText: true,
      ),
      Setting(
          title: '(Gi?? v?? ???? bao g???m VAT v?? b???o hi???m h??nh kh??ch)',
          alignText: 1,
          fontSize: 16),
    ]);
    if (listSetupModel.value.startTime) {
      list.add(
        Setting(
            title: '${AppStr.timeStart}: ${getHour()} ',
            alignText: 1,
            fontSize: 18),
      );
    }
    if (listSetupModel.value.startDate) {
      list.add(
        Setting(
            title: '${AppStr.dateStart}: ${getDay()}',
            alignText: 2,
            fontSize: 18),
      );
    }
    if (listSetupModel.value.licensePlates) {
      list.add(Setting(
          title: '${AppStr.licensePlates}: ${AppStr.keyCarNo}',
          alignText: 1,
          fontSize: 18));
    }
    if (listSetupModel.value.numberChair) {
      list.add(Setting(
          title: '${AppStr.amountChair}: ${AppStr.keyNumberAmountChair}',
          alignText: 1,
          fontSize: 18));
    }
    if (listSetupModel.value.amountChair) {
      list.add(Setting(
          title: '${AppStr.seat}: ${AppStr.keyNumberSeat} ',
          alignText: 1,
          fontSize: 18));
    }
    if (listSetupModel.value.configAddQRCode) {
      list.add(Setting(
          title: AppStr.fixQRCode, isQRCode: true, alignText: 2, fontSize: 3));
    }
    list.addAll([
      Setting(title: getDay()),
      Setting(
          title: '${AppStr.ticketDateDay} ${getDay()}',
          alignText: 2,
          fontSize: 18),
    ]);
  }

  @override
  void settingBus() {
    if (listSetupModel.value.busStation) {
      list.add(Setting(
        title:
            '${AppStr.route}: ${AppStr.keyDeparture} - ${AppStr.keyDestination}',
        alignText: 2,
      ));
    }

    if (listSetupModel.value.monthlyTicket) {}
    list.addAll([
      // Setting(title: 'Tuy???n: ', alignText: 2),
      Setting(
          title: AppStr.ticketBus, alignText: 1, fontSize: 36, isToUpper: true),
      Setting(
          title: '${AppStr.amount}: ${AppStr.keyAmount}',
          alignText: 1,
          isBoldText: true),
      Setting(title: 'V?? ???? bao g???m thu??? GTGT', alignText: 1, fontSize: 16),
      Setting(
          title: '${AppStr.carNo}: ${AppStr.keyCarNo}',
          alignText: 1,
          fontSize: 18),
      Setting(
          title: '${AppStr.timeText}: ${getHour()}',
          alignText: 1,
          fontSize: 18),
      Setting(title: getDay(), alignText: 2, fontSize: 18),
    ]);
    if (listSetupModel.value.configAddQRCode) {
      Setting(
          title: AppStr.fixQRCode, isQRCode: true, alignText: 2, fontSize: 3);
    }
  }

  @override
  void settingPark() {
    list.addAll([
      Setting(
          title: AppStr.ticketParking,
          alignText: 1,
          fontSize: 36,
          isToUpper: true),
      Setting(
        title: '${AppStr.amount}: ${AppStr.keyAmount}',
        alignText: 1,
        isBoldText: true,
      ),
      Setting(title: '(???? bao g???m thu??? GTGT)', alignText: 1, fontSize: 16),
    ]);
    if (listSetupModel.value.licensePlatesParking) {
      list.add(Setting(
          title: '${AppStr.licensePlates}: ${AppStr.keyCarNo}',
          alignText: 1,
          fontSize: 18));
    }
    list.addAll([
      Setting(
          title: '${AppStr.ticketDateDay} ${getHour()}',
          alignText: 2,
          fontSize: 18),
    ]);
    if (listSetupModel.value.configAddQRCode) {
      Setting(
          title: AppStr.fixQRCode, isQRCode: true, alignText: 2, fontSize: 3);
    }
  }

  @override
  void settingGames() {
    if (listSetupModel.value.comboTicket) {}
    if (listSetupModel.value.basicTicket) {}
    list.addAll([
      Setting(
          title: AppStr.ticketGames,
          alignText: 1,
          fontSize: 36,
          isToUpper: true),
      Setting(
        title: '${AppStr.amount}: ${AppStr.keyAmount}',
        alignText: 1,
        isBoldText: true,
      ),
      Setting(title: '(???? bao g???m thu??? VAT 8%)', alignText: 1, fontSize: 16),
      Setting(
          title: '${AppStr.ticketDateDay} ${getDay()}',
          alignText: 1,
          fontSize: 18),
    ]);
    if (listSetupModel.value.configAddQRCode) {
      list.add(
        Setting(
            title: AppStr.fixQRCode, isQRCode: true, alignText: 1, fontSize: 3),
      );
    }
  }

  @override
  void settingCustom() {
    if (listSetupModel.value.startTime) {
      list.add(
        Setting(
            title: '${AppStr.timeStart} ${getHour()} ',
            alignText: 1,
            fontSize: 18),
      );
    }
    if (listSetupModel.value.startDate) {
      list.add(
        Setting(
            title: '${AppStr.dateStart} ${getDay()}',
            alignText: 2,
            fontSize: 18),
      );
    }
    if (listSetupModel.value.licensePlates) {
      list.add(Setting(
          title: '${AppStr.licensePlates}: ${AppStr.keyCarNo}',
          alignText: 1,
          fontSize: 18));
    }
    if (listSetupModel.value.busStation) {
      list.add(
          Setting(title: '${AppStr.route}: ${AppStr.keyName}', alignText: 2));
    }
    if (listSetupModel.value.configAddQRCode) {
      list.add(Setting(
        title: AppStr.fixQRCode,
        isQRCode: true,
        alignText: 1,
        fontSize: 3,
      ));
    }
  }

  @override
  void getSettingPrint() {
    if (HIVE_SETTING.isEmpty) {
      getListSettingWithArg();
    } else {
      HIVE_SETTING.values.toList().forEach((element) {
        list.add(element);
      });
    }
    getKeySettingUserUse();
  }

  @override
  Setting resultValue() {
    return Setting(
      title: textEditingController.text,
      alignText: objectChange.value.alignText,
      isToUpper: objectChange.value.isToUpper,
      fontSize: int.parse(fontSizeController.text),
      isBoldText: objectChange.value.isBoldText,
      convertNumber: objectChange.value.convertNumber,
      isQRCode: actionTypeIndex.value == 1,
    );
  }
}
