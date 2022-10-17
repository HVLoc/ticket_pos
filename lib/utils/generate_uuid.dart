import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
String generateUiid(String nameDB) {
  return uuid.v5(Uuid.NAMESPACE_DNS, nameDB + uuid.v1());
}