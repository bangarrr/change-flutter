import 'package:change/domains/account_domain.dart';
import 'package:change/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitializeScreen extends HookConsumerWidget {
  const InitializeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormBuilderState>();
    final localDB = ref.watch(localDbProvider);
    final accountDomain = AccountDomain(localDB: localDB);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー登録'),
      ),
      body: SafeArea(
        child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                    name: 'username',
                    decoration: const InputDecoration(labelText: 'ユーザー名'),
                  ),
                  FormBuilderChoiceChip<String>(
                    name: 'gender',
                    alignment: WrapAlignment.spaceEvenly,
                    options: [
                      FormBuilderChipOption(
                        value: 'male',
                        avatar: Icon(Icons.man),
                      ),
                      FormBuilderChipOption(
                        value: 'female',
                        avatar: Icon(Icons.woman),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        if (accountDomain.isRegistered()) {
                          // todo: エラー
                          return;
                        }

                        await accountDomain.createAccount(_formKey.currentState!.value);
                        await accountDomain.handleLogin();
                      }
                    },
                    child: Text('登録'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
