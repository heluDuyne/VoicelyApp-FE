import 'package:dio/dio.dart';
import '../models/tier_model.dart';

abstract class TierRemoteDataSource {
  Future<TierModel> getTier(int tierId);
  Future<List<TierModel>> getAllTiers();
  Future<TierModel> updateTier(TierModel tier);
}

class TierRemoteDataSourceImpl implements TierRemoteDataSource {
  final Dio dio;

  TierRemoteDataSourceImpl({required this.dio});

  @override
  Future<TierModel> getTier(int tierId) async {
    try {
      final response = await dio.get('/admin/tiers/$tierId');
      if (response.statusCode == 200) {
        return TierModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get tier');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<TierModel>> getAllTiers() async {
    try {
      final response = await dio.get('/admin/tiers');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => TierModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get all tiers');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<TierModel> updateTier(TierModel tier) async {
    try {
      final response = await dio.put(
        '/admin/tiers/${tier.tierId}',
        data: tier.toJson(),
      );
      if (response.statusCode == 200) {
        return TierModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update tier');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

