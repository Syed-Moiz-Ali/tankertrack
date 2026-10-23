import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Golden catalogue: light/dark × LTR/RTL × driver/web/controlRoom (08 §5.3).
/// LTR uses English labels, RTL uses Arabic labels (test fixtures are
/// lint-exempt; app-level ar-RTL goldens land with the apps in P1+).
/// Generate: `flutter test --update-goldens test/goldens`.
void main() {
  const enStrings = DesignStrings(
    components: 'Components',
    buttons: 'Buttons',
    primary: 'Primary',
    secondary: 'Secondary',
    tertiary: 'Tertiary',
    fields: 'Fields',
    searchHint: 'Search orders, drivers, vehicles…',
    chips: 'Status chips',
    quantities: 'Quantities',
    sync: 'Sync badges',
    cards: 'Cards',
    banners: 'Banners',
    states: 'States',
    emptyTitle: 'Nothing here yet',
    emptyMessage: 'Items you create will appear in this list.',
    errorTitle: 'Something went wrong',
    errorMessage: 'Check your connection and try again.',
    retry: 'Retry',
    flow: 'Flow',
  );

  const arStrings = DesignStrings(
    components: 'المكونات',
    buttons: 'الأزرار',
    primary: 'أساسي',
    secondary: 'ثانوي',
    tertiary: 'ثالث',
    fields: 'الحقول',
    searchHint: 'ابحث في الطلبات والسائقين والمركبات…',
    chips: 'شارات الحالة',
    quantities: 'الكميات',
    sync: 'شارات المزامنة',
    cards: 'البطاقات',
    banners: 'اللافتات',
    states: 'الحالات',
    emptyTitle: 'لا يوجد شيء بعد',
    emptyMessage: 'العناصر التي تنشئها ستظهر في هذه القائمة.',
    errorTitle: 'حدث خطأ ما',
    errorMessage: 'تحقق من اتصالك وحاول مجددًا.',
    retry: 'إعادة المحاولة',
    flow: 'التدفق',
  );

  for (final surface in AppSurface.values) {
    for (final brightness in Brightness.values) {
      for (final rtl in [false, true]) {
        final tag =
            '${surface.name}_${brightness == Brightness.light ? 'light' : 'dark'}_${rtl ? 'rtl' : 'ltr'}';
        testWidgets('catalogue $tag', (tester) async {
          // Icon fonts (Phosphor MIT, test-only copies) so goldens show
          // real glyphs instead of tofu.
          for (final entry in {
            'PhosphorRegular': 'test/fonts/Phosphor.ttf',
            'PhosphorFill': 'test/fonts/Phosphor-Fill.ttf',
          }.entries) {
            final bytes = await File(entry.value).readAsBytes();
            final loader = FontLoader(entry.key);
            loader.addFont(
                Future.value(ByteData.sublistView(bytes)));
            await loader.load();
          }
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.build(
                surface: surface,
                brightness: brightness,
                arabic: rtl,
              ),
              home: Directionality(
                textDirection:
                    rtl ? TextDirection.rtl : TextDirection.ltr,
                child: DesignCatalogue(
                  strings: rtl ? arStrings : enStrings,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(DesignCatalogue),
            matchesGoldenFile('goldens/catalogue_$tag.png'),
          );
        });
      }
    }
  }
}
