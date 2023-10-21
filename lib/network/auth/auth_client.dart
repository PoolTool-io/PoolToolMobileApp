import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pegasus_tool/network/verification/verification_client.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: "https://api.pooltool.io/v0/")
abstract class AuthClient {
  factory AuthClient(Dio dio) = _AuthClient;

  @POST("/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest loginRequest);

  @POST("/auth/forgotpassword")
  Future<VerificationStatus> forgotPasswordPost(
      @Body() ForgotPasswordRequestBody body);

  @GET("/auth/forgotpassword/{address}")
  Future<VerificationStatus> getVerificationStatus(@Path() String address);
}

@JsonSerializable()
class LoginResponse {
  String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  String address;
  String password;

  LoginRequest({required this.address, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequestBody {
  String address;
  String password;

  ForgotPasswordRequestBody({required this.address, required this.password});

  factory ForgotPasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestBodyToJson(this);
}
