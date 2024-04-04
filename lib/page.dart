import 'package:clue/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var locations = appState.locations;
    var origId = appState.origId;
    var destId = appState.destId;

    List<DropdownMenuItem<int>> dropdownItems = [];
    for (var (id, loc) in locations.indexed) {
      dropdownItems.add(DropdownMenuItem(
        value: id,
        child: Text(loc.name),
      ));
    }

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        return Column(
          children: [
            DropdownButton(
                value: origId,
                items: dropdownItems,
                onChanged: (val) {
                  appState.setOrigId(val!);
                  print("orig: ${locations[val].name}");
                }),
            DropdownButton(
                value: destId,
                items: dropdownItems,
                onChanged: (val) {
                  appState.setDestId(val!);
                  print("dest: ${locations[val].name}");
                }),
          ],
        );
      }),
    );
  }
}
