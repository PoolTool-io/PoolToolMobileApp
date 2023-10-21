import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'pivot_rewards_client.g.dart';

@RestApi(baseUrl: "https://api.pooltool.io/v1/")
abstract class PivotRewardsClient {
  factory PivotRewardsClient(Dio dio) = _PivotRewardsClient;

  @POST("/pivotrewards")
  Future<PivotRewardsResponse> pivotRewards(
      @Body() PivotRewardsRequest pivotRewardsRequest);
}

@JsonSerializable()
class PivotRewardsResponse {
  bool success;

  PivotRewardsResponse({required this.success});

  factory PivotRewardsResponse.fromJson(Map<String, dynamic> json) =>
      _$PivotRewardsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PivotRewardsResponseToJson(this);
}

@JsonSerializable()
class PivotRewardsRequest {
  String stake_key;

  PivotRewardsRequest({required this.stake_key});

  factory PivotRewardsRequest.fromJson(Map<String, dynamic> json) =>
      _$PivotRewardsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PivotRewardsRequestToJson(this);
}
