import 'package:clue/model.dart';
import 'package:clue/navbar.dart';
import 'package:clue/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Clue',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const PageContainer(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  //~ Configuration

  String apiKey = '';

  void setApiKey(String value) {
    apiKey = value;
    notifyListeners();
  }

  //~ Campus Navigator Data

  final locations = <LynLocation>[
    LynLocation("南门", 122.060376, 37.526559),
    LynLocation("东门", 122.065147, 37.530236),
    LynLocation("西南门", 122.056318, 37.527422),
    LynLocation("机电与信息工程学院", 122.061757, 37.527422),
    LynLocation("海洋学院", 122.061079, 37.528721),
    LynLocation("商学院（学院楼）", 122.06105, 37.529606),
    LynLocation("艺术学院", 122.062937, 37.53031),
    LynLocation("科学实验楼", 122.062424, 37.530791),
    LynLocation("翻译学院", 122.062916, 37.532309),
    LynLocation("文化传播学院（文学楼）", 122.062432, 37.532637),
    LynLocation("图书馆西翼", 122.059707, 37.531414),
    LynLocation("空间科学与物理学院", 122.056745, 37.535071),
    LynLocation("网络楼", 122.060895, 37.532564),
    LynLocation("澳国立联合理学院", 122.059558, 37.532598),
    LynLocation("北衡楼、东序楼、含光楼、南辰楼群", 122.063211, 37.528432),
    LynLocation("体育馆", 122.056492, 37.532647),
    LynLocation("田径场", 122.057898, 37.533295),
    LynLocation("馨园篮球场", 122.058336, 37.528943),
    LynLocation("风雨操场", 122.063138, 37.532773),
    LynLocation("学院楼东足、网球场", 122.06292, 37.529207),
    LynLocation("荟园餐厅", 122.057186, 37.529167),
    LynLocation("馨园餐厅", 122.057812, 37.529273),
    LynLocation("泰园餐厅", 122.055869, 37.529611),
    LynLocation("雀园餐厅", 122.057606, 37.53124),
    LynLocation("学生公寓 4~6 集群", 122.056067, 37.530624),
    LynLocation("学生公寓 7~9 集群", 122.057236, 37.529855),
    LynLocation("学生公寓 10 号楼", 122.056829, 37.531484),
    LynLocation("学生公寓 11~18 集群", 122.055863, 37.528482),
    LynLocation("学生公寓 19~22 集群", 122.057432, 37.528229),
    LynLocation("学生公寓 23 号楼", 122.057048, 37.528527),
    LynLocation("学生公寓 24 号楼", 122.056579, 37.53182),
    LynLocation("快递站", 122.054772, 37.527538),
    LynLocation("校医院", 122.064984, 37.529962),
  ];
  bool curAsOrig = false;
  int origId = 0;
  int destId = 0;
  RoutePlan? routePlan;

  void toggleCurAsOrig() {
    curAsOrig = !curAsOrig;
    notifyListeners();
  }

  void setDestId(int value) {
    destId = value;
    notifyListeners();
  }

  void setOrigId(int value) {
    origId = value;
    notifyListeners();
  }

  void setRoutePlan(RoutePlan value) {
    routePlan = value;
    notifyListeners();
  }

  //~ Internal State

  int pageId = 0;
  bool requestInProgress = false;

  void setPageId(int value) {
    pageId = value;
    notifyListeners();
  }

  void toggleRequestInProgress() {
    requestInProgress = !requestInProgress;
    notifyListeners();
  }
}

class PageContainer extends StatelessWidget {
  const PageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    Widget page = const Placeholder();

    switch (context.watch<AppState>().pageId) {
      case 0:
        page = const PlanPage();
        break;
      case 1:
        page = const InstructionPage();
        break;
      case 2:
        page = const MapPage();
        break;
    }

    Widget mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: page,
      ),
    );
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              SafeArea(child: SideNavBar(constraints.maxWidth)),
              Expanded(child: mainArea),
            ],
          );
        }
        return Column(
          children: [
            Expanded(child: mainArea),
            const SafeArea(child: BottomNavBar()),
          ],
        );
      }),
    );
  }
}
