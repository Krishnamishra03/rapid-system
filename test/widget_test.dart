import 'package:flutter_test/flutter_test.dart';
import 'package:rapid_smart_attendance/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RapidSmartAttendanceApp());
    expect(find.text('Rapid Smart Attendance'), findsOneWidget);
  });
}
