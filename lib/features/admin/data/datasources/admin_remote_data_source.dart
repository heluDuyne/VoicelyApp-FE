import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../recording/data/models/recording_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<UserModel>> getUsers({
    String? email,
    int? tierId,
    bool? isActive,
  });
  Future<UserModel> updateUser({
    required String userId,
    int? tierId,
    bool? isActive,
    String? role,
  });
  Future<List<RecordingModel>> getUserRecordings(String userId);
  Future<RecordingModel> getAdminRecordingDetail(String recordingId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers({
    String? email,
    int? tierId,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (email != null) queryParams['email'] = email;
      if (tierId != null) queryParams['tier_id'] = tierId;
      if (isActive != null) queryParams['is_active'] = isActive;

      final response = await dio.get(AppConstants.adminUsersEndpoint, queryParameters: queryParams);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get users');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    int? tierId,
    bool? isActive,
    String? role,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (tierId != null) data['tier_id'] = tierId;
      if (isActive != null) data['is_active'] = isActive;
      if (role != null) data['role'] = role;

      final response = await dio.patch('${AppConstants.adminUsersEndpoint}/$userId', data: data);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update user');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<RecordingModel>> getUserRecordings(String userId) async {
    try {
      final response = await dio.get('${AppConstants.adminUsersEndpoint}/$userId/recordings');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => RecordingModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get user recordings');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingModel> getAdminRecordingDetail(String recordingId) async {
    try {
      final response = await dio.get('/admin/recordings/$recordingId');
      if (response.statusCode == 200) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get admin recording detail');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

