import 'package:analyzer/dart/ast/ast.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/no_banned_styling.dart';
import 'src/no_hardcoded_colors.dart';
import 'src/no_material_icons.dart';
import 'src/no_raw_text.dart';

/// Centralization lints (`docs/plan/08-ui-centralization.md` §4–§5).
///
/// These rules apply to feature code (`apps/*`, `fleet_ui`, …).
/// `packages/design_system`, generated code and tests are exempt —
/// see [isExempt] — because tokens are *defined* there.
PluginBase createPlugin() => _CentralizationPlugin();

class _CentralizationPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const NoHardcodedColors(),
        const NoBannedTextStyle(),
        const NoNumericSpacing(),
        const NoMaterialIcons(),
        const NoRawTextStrings(),
      ];
}

/// NOTE (analyzer 7): `InstanceCreationExpression.constructorName.type`
/// stringifies WITH the named constructor ('EdgeInsets.all'), and
/// `constructorName.name` is null. Split on '.' for the plain type name.
String ctorTypeName(InstanceCreationExpression node) =>
    node.constructorName.type.toString().split('.').first;

/// Path-based exemption: token definitions, generated code, tests.
bool isExempt(String fullPath) {
  final p = fullPath.replaceAll(r'\', '/');
  return p.contains('packages/design_system/') ||
      p.contains('tool/tankertrack_lints/') ||
      p.contains('/test/') ||
      p.contains('/gen/') ||
      p.endsWith('.g.dart') ||
      p.endsWith('.freezed.dart') ||
      p.endsWith('.gen.dart');
}
