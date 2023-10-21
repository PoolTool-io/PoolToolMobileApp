import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  late FirebaseAnalytics firebaseAnalytics;

  FirebaseAnalyticsService() {
    firebaseAnalytics = FirebaseAnalytics.instance;
  }
}
