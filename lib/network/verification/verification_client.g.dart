// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationStatus _$VerificationStatusFromJson(Map<String, dynamic> json) =>
    VerificationStatus(
      status: json['status'] as String,
      createdDate: json['createdDate'] as num,
      paymentToAddress: json['paymentToAddress'] as String,
      paymentAmount: json['paymentAmount'] as num,
      verificationDate: json['verificationDate'] as num?,
      stakeKeyHash: json['stakeKeyHash'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$VerificationStatusToJson(VerificationStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'createdDate': instance.createdDate,
      'paymentToAddress': instance.paymentToAddress,
      'paymentAmount': instance.paymentAmount,
      'verificationDate': instance.verificationDate,
      'stakeKeyHash': instance.stakeKeyHash,
      'userId': instance.userId,
    };

VerificationStatusPostBody _$VerificationStatusPostBodyFromJson(
        Map<String, dynamic> json) =>
    VerificationStatusPostBody(
      userId: json['userId'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$VerificationStatusPostBodyToJson(
        VerificationStatusPostBody instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'password': instance.password,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _VerificationClient implements VerificationClient {
  _VerificationClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.pooltool.io/v0/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<VerificationStatus> postVerificationStatus(
    String address,
    VerificationStatusPostBody body,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<VerificationStatus>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/verification/${address}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VerificationStatus.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerificationStatus> getVerificationStatus(
    String address,
    String userId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userId': userId};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<VerificationStatus>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/verification/${address}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VerificationStatus.fromJson(_result.data!);
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
