import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/pool_tool_app.dart';
import 'package:pegasus_tool/provider/theme_provider.dart';
import 'package:pegasus_tool/services/firebase_analytics_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_firebase.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    GetIt.I.registerLazySingleton(() => NavigationService());
    GetIt.I.registerLazySingleton(() => FirebaseAnalyticsService());
    GetIt.I.registerLazySingleton(() => FirebaseMessagingService());
  });

  testWidgets('Test PoolToolApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
      ),
    ], child: const PoolToolApp()));

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Choose your Stake Pool'), findsOneWidget);
    // expect(find.byWidget(Container(), skipOffstage: true), findsOneWidget);
  });
}
