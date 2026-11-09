import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

class WelcomeLandingScreen extends StatelessWidget {
  final AppStrings strings;
  final VoidCallback onEnterApp;
  final ValueChanged<String> onSelectLanguage;

  const WelcomeLandingScreen({
    super.key,
    required this.strings,
    required this.onEnterApp,
    required this.onSelectLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundObsidian,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.accentGreen.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppTheme.accentGreen,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              strings.proUnlockedBadge,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.accentGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: AppStrings.supportedCodes.map((lang) {
                      final active = strings.code == lang;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: InkWell(
                          key: Key('welcomeLang_$lang'),
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => onSelectLanguage(lang),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppTheme.accentGreen
                                  : AppTheme.surfaceSlate,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: active
                                    ? AppTheme.accentGreen
                                    : AppTheme.borderColor,
                              ),
                            ),
                            child: Text(
                              lang.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: active
                                    ? const Color(0xFF04140B)
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.accentGreen.withValues(alpha: 0.28),
                          AppTheme.surfaceSlate,
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.accentGreen,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.gps_fixed_rounded,
                      size: 32,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.appTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          strings.welcomeHeadline,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                strings.welcomeDescription,
                style: const TextStyle(
                  fontSize: 12.8,
                  height: 1.38,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              _FeatureCard(
                icon: Icons.architecture_rounded,
                accent: AppTheme.accentGreen,
                title: strings.feature1Title,
                description: strings.feature1Desc,
              ),
              const SizedBox(height: 8),
              _FeatureCard(
                icon: Icons.explore_rounded,
                accent: AppTheme.accentCyan,
                title: strings.feature2Title,
                description: strings.feature2Desc,
              ),
              const SizedBox(height: 8),
              _FeatureCard(
                icon: Icons.picture_as_pdf_rounded,
                accent: AppTheme.accentAmber,
                title: strings.feature3Title,
                description: strings.feature3Desc,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  key: const Key('btnWelcomeEnter'),
                  onPressed: onEnterApp,
                  icon: const Icon(Icons.radar_rounded),
                  label: Text(strings.enterAppButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSlate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
