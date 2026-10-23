import 'package:core/core.dart';

/// POD policy gate (D7/G1): receiver name + (signature OR photo) by default,
/// OTP off. All four toggles live in Configuration (P8).
class PodPolicy {
  const PodPolicy({
    this.requireName = true,
    this.requireSignature = true,
    this.requirePhoto = false,
    this.requireOtp = false,
  });

  final bool requireName;
  final bool requireSignature;
  final bool requirePhoto;
  final bool requireOtp;

  factory PodPolicy.fromFlags(FeatureFlags flags) => PodPolicy(
        requireName: flags.podRequireName,
        requireSignature: flags.podRequireSignature,
        requirePhoto: flags.podRequirePhoto,
        requireOtp: flags.requireOtp,
      );

  Result<bool> satisfied({
    required bool hasName,
    required bool hasSignature,
    required bool hasPhoto,
    required bool hasOtp,
  }) {
    if (requireName && !hasName) {
      return Err(const AppError.validation(message: 'Receiver name required'));
    }
    if (requireSignature && requirePhoto) {
      if (!hasSignature || !hasPhoto) {
        return Err(const AppError.validation(
            message: 'Signature and photo required'));
      }
    } else if (requireSignature || requirePhoto) {
      if (!hasSignature && !hasPhoto) {
        return Err(const AppError.validation(
            message: 'Signature or photo required'));
      }
    }
    if (requireOtp && !hasOtp) {
      return Err(const AppError.validation(message: 'OTP required'));
    }
    return const Ok(true);
  }
}
