import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/main.dart';

void main() {
  testWidgets('Splash shows brand title', (tester) async {
    await tester.pumpWidget(
      MyApp(controller: SplashController(androidSdk: () async => null)),
    );
    await tester.pump();

    expect(find.text('Linoooooo'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
  });
}
