import 'package:hive/hive.dart';

part 'barcode_item_model.g.dart';

@HiveType(typeId: 0)
class BarcodeItemModel extends HiveObject {

  @HiveField(0)
  final String value;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? imagePath;

  BarcodeItemModel({
    required this.value,
    required this.title,
    required this.description,
    this.imagePath,
});

  BarcodeItemModel copyWith({
    String? value,
    String? title,
    String? description,
    String? imagePath,
}) {
    return BarcodeItemModel(
        value: value ?? this.value,
        title: title ?? this.title,
        description: description ?? this.description,
        imagePath: imagePath ?? this.imagePath,
    );
  }
}