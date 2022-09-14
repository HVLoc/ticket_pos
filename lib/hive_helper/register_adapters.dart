import 'package:hive/hive.dart';
import '../features/setup_realm/model/introduction_setting_model.dart';

void registerAdapters() {
  Hive.registerAdapter(SettingAdapter());
}
