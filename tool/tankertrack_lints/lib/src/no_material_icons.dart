import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../tankertrack_lints.dart';

/// Bans `Icons.*` / `CupertinoIcons.*` outside design_system.
/// Feature code uses `AppIcons.*` (+ `AppIcons.iconFor` for RTL mirroring).
class NoMaterialIcons extends DartLintRule {
  const NoMaterialIcons()
      : super(
          code: const LintCode(
            name: 'no_material_icons',
            problemMessage: 'Raw Material/Cupertino icon. Use AppIcons (08 3.1).',
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExempt(resolver.source.fullName)) return;
    context.registry.addPrefixedIdentifier((node) {
      final prefix = node.prefix.toString();
      if (prefix == 'Icons' || prefix == 'CupertinoIcons') {
        reporter.atNode(node, code);
      }
    });
  }
}
