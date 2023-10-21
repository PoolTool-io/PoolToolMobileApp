// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pivot_rewards_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PivotRewardsResponse _$PivotRewardsResponseFromJson(
        Map<String, dynamic> json) =>
    PivotRewardsResponse(
      success: json['success'] as bool,
    );

Map<String, dynamic> _$PivotRewardsResponseToJson(
        PivotRewardsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };

PivotRewardsRequest _$PivotRewardsRequestFromJson(Map<String, dynamic> json) =>
    PivotRewardsRequest(
      stake_key: json['stake_key'] as String,
    );

Map<String, dynamic> _$PivotRewardsRequestToJson(
        PivotRewardsRequest instance) =>
    <String, dynamic>{
      'stake_key': instance.stake_key,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _PivotRewardsClient implements PivotRewardsClient {
  _PivotRewardsClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.pooltool.io/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<PivotRewardsResponse> pivotRewards(
      PivotRewardsRequest pivotRewardsRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(pivotRewardsRequest.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PivotRewardsResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/pivotrewards',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PivotRewardsResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
