import 'package:change/domains/account_domain.dart';
import 'package:change/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDomain = AccountDomain(localDB: ref.watch(localDbProvider));

    useEffect(() {
      if (!accountDomain.isRegistered()) {
        Future.microtask(() => Navigator.pushReplacementNamed(context, '/initialize'));
      }
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ログイン画面'),
              ElevatedButton(
                onPressed: () {
                  login(accountDomain);
                },
                child: const Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(AccountDomain accountDomain) async {
    try {
      await accountDomain.handleLogin();
    } catch (e) {
      print("エラー");
      print(e.runtimeType);
    }
  }
}
