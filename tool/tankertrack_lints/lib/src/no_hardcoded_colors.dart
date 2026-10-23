import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../tankertrack_lints.dart';

/// Bans `Color(0x…)` and `Colors.*` outside design_system.
/// Widgets read color ONLY via `context.colors` / `context.status`.
class NoHardcodedColors extends DartLintRule {
  const NoHardcodedColors()
      : super(
          code: const LintCode(
            name: 'no_hardcoded_colors',
            problemMessage:
                'Hard-coded color. Use context.colors / context.status (08 3.1).',
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
    context.registry.addInstanceCreationExpression((node) {
      if (ctorTypeName(node) == 'Color') {
        reporter.atNode(node, code);
      }
    });
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.toString() == 'Colors') {
        reporter.atNode(node, code);
      }
    });
  }
}
