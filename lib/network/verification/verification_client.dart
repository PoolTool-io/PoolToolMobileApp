import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'verification_client.g.dart';

@RestApi(baseUrl: "https://api.pooltool.io/v0/")
abstract class VerificationClient {
  factory VerificationClient(Dio dio) = _VerificationClient;

  @POST("/verification/{address}")
  Future<VerificationStatus> postVerificationStatus(
      @Path() String address, @Body() VerificationStatusPostBody body);

  @GET("/verification/{address}")
  Future<VerificationStatus> getVerificationStatus(
      @Path() String address, @Query("userId") String userId);
}

@JsonSerializable()
class VerificationStatus {
  String status;
  num createdDate;
  String paymentToAddress;
  num paymentAmount;
  num? verificationDate;
  String stakeKeyHash;
  String userId;

  VerificationStatus(
      {required this.status,
      required this.createdDate,
      required this.paymentToAddress,
      required this.paymentAmount,
      this.verificationDate,
      required this.stakeKeyHash,
      required this.userId});

  factory VerificationStatus.fromJson(Map<String, dynamic> json) =>
      _$VerificationStatusFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationStatusToJson(this);
}

@JsonSerializable()
class VerificationStatusPostBody {
  String userId;
  String password;

  VerificationStatusPostBody({required this.userId, required this.password});

  factory VerificationStatusPostBody.fromJson(Map<String, dynamic> json) =>
      _$VerificationStatusPostBodyFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationStatusPostBodyToJson(this);
}
