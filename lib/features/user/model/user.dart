import 'package:hive/hive.dart';

@HiveType(typeId: 10)
class UserModel {
  @HiveField(0)
  final String name;

  const UserModel({
    required this.name,
  });

  UserModel copyWith({
    String? name,
  }) {
    return UserModel(
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'UserModel(name: $name)';
}

/// =================
/// Manual TypeAdapter for UserModel
/// =================
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 10;

  @override
  UserModel read(BinaryReader reader) {
    // read fields in the same order you write them
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }

    return UserModel(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeByte(1);
    writer.writeByte(0);
    writer.write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
