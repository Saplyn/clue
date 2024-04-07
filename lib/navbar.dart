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
      },
    );
  }
}

class SideNavBar extends StatelessWidget {
  final double width;
  const SideNavBar(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var pageId = appState.pageId;

    return NavigationRail(
      extended: width >= 800,
      selectedIndex: pageId,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.explore),
          label: Text("规划路径"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.route),
          label: Text("路线"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.map),
          label: Text("地图"),
        ),
      ],
      onDestinationSelected: (id) {
        appState.setPageId(id);
      },
    );
  }
}
