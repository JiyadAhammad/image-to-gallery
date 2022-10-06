import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'dbmodel.g.dart';

@HiveType(typeId: 0)
class Gallery extends HiveObject {

  Gallery({this.imagePath});
  @HiveField(0)
  final String? imagePath;
}
