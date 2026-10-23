import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../tankertrack_lints.dart';

/// Bans `TextStyle(…)` construction and `fontSize:` / `fontWeight:` /
/// `fontFamily:` literals outside design_system.
/// Widgets read text styles ONLY via `context.text`.
class NoBannedTextStyle extends DartLintRule {
  const NoBannedTextStyle()
      : super(
          code: const LintCode(
            name: 'no_banned_text_style',
            problemMessage:
                'Hard-coded text style. Use context.text styles (08 3.1).',
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
      if (ctorTypeName(node) == 'TextStyle') {
        reporter.atNode(node, code);
      }
    });
    context.registry.addNamedExpression((node) {
      const banned = {'fontSize:', 'fontWeight:', 'fontFamily:'};
      if (banned.contains(node.name.toString())) {
        reporter.atNode(node, code);
      }
    });
  }
}

/// Bans numeric-literal spacing: `EdgeInsets*(<num>…)`,
/// `BorderRadius.circular(<num>)`, `SizedBox(width|height: <num>)`,
/// `Duration(<num>…)` in UI code.
/// Widgets use `context.tokens` + `TTGap` instead.
class NoNumericSpacing extends DartLintRule {
  const NoNumericSpacing()
      : super(
          code: const LintCode(
            name: 'no_numeric_spacing',
            problemMessage:
                'Numeric spacing literal. Use context.tokens / TTGap (08 3.1).',
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  static const _edgeInsets = {
    'EdgeInsets',
    'EdgeInsetsDirectional',
    'EdgeInsetsGeometry',
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExempt(resolver.source.fullName)) return;
    // Spacing/duration literals are a UI concern (08 §4 bans them in
    // widgets). Non-UI layers own legitimate numeric timing and layout
    // math — skip them here. The script net (check_centralization)
    // covers apps/* + fleet_ui exhaustively.
    final p = resolver.source.fullName.replaceAll(r'\', '/');
    final isNonUi = p.contains('packages/data/') ||
        p.contains('packages/core/') ||
        p.contains('packages/domain/') ||
        p.contains('packages/l10n/');
    if (isNonUi) return;

    bool hasNumericLiteral(ArgumentList args) {
      for (final arg in args.arguments) {
        final Expression exp =
            arg is NamedExpression ? arg.expression : arg;
        if (exp is IntegerLiteral || exp is DoubleLiteral) return true;
      }
      return false;
    }

    context.registry.addInstanceCreationExpression((node) {
      // NOTE (analyzer 7): type.toString() includes the named constructor
      // ('EdgeInsets.all'), and constructorName.name is null — split it.
      final full = ctorTypeName(node);
      final type = full;
      final ctor = node.constructorName.type.toString().contains('.')
          ? node.constructorName.type.toString().split('.').sublist(1).join('.')
          : '';
      if (_edgeInsets.contains(type) && hasNumericLiteral(node.argumentList)) {
        reporter.atNode(node, code);
        return;
      }
      if (type == 'BorderRadius' &&
          ctor == 'circular' &&
          hasNumericLiteral(node.argumentList)) {
        reporter.atNode(node, code);
        return;
      }
      if (type == 'SizedBox') {
        for (final arg in node.argumentList.arguments) {
          if (arg is NamedExpression &&
              (arg.name.toString() == 'width:' ||
                  arg.name.toString() == 'height:') &&
              (arg.expression is IntegerLiteral ||
                  arg.expression is DoubleLiteral)) {
            reporter.atNode(node, code);
            return;
          }
        }
      }
      if (type == 'Duration' && hasNumericLiteral(node.argumentList)) {
        reporter.atNode(node, code);
      }
    });
  }
}
