import 'package:hive/hive.dart';
part 'user_information_model.g.dart';
@HiveType(typeId: 0)
class UserInformationModel extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String? image;
  UserInformationModel({
    required this.email,
    required this.name,
  });
}
