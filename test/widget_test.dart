import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_10/main.dart';

void main() {
  testWidgets('MainApp smoke test', (WidgetTester tester) async {
    // Membangun aplikasi dan memicu frame
    await tester.pumpWidget(const MyApp());

    // Memverifikasi teks judul menu utama tampil
    expect(find.text('Main App - Local Storage Demo'), findsOneWidget);
    expect(find.text('Notes App'), findsOneWidget);
    expect(find.text('Contact App'), findsOneWidget);
    expect(find.text('Task App'), findsOneWidget);
  });
}
