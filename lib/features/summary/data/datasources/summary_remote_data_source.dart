import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/summary_model.dart';

abstract class SummaryRemoteDataSource {
  // Legacy methods
  Future<SummaryModel> getSummary(String transcriptionId);
  Future<SummaryModel> saveSummary(SummaryModel summary);
  Future<SummaryModel> resummarize(String transcriptionId);
  Future<SummaryModel> updateActionItem(
    String summaryId,
    String actionItemId,
    bool isCompleted,
  );

  // Recording-based summary methods (new API)
  Future<SummaryModel> summarizeRecording({
    required String recordingId,
    String? summaryStyle,
  });
  Future<List<SummaryModel>> getSummaries({
    required String recordingId,
    bool? latest,
  });
  Future<SummaryModel> getSummaryDetail(String summaryId);
  Future<SummaryModel> updateSummary({
    required String summaryId,
    Map<String, dynamic>? contentStructure,
    String? type,
    bool? isLatest,
  });
}

class SummaryRemoteDataSourceImpl implements SummaryRemoteDataSource {
  final Dio dio;

  SummaryRemoteDataSourceImpl({required this.dio});

  @override
  Future<SummaryModel> getSummary(String transcriptionId) async {
    try {
      final response = await dio.get(
        '/summary/$transcriptionId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get summary');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> saveSummary(SummaryModel summary) async {
    try {
      final response = await dio.post(
        '/summary',
        data: summary.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to save summary');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> resummarize(String transcriptionId) async {
    try {
      final response = await dio.post(
        '/summary/resummarize',
        data: {'transcription_id': transcriptionId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to resummarize');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> updateActionItem(
    String summaryId,
    String actionItemId,
    bool isCompleted,
  ) async {
    try {
      final response = await dio.patch(
        '/summary/$summaryId/action-items/$actionItemId',
        data: {'is_completed': isCompleted},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update action item');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> summarizeRecording({
    required String recordingId,
    String? summaryStyle,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (summaryStyle != null) data['summary_style'] = summaryStyle;

      final response = await dio.post(
        '${AppConstants.recordingsEndpoint}/$recordingId/summarize',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to summarize recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<SummaryModel>> getSummaries({
    required String recordingId,
    bool? latest,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (latest != null) queryParams['latest'] = latest;

      final response = await dio.get(
        '${AppConstants.recordingsEndpoint}/$recordingId/summaries',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => SummaryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get summaries');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> getSummaryDetail(String summaryId) async {
    try {
      final response = await dio.get(
        '${AppConstants.summariesEndpoint}/$summaryId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get summary detail');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<SummaryModel> updateSummary({
    required String summaryId,
    Map<String, dynamic>? contentStructure,
    String? type,
    bool? isLatest,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (contentStructure != null) data['content_structure'] = contentStructure;
      if (type != null) data['type'] = type;
      if (isLatest != null) data['is_latest'] = isLatest;

      final response = await dio.patch(
        '${AppConstants.summariesEndpoint}/$summaryId',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SummaryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update summary');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

