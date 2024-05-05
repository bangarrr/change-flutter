import 'package:change/firebase_options.dart';
import 'package:change/providers/shared_preferences_provider.dart';
import 'package:change/providers/user_auth_provider.dart';
import 'package:change/screens/home/home_screen.dart';
import 'package:change/screens/initialize_screen.dart';
import 'package:change/screens/login_screen.dart';
import 'package:change/screens/message_list_screen.dart';
import 'package:change/screens/message_send_screen.dart';
import 'package:change/screens/setting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [
        localDbProvider.overrideWithValue(
          LocalDbUtility(prefs: await SharedPreferences.getInstance()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RootPage(),
      routes: <String, WidgetBuilder>{
        '/initialize': (context) => InitializeScreen(),
        '/messages/list': (context) => MessageListScreen(),
        '/message/send': (context) => MessageSendScreen(),
        '/setting': (context) => SettingScreen(),
      },
    );
  }
}

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthState = ref.watch(userAuthProvider);

    return userAuthState.when(
      data: (user) {
        if (user != null) return HomeScreen();
        return LoginScreen();
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
