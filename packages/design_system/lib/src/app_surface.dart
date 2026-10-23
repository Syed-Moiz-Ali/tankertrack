/// Which product surface a theme variant targets.
///
/// All three variants are built from the same [AppPalette] — only scale,
/// density and component sizing differ. Screens never branch on platform
/// for styling; the surface is set once at the app root.
enum AppSurface { driver, web, controlRoom }
