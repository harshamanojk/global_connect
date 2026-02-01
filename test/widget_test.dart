import 'package:flutter_test/flutter_test.dart';
import 'package:global_connect/main.dart';

void main() {
  testWidgets('Landing page displays correct title and slogan', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(GlobalConnectApp());

    // Verify that the landing page title is shown
    expect(find.text('Welcome To GlobalConnect'), findsOneWidget);
    expect(find.text('Stay Connected Anywhere'), findsOneWidget);

    // Verify that info text is shown
    expect(find.text('Make voice calls and send messages without local SIM or Wi-Fi'), findsOneWidget);

    // Verify that LOGIN and REGISTER buttons are present
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
  });
}
