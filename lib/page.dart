import 'package:clue/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var locations = appState.locations;
    var origId = appState.origId;
    var destId = appState.destId;
    var key = appState.apiKey;

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
            TextField(
              decoration: const InputDecoration(
                labelText: "API Key",
              ),
              onChanged: (val) {
                appState.setApiKey(val);
                print("API Key: $val");
              },
            ),
            DropdownButton(
              value: origId,
              items: dropdownItems,
              onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                appState.setOrigId(val!);
                print("orig: ${locations[val].name}");
              },
            ),
            DropdownButton(
              value: destId,
              items: dropdownItems,
              onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                appState.setDestId(val!);
                print("dest: ${locations[val].name}");
              },
            ),
            ElevatedButton.icon(
              onPressed: () async {
                var uriStr = "https://restapi.amap.com/v3/direction/walking?"
                    "origin=${locations[origId].lat},${locations[origId].lon}&"
                    "destination=${locations[destId].lat},${locations[destId].lon}&"
                    "key=$key";
                print(uriStr);
                final resp = await http.get(Uri.parse(uriStr));
                print(resp.body.toString());
              },
              label: const Text("规划"),
              icon: const Icon(Icons.travel_explore),
            )
          ],
        );
      }),
    );
  }
}
