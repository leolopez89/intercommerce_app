import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intercommerce_app/main.dart';

void main() {
  testWidgets('Main page test', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: const InterCommerceApp()));

    expect(find.text('InterCommerce'), findsOneWidget);
  });
}
