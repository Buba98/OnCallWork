import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/bloc/chat_bloc.dart';
import 'package:on_call_work/home_route/button_chat.dart';
import 'package:on_call_work/home_route/search/search_screen.dart';
import 'package:on_call_work/home_route/add/add_screen.dart';
import 'package:on_call_work/home_route/settings/settings_screen.dart';

import 'bloc/job_bloc.dart';
import 'modify/modify_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SearchScreen(),
    AddScreen(),
    ModifyScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload(context));
    super.initState();
  }

  void _reload(BuildContext context) {
    context.read<JobBloc>().add(JobReloadEvent());
    context.read<ChatBloc>().add(ChatReloadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode),
            label: 'Modify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _reload(context);
        },
        child: _screens[_currentIndex],
      ),
      appBar: AppBar(
        actions: const [
          ButtonChat(),
        ],
      ),
    );
  }
}
