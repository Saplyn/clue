import 'package:clue/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var pageId = appState.pageId;

    return BottomNavigationBar(
      currentIndex: pageId,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "规划路径",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.route),
          label: "路线",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "地图",
        ),
      ],
      onTap: (id) {
        appState.setPageId(id);
        print(appState.pageId);
      },
    );
  }
}
