part of '../ticket/controller/ticket_ctr_imp.dart';

extension PrintConfig on TicketControllerImp {
  Future<void> _configPrinter(ProductItem item, String ikey) async {
    // await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setCustomFontSize(22);
    await SunmiPrinter.printText(HIVE_APP.get(AppConst.keyComName),
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.setCustomFontSize(22);
    await SunmiPrinter.printText(
      HIVE_APP.get(AppConst.keyAddress) ??
          "4141 Seltice Way,Lava Hot Springs\n1462 Eva Pearl Street,Innis ",
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        bold: true,
      ),
    );
    await SunmiPrinter.setCustomFontSize(22);
    await SunmiPrinter.printText(
      'Mã số thuế: ${HIVE_APP.get(AppConst.keyTaxCodeCompany)}',
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        bold: true,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      getTypeTicket(getIdPage()),
      style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
          bold: true,
          fontSize: SunmiFontSize.XL),
    );
    await SunmiPrinter.setCustomFontSize(28);
    await SunmiPrinter.printText(
      'Giá vé: ${CurrencyUtils.formatCurrencyForeign(item.amount, lastDecimal: 1)} đồng/Lượt',
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        bold: true,
      ),
    );
    switch (getIdPage()) {
      case 0:
        await configCoach(ikey);
        break;
      case 1:
        await configTicketParking();
        break;
      default:
    }
    // await SunmiPrinter.printText(HIVE_APP.get(AppConst.keyComName),
    //     style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('Align right');
    // await SunmiPrinter.lineWrap(1);
    if (setupModel.configAddQRCode) {
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printQRCode(
        getOrigInvUrl(
          AppConst.urlBasePortalLink,
          ikey,
          HIVE_APP.get(AppConst.keyPatternFilter) ?? '5C22TYY',
        ),
        size: 3,
      );
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    }
    await SunmiPrinter.setCustomFontSize(18);
    await SunmiPrinter.printText(AppStr.ticketInfoProvider,
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.lineWrap(2); // Jump 2 lines
    await SunmiPrinter.printText('',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.submitTransactionPrint(); // SUBMIT and cut paper
  }

  String getTypeTicket(int id) {
    switch (id) {
      case 1:
        return 'VÉ XE BUS';
      case 2:
        return 'VÉ GỬI XE';
      case 3:
        return 'VÉ TRÒ CHƠI';
      case 4:
        return 'VÉ CUSTOM';
      default:
        return 'VÉ XE KHÁCH';
    }
  }

  int getIdPage() => HIVE_APP.get(AppConst.keyIdPage);

  Future<void> configCoach(String ikey) async {
    await SunmiPrinter.setCustomFontSize(16);
    await SunmiPrinter.printText(
      AppStr.ticketVAT,
      style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER),
    );
    if (setupModel.startTime) {
      await SunmiPrinter.setCustomFontSize(18);
      await SunmiPrinter.printText(
        AppStr.ticketStartingDateHP +
            '.${_addLeadingZeroIfNeeded(timeOfDay.value.hour)}.' +
            AppStr.ticketStartingDateHour +
            '.${_addLeadingZeroIfNeeded(timeOfDay.value.minute)}.' +
            AppStr.ticketStartingDateMinute,
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true),
      );
    }

    if (setupModel.startDate) {
      await SunmiPrinter.setCustomFontSize(18);
      await SunmiPrinter.printText(
        getTimeNowLocateVI(),
        // AppStr.ticketDate + convertDateToString(dateTime.value, PATTERN_1),
        // AppStr.ticketDateDay +
        //     convertDateToString(dateTime.value, PATTERN_DD) +
        //     AppStr.ticketDateMonth +
        //     convertDateToString(dateTime.value, PATTERN_MM) +
        //     AppStr.ticketDateYear +
        //     convertDateToString(dateTime.value, PATTERN_YY),
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER),
      );
    }

    if (setupModel.licensePlates) {
      if (checkLicensePlatesIsPrint())
        await SunmiPrinter.lineWrap(1);
      else {
        await SunmiPrinter.setCustomFontSize(6);
        await SunmiPrinter.printText('');
      }
      await SunmiPrinter.setCustomFontSize(30);
      await SunmiPrinter.printText(
        "Biển số xe: ${checkLicensePlatesIsPrint() ? "............\n" : HIVE_APP.get(AppConst.keyLicensePlates)}",
        style: SunmiStyle(
            bold: true,
            align: checkLicensePlatesIsPrint()
                ? SunmiPrintAlign.LEFT
                : SunmiPrintAlign.CENTER),
      );
      if (checkLicensePlatesIsPrint())
        await SunmiPrinter.lineWrap(1);
      else {
        await SunmiPrinter.setCustomFontSize(6);
        await SunmiPrinter.printText('');
      }
    }
    // if (setupModel.amountChair) {
    //   await SunmiPrinter.setCustomFontSize(18);
    //   await SunmiPrinter.printText('Số lượng ghế: ');
    //   await SunmiPrinter.lineWrap(1);
    // }
  }

  Future<void> configTicketParking() async {
    await SunmiPrinter.setCustomFontSize(18);
    await SunmiPrinter.printText('(Đã bao gồm thuế GTGT)',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    if (setupModel.licensePlatesParking) {
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setCustomFontSize(30);
      await SunmiPrinter.printText(
        'Biển số xe: ${licensePlatesParkingController.text.isEmpty ? '..........' : '${licensePlatesParkingController.text}'}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true),
      );
      await SunmiPrinter.lineWrap(1);
    }

    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.printText(getTimeNowLocateVI(),
        style: SunmiStyle(align: SunmiPrintAlign.RIGHT, bold: true));
    await SunmiPrinter.lineWrap(1);
  }

  String getTimeNowLocateVI() {
    return AppStr.ticketDateDay +
        DateFormat.yMMMMd('vi').format(DateTime.now());
  }

  bool checkLicensePlatesIsPrint() {
    return HIVE_APP.get(AppConst.keyLicensePlates) == null ||
        HIVE_APP.get(AppConst.keyLicensePlates) == "";
  }
}
