import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sari_scan/database.dart';
import 'package:sari_scan/db.dart';
import 'package:sari_scan/main.dart';

/// The value the Language radios render their selection from.
Locale? localeGroupValue(WidgetTester tester) =>
    tester.widget<RadioGroup<Locale?>>(find.byType(RadioGroup<Locale?>)).groupValue;

/// The value the Appearance radios render their selection from.
ThemeMode? themeGroupValue(WidgetTester tester) =>
    tester.widget<RadioGroup<ThemeMode>>(find.byType(RadioGroup<ThemeMode>)).groupValue;

Future<void> openSettings(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    setDatabaseForTesting(AppDatabase.forTesting(NativeDatabase.memory()));
  });

  tearDown(resetDatabaseForTesting);

  group('Language', () {
    // Issue #13 repro: device locale is English, so tapping "English" does not
    // change the *resolved* locale.
    testWidgets('selecting English from System default updates immediately',
        (tester) async {
      await openSettings(tester);
      expect(localeGroupValue(tester), isNull);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(localeGroupValue(tester), const Locale('en'));
    });

    // Control: this one *does* change the resolved locale.
    testWidgets('selecting Cebuano from System default updates immediately',
        (tester) async {
      await openSettings(tester);

      await tester.tap(find.text('Cebuano'));
      await tester.pumpAndSettle();

      expect(localeGroupValue(tester), const Locale('ceb'));
    });
  });

  group('Appearance', () {
    // Test platform brightness is light, so ThemeMode.light resolves to the
    // same ThemeData that ThemeMode.system already produced.
    testWidgets('selecting Light from System default updates immediately',
        (tester) async {
      await openSettings(tester);
      expect(themeGroupValue(tester), ThemeMode.system);

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(themeGroupValue(tester), ThemeMode.light);
    });

    // Control: this one *does* change the resolved theme.
    testWidgets('selecting Dark from System default updates immediately',
        (tester) async {
      await openSettings(tester);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(themeGroupValue(tester), ThemeMode.dark);
    });
  });
}
