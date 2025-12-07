import 'package:equatable/equatable.dart';

class Tier extends Equatable {
  final int tierId; // PK - Primary key
  final String name; // Tier name (e.g., "Free", "Premium", "Pro")
  final double maxStorageMb; // Storage quota in MB
  final double maxAiMinutesPerMonth; // AI processing quota
  final double? pricePerMonth; // Optional pricing
  final bool isActive; // Whether tier is available
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Tier({
    required this.tierId,
    required this.name,
    required this.maxStorageMb,
    required this.maxAiMinutesPerMonth,
    this.pricePerMonth,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  Tier copyWith({
    int? tierId,
    String? name,
    double? maxStorageMb,
    double? maxAiMinutesPerMonth,
    double? pricePerMonth,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tier(
      tierId: tierId ?? this.tierId,
      name: name ?? this.name,
      maxStorageMb: maxStorageMb ?? this.maxStorageMb,
      maxAiMinutesPerMonth: maxAiMinutesPerMonth ?? this.maxAiMinutesPerMonth,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    tierId,
    name,
    maxStorageMb,
    maxAiMinutesPerMonth,
    pricePerMonth,
    isActive,
    createdAt,
    updatedAt,
  ];
}

