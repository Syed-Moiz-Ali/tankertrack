import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Illustration tile for [TTImageGrid] cells: our SVG on a subtle surface
/// (never a fake photo, never an empty placeholder).
class IllustrationTile extends StatelessWidget {
  const IllustrationTile({super.key, required this.uri});

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surfaceContainerHighest,
      child: Center(
        child: SvgPicture.asset(
          uri,
          width: context.tokens.iconLg * 3,
          height: context.tokens.iconLg * 3,
        ),
      ),
    );
  }
}

/// Full illustration cells for a detail hero grid (5 = no placeholders).
List<Widget> illustrationCells(List<String> uris) =>
    [for (final u in uris) IllustrationTile(uri: u)];

/// Gallery sheet for TTImageGrid "show all" (same illustrations, gridded).
Future<void> openIllustrationGallery(
  BuildContext context, {
  required String title,
  required List<String> uris,
}) {
  final t = context.tokens;
  return showTTGrabberSheet(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: context.text.titleLarge),
        TTGap.md(),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: t.spaceSm,
          crossAxisSpacing: t.spaceSm,
          children: [
            for (final u in uris)
              ClipRRect(
                borderRadius: BorderRadius.circular(t.radiusCard),
                child: IllustrationTile(uri: u),
              ),
          ],
        ),
      ],
    ),
  );
}
