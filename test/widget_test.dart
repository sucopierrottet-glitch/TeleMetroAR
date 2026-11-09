import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemetroar/calculators/telemetro_calculator.dart';
import 'package:telemetroar/l10n/app_strings.dart';
import 'package:telemetroar/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TelemetroCalculator Trigonometric Verification', () {
    test('Calculates horizontal distance D = h_eye / tan(|theta_base|)', () {
      // At 45 degrees depression, tan(45°) = 1.0 => D should equal eyeHeight
      final d45 = TelemetroCalculator.calculateHorizontalDistance(
        eyeHeightMeters: 1.70,
        baseAngleDeg: -45.0,
      );
      expect(d45, closeTo(1.70, 0.005));

      // At 20 degrees depression, D = 1.65 / tan(20°) = 4.533 m
      final d20 = TelemetroCalculator.calculateHorizontalDistance(
        eyeHeightMeters: 1.65,
        baseAngleDeg: -20.0,
      );
      expect(d20, closeTo(4.533, 0.01));
    });

    test('Calculates target height H = h_eye + D * tan(theta_top)', () {
      // If D = 10.0m, h_eye = 1.65m, theta_top = 45° => H = 1.65 + 10.0 = 11.65m
      final h = TelemetroCalculator.calculateTargetHeight(
        eyeHeightMeters: 1.65,
        horizontalDistanceMeters: 10.0,
        topAngleDeg: 45.0,
      );
      expect(h, closeTo(11.65, 0.01));
    });

    test('Calculates slope percentage and roof pitch (X:12)', () {
      expect(TelemetroCalculator.calculateSlopePercent(45.0), closeTo(100.0, 0.1));
      expect(TelemetroCalculator.calculateRoofPitchRise(45.0), closeTo(12.0, 0.1));
    });
  });

  group('TeleMetroApp UI & Navigation Flow', () {
    testWidgets('Renders WelcomeLandingScreen, switches language, and navigates all 4 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TeleMetroApp());
      await tester.pump();

      // Verify Welcome screen renders with enter button
      expect(find.byKey(const Key('btnWelcomeEnter')), findsOneWidget);
      expect(find.textContaining('TeleMetro AR Pro'), findsWidgets);

      // Test language switch on welcome screen to English
      await tester.tap(find.byKey(const Key('welcomeLang_en')));
      await tester.pump();
      expect(find.text(const AppStrings('en').enterAppButton), findsOneWidget);

      // Enter main instrument
      await tester.tap(find.byKey(const Key('btnWelcomeEnter')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tab 1: Rangefinder HUD
      expect(find.byKey(const Key('cardHorizontalDistance')), findsOneWidget);
      expect(find.byKey(const Key('cardTargetHeight')), findsOneWidget);

      // Navigate to Tab 2: 360 Clinometer Level
      await tester.tap(find.byKey(const Key('navTabClinometer')));
      await tester.pump();
      expect(find.byKey(const Key('btnTareZero')), findsOneWidget);

      // Navigate to Tab 3: PDF Logbook
      await tester.tap(find.byKey(const Key('navTabLogbook')));
      await tester.pump();
      expect(find.byKey(const Key('btnExportPdfModal')), findsOneWidget);

      // Navigate to Tab 4: Settings & switch language to Portuguese
      await tester.tap(find.byKey(const Key('navTabSettings')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('btnLang_pt')));
      await tester.pump();
      expect(find.text(const AppStrings('pt').languageSectionTitle), findsOneWidget);
    });
  });
}
