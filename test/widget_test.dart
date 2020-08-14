import "package:circles_app/circles_app.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("finds Menu label", (WidgetTester tester) async {
    await tester.pumpWidget(CirclesApp());
    expect(find.bySemanticsLabel("Menu"), findsOneWidget);
  });
}
