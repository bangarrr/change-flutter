import 'package:change/domains/account_domain.dart';
import 'package:change/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingScreen extends HookConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDomain = AccountDomain(localDB: ref.watch(localDbProvider));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('ログアウト'),
              onTap: () async {
                await accountDomain.logout();
              },
            ),
          ],
        ),
      )
    );
  }
}
