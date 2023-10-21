import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:pegasus_tool/models/live_delegators_model.dart';
import 'package:retrofit/retrofit.dart';

part 'delegators_client.g.dart';

@RestApi(baseUrl: "https://s3-us-west-2.amazonaws.com/data.pooltool.io/")
abstract class DelegatorsClient {
  factory DelegatorsClient(Dio dio) = _DelegatorsClient;

  @Headers({"Accept": "application/json"})
  @GET("/live_delegators_by_pool/{poolId}.json?t={time}")
  Future<LiveDelegators> getDelegators(
      @Path("poolId") String poolId, @Path("time") int time);
}
