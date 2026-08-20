import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/app/app.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
import 'package:tailor_app/core/localization/app_locale.dart';

void main() {
  testWidgets('locales use the expected text direction', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const TailorApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Welcome'))),
      TextDirection.ltr,
    );

    container.read(localeProvider.notifier).state = AppLocale.urdu;
    await tester.pumpAndSettle();
    expect(find.text('خوش آمدید'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('خوش آمدید'))),
      TextDirection.rtl,
    );

    container.read(localeProvider.notifier).state = AppLocale.romanUrdu;
    await tester.pumpAndSettle();
    expect(find.text('Khush Aamdeed'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Khush Aamdeed'))),
      TextDirection.ltr,
    );
  });

  test('Drift database initializes with its foundation table', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.initialize();
    expect(await database.select(database.appMetadata).get(), isEmpty);
  });
}
