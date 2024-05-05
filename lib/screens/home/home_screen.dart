import 'package:change/screens/message_list_screen.dart';
import 'package:change/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final menuIndex = useState(0);

  final _widgetOptions = <Widget>[
    MessageListScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _widgetOptions.elementAt(menuIndex.value),
      floatingActionButton: menuIndex.value == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/message/send');
        },
        child: const Icon(Icons.send),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: menuIndex.value,
        onTap: (index) {
          menuIndex.value = index;
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: '一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
