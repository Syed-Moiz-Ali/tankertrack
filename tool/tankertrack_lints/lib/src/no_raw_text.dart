import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../tankertrack_lints.dart';

/// Bans raw string literals as the child of `Text(…)` — user-visible
/// strings must come from `context.l10n` (ARB).
class NoRawTextStrings extends DartLintRule {
  const NoRawTextStrings()
      : super(
          code: const LintCode(
            name: 'no_raw_text_strings',
            problemMessage:
                'Hard-coded user-visible string. Use context.l10n (08 3.1).',
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
      if (ctorTypeName(node) != 'Text') return;
      final args = node.argumentList.arguments;
      if (args.isEmpty) return;
      if (args.first is SimpleStringLiteral) {
        reporter.atNode(args.first, code);
      }
    });
  }
}
