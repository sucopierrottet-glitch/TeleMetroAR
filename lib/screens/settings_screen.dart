import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final AppStrings strings;
  final ValueChanged<String> onSelectLanguage;
  final double eyeHeightMeters;
  final ValueChanged<double> onEyeHeightChanged;

  const SettingsScreen({
    super.key,
    required this.strings,
    required this.onSelectLanguage,
    required this.eyeHeightMeters,
    required this.onEyeHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = strings;
    final langNames = {
      'es': 'Español (ES)',
      'en': 'English (EN)',
      'pt': 'Português (PT)',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1-Tap Language Switcher
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        color: AppTheme.accentGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.languageSectionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: AppStrings.supportedCodes.map((code) {
                      final selected = s.code == code;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            key: Key('btnLang_$code'),
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => onSelectLanguage(code),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.accentGreen
                                    : AppTheme.backgroundObsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? AppTheme.accentGreen
                                      : AppTheme.borderColor,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    code.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: selected
                                          ? const Color(0xFF04140B)
                                          : AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    langNames[code] ?? code,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: selected
                                          ? const Color(0xFF04140B)
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Default Eye Height Calibration
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: AppTheme.accentCyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.unitsSectionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${s.eyeHeightLabel}: ${eyeHeightMeters.toStringAsFixed(2)} m',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentCyan,
                    ),
                  ),
                  Slider(
                    key: const Key('sliderSettingsEyeHeight'),
                    value: eyeHeightMeters.clamp(0.5, 3.0),
                    min: 0.5,
                    max: 3.0,
                    onChanged: onEyeHeightChanged,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Trigonometric Reference Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.functions_rounded,
                        color: AppTheme.accentAmber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.formulaReferenceTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '• D = h_eye / tan(|θ_base|)\n'
                    '• H = h_eye + D · tan(θ_top)\n'
                    '• LOS = D / cos(|θ|)\n'
                    '• Slope (%) = tan(θ) × 100\n'
                    '• Roof Pitch (X:12) = |tan(θ)| × 12',
                    style: TextStyle(
                      fontSize: 12.8,
                      height: 1.55,
                      color: AppTheme.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // About & Offline Privacy Guarantee
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_rounded,
                        color: AppTheme.accentGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.aboutSectionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.proUnlockedBadge,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.privacyPolicySummary,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Package: com.simpleappspg.telemetroar • v1.0.0+1',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
