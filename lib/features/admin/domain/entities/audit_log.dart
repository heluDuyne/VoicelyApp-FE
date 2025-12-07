import 'package:equatable/equatable.dart';

class AuditLog extends Equatable {
  final int logId; // PK, bigint - Primary key
  final String userId; // FK - User who performed action
  final String action; // Action type (e.g., "UPLOAD", "DELETE", "LOGIN")
  final String? resourceType; // Resource type (e.g., "RECORDING", "TRANSCRIPT")
  final String? resourceId; // ID of affected resource
  final Map<String, dynamic>? details; // Additional context as JSON
  final String? ipAddress; // User's IP address
  final String? userAgent; // Browser/client info
  final DateTime createdAt; // When action occurred

  const AuditLog({
    required this.logId,
    required this.userId,
    required this.action,
    this.resourceType,
    this.resourceId,
    this.details,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
  });

  AuditLog copyWith({
    int? logId,
    String? userId,
    String? action,
    String? resourceType,
    String? resourceId,
    Map<String, dynamic>? details,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
  }) {
    return AuditLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    logId,
    userId,
    action,
    resourceType,
    resourceId,
    details,
    ipAddress,
    userAgent,
    createdAt,
  ];
}

