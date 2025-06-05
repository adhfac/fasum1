import 'package:fasum1/helper/locale_provider.dart';
import 'package:fasum1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<LocaleProvider>(
          builder: (context, provider, child) {
            final currentLocale = provider.locale;

            final supportedLanguages = {
              'en': const Locale('en'),
              'id': const Locale('id'),
            };

            final languageNames = {'en': loc.english, 'id': loc.indonesian};

            return ListTile(
              title: Text(loc.language),
              subtitle: Text(
                languageNames[currentLocale.languageCode] ??
                    loc.unknownLanguage,
              ),
              trailing: DropdownButton<Locale>(
                value: currentLocale,
                items:
                    supportedLanguages.entries.map((entry) {
                      return DropdownMenuItem<Locale>(
                        value: entry.value,
                        child: Text(languageNames[entry.key] ?? entry.key),
                      );
                    }).toList(),
                onChanged: (locale) {
                  if (locale != null) {
                    provider.setLocale(locale);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
