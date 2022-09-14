import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/hive_local/shift.dart';
import 'package:get/get.dart';

import '../../const/all_const.dart';

class ShiftController extends BaseGetxController {
  RxList<ShiftModel> shiftList = <ShiftModel>[].obs;
  final listShift = HIVE_SHIFT;

  void addShift(ShiftModel shiftModel) {
    shiftModel.id = listShift.isNotEmpty ? listShift.values.last.id + 1 : 0;
    listShift.add(shiftModel);
    getShift();
  }

  void deleteShift(int id) {
    listShift.delete(id);
    getShift();

    showSnackBar(AppStr.deleteSuccess);
  }

  void updateShift(ShiftModel shiftModel, int id) {
    listShift.put(id, shiftModel);
    getShift();
  }

  @override
  void onInit() {
    getShift();
    super.onInit();
  }

  void getShift() {
    final data = listShift.keys.map((key) {
      final value = listShift.get(key);
      return ShiftModel(
          id: key,
          nameShift: value!.nameShift,
          nameShiftLeader: value.nameShiftLeader,
          startDate: value.startDate,
          endDate: value.endDate,
          note: '');
    }).toList();

    shiftList.value = data.reversed.toList();
    HIVE_SHIFT = (listShift);
  }
}
