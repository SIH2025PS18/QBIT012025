import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../generated/l10n/app_localizations.dart';

/// Language selection widget that can be used in settings or as a standalone dialog
class LanguageSelectionWidget extends StatelessWidget {
  final bool showTitle;
  final bool showIcon;
  final VoidCallback? onLanguageChanged;

  const LanguageSelectionWidget({
    super.key,
    this.showTitle = true,
    this.showIcon = true,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final l10n = AppLocalizations.of(context)!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTitle) ...[
              Text(
                l10n.selectLanguage,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],
            ...LanguageProvider.supportedLocales.map((locale) {
              final isSelected = languageProvider.currentLocale == locale;
              final languageName = LanguageProvider.getLanguageDisplayName(
                locale.languageCode,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
                child: ListTile(
                  leading: showIcon
                      ? Icon(
                          _getLanguageIcon(locale.languageCode),
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : null,
                        )
                      : null,
                  title: Text(
                    languageName,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                        )
                      : const Icon(Icons.radio_button_unchecked),
                  onTap: () async {
                    if (!isSelected) {
                      await languageProvider.changeLanguage(
                        locale.languageCode,
                      );
                      onLanguageChanged?.call();
                    }
                  },
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  IconData _getLanguageIcon(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Icons.language;
      case 'hi':
        return Icons.translate;
      case 'pa':
        return Icons.record_voice_over;
      default:
        return Icons.language;
    }
  }
}

/// Language selection dialog
class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const LanguageSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.language),
          const SizedBox(width: 8),
          Text(l10n.selectLanguage),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: LanguageSelectionWidget(
          showTitle: false,
          onLanguageChanged: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

/// Language selection dropdown button
class LanguageDropdownButton extends StatelessWidget {
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;

  const LanguageDropdownButton({
    super.key,
    this.isExpanded = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: languageProvider.currentLanguageCode,
            isExpanded: isExpanded,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down),
            onChanged: (String? newValue) async {
              if (newValue != null) {
                await languageProvider.changeLanguage(newValue);
              }
            },
            items: LanguageProvider.supportedLocales.map((locale) {
              final languageName = LanguageProvider.getLanguageName(
                locale.languageCode,
              );

              return DropdownMenuItem<String>(
                value: locale.languageCode,
                child: Row(
                  children: [
                    Icon(_getLanguageIcon(locale.languageCode), size: 20),
                    const SizedBox(width: 8),
                    Text(languageName),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  IconData _getLanguageIcon(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Icons.language;
      case 'hi':
        return Icons.translate;
      case 'pa':
        return Icons.record_voice_over;
      default:
        return Icons.language;
    }
  }
}

/// Simple language toggle button for common use cases
class LanguageToggleButton extends StatelessWidget {
  final IconData? icon;
  final String? tooltip;

  const LanguageToggleButton({super.key, this.icon, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final l10n = AppLocalizations.of(context)!;

        return IconButton(
          icon: Icon(icon ?? Icons.language),
          tooltip: tooltip ?? l10n.selectLanguage,
          onPressed: () => LanguageSelectionDialog.show(context),
        );
      },
    );
  }
}
