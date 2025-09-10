import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_selection_widget.dart';
import '../generated/l10n/app_localizations.dart';

/// Dedicated language settings screen
class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language description
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.language,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getLanguageDescription(l10n),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current language info
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.language,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getCurrentLanguageLabel(l10n),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.color,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      languageProvider.currentLanguageName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Language selection
                  LanguageSelectionWidget(
                    onLanguageChanged: () {
                      setState(() {
                        _isLoading = true;
                      });

                      // Add a small delay to show the loading state
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Reset to device language option
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.refresh,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(_getResetLanguageLabel(l10n)),
                      subtitle: Text(_getResetLanguageDescription(l10n)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showResetLanguageDialog(context),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Additional language info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getSupportedLanguagesLabel(l10n),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...LanguageProvider.getSupportedLanguagesWithNames()
                              .entries
                              .map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.value,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getLanguageDescription(AppLocalizations l10n) {
    // Return appropriate description based on current language
    switch (l10n.localeName) {
      case 'hi':
        return 'अपनी पसंदीदा भाषा चुनें। यह ऐप में सभी टेक्स्ट और मैसेज की भाषा बदल देगा।';
      case 'pa':
        return 'ਆਪਣੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਚੁਣੋ। ਇਹ ਐਪ ਵਿੱਚ ਸਾਰੇ ਟੈਕਸਟ ਅਤੇ ਸੰਦੇਸ਼ਾਂ ਦੀ ਭਾਸ਼ਾ ਬਦਲ ਦੇਵੇਗਾ।';
      default:
        return 'Choose your preferred language. This will change the language of all text and messages in the app.';
    }
  }

  String _getCurrentLanguageLabel(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'वर्तमान भाषा';
      case 'pa':
        return 'ਮੌਜੂਦਾ ਭਾਸ਼ਾ';
      default:
        return 'Current Language';
    }
  }

  String _getResetLanguageLabel(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'डिवाइस भाषा का उपयोग करें';
      case 'pa':
        return 'ਡਿਵਾਇਸ ਭਾਸ਼ਾ ਵਰਤੋ';
      default:
        return 'Use Device Language';
    }
  }

  String _getResetLanguageDescription(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'अपने डिवाइस की डिफ़ॉल्ट भाषा पर वापस जाएं';
      case 'pa':
        return 'ਆਪਣੇ ਡਿਵਾਇਸ ਦੀ ਡਿਫਾਲਟ ਭਾਸ਼ਾ \'ਤੇ ਵਾਪਸ ਜਾਓ';
      default:
        return 'Reset to your device\'s default language';
    }
  }

  String _getSupportedLanguagesLabel(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'समर्थित भाषाएं';
      case 'pa':
        return 'ਸਮਰਥਿਤ ਭਾਸ਼ਾਵਾਂ';
      default:
        return 'Supported Languages';
    }
  }

  void _showResetLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getResetLanguageLabel(l10n)),
        content: Text(_getResetConfirmationMessage(l10n)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = true;
              });

              await context.read<LanguageProvider>().resetToDeviceLanguage();

              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Text(_getResetConfirmLabel(l10n)),
          ),
        ],
      ),
    );
  }

  String _getResetConfirmationMessage(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'क्या आप अपने डिवाइस की डिफ़ॉल्ट भाषा पर वापस जाना चाहते हैं?';
      case 'pa':
        return 'ਕੀ ਤੁਸੀਂ ਆਪਣੇ ਡਿਵਾਇਸ ਦੀ ਡਿਫਾਲਟ ਭਾਸ਼ਾ \'ਤੇ ਵਾਪਸ ਜਾਣਾ ਚਾਹੁੰਦੇ ਹੋ?';
      default:
        return 'Do you want to reset to your device\'s default language?';
    }
  }

  String _getResetConfirmLabel(AppLocalizations l10n) {
    switch (l10n.localeName) {
      case 'hi':
        return 'रीसेट करें';
      case 'pa':
        return 'ਰੀਸੈਟ ਕਰੋ';
      default:
        return 'Reset';
    }
  }
}
