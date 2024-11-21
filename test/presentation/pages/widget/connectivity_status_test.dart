import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enpal_monitor/presentation/widgets/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  testWidgets('displays connectivity warning when no network', (tester) async {
    // Create a custom stream that simulates no network
    final mockStream = Stream.value([ConnectivityResult.none]);

    // Build the widget and inject the custom stream
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConnectivityStatus(connectivityStream: mockStream),
        ),
      ),
    );

    // Pump the widget tree to allow stream updates to trigger a rebuild
    await tester.pumpAndSettle();

    // Verify the widget tree contains the "Unable to Connect" message.
    expect(find.text('Unable to Connect'), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Spacer), findsNWidgets(2));

    // Verify the container has the correct background color
    final container = tester.firstWidget<Container>(find.byType(Container));
    expect(container.color, Colors.red);
  });

  testWidgets('does not display connectivity warning when connected', (tester) async {
    // Create a custom stream that simulates network connectivity (e.g., mobile network)
    final mockStream = Stream.value([ConnectivityResult.mobile]);

    // Build the widget and inject the custom stream
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConnectivityStatus(connectivityStream: mockStream),
        ),
      ),
    );

    // Pump the widget tree to allow stream updates to trigger a rebuild
    await tester.pumpAndSettle();

    // Verify that no "Unable to Connect" message is shown.
    expect(find.text('Unable to Connect'), findsNothing);
    expect(find.byType(Container), findsNothing);
  });
}
