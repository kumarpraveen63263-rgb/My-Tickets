enum SeatCategory { recliner, premium, executive, normal }

extension SeatCategoryX on SeatCategory {
  String get label {
    switch (this) {
      case SeatCategory.recliner:
        return 'RECLINER';
      case SeatCategory.premium:
        return 'PREMIUM';
      case SeatCategory.executive:
        return 'EXECUTIVE';
      case SeatCategory.normal:
        return 'NORMAL';
    }
  }
}

class SeatModel {
  final String id;
  final String row;
  final int number;
  final SeatCategory category;
  final double price;
  final bool isBooked;
  final bool isSelected;

  const SeatModel({
    required this.id,
    required this.row,
    required this.number,
    required this.category,
    required this.price,
    this.isBooked = false,
    this.isSelected = false,
  });

  String get label => '$row$number';

  SeatModel copyWith({bool? isBooked, bool? isSelected}) {
    return SeatModel(
      id: id,
      row: row,
      number: number,
      category: category,
      price: price,
      isBooked: isBooked ?? this.isBooked,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
