import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tracks bundled asset paths via Flutter's AssetManifest so optional drop-in
/// illustrations in `assets/images/` (`.png`, `.jpg`, `.jpeg`, `.webp`) render
/// automatically when present without logging missing-asset errors when absent.
class BundledImageRegistry {
  BundledImageRegistry._();

  static Set<String> _assets = const {};
  static const _extensions = ['.png', '.jpg', '.jpeg', '.webp'];

  static Future<void> load() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _assets = manifest.listAssets().toSet();
    } catch (_) {
      _assets = const {};
    }
  }

  /// Resolves either an exact path or a extensionless basePath against
  /// `.png`, `.jpg`, `.jpeg`, `.webp`.
  static String? resolve(String pathOrBase) {
    if (_assets.contains(pathOrBase)) return pathOrBase;
    for (final ext in _extensions) {
      final candidate = '$pathOrBase$ext';
      if (_assets.contains(candidate)) return candidate;
    }
    return null;
  }
}

class OptionalAssetImage extends StatelessWidget {
  final String basePath;
  final Widget fallback;
  final BoxFit fit;

  const OptionalAssetImage({
    super.key,
    required this.basePath,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = BundledImageRegistry.resolve(basePath);
    if (resolved == null) {
      return fallback;
    }
    return Image.asset(
      resolved,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
