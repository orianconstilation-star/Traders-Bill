import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('settings'))),
      body: ListView(
        children: [
          ListTile(
            title: Text(loc.translate('language')),
            trailing: DropdownButton<String>(
              value: localeProvider.locale.languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(loc.translate('english'))),
                DropdownMenuItem(value: 'hi', child: Text(loc.translate('hindi'))),
              ],
              onChanged: (val) {
                if (val != null) {
                  localeProvider.setLocale(Locale(val));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
