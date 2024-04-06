// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:clue/main.dart';
import 'package:clue/model.dart';
import 'package:clue/util.dart';
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: key,
                  decoration: const InputDecoration(
                    labelText: "API Key",
                  ),
                  onChanged: (val) {
                    appState.setApiKey(val);
                    print("API Key: $val");
                  },
                ),
              ),
              const Divider(
                height: 40,
              ),
              SizedBox(
                width: 300,
                child: Text(
                  "起点",
                  textAlign: TextAlign.left,
                ),
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
              SizedBox(
                width: 300,
                child: Text("终点"),
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
              const SizedBox(
                height: 20,
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
                  var plan = RoutePlan.fromJson(jsonDecode(resp.body));
                  // print everything
                  print(plan.status);
                  print(plan.info);
                  print(plan.infocode);
                  print(plan.count);
                  print(plan.route?.origin);
                  print(plan.route?.destination);
                  print(plan.route?.paths[0].distance);
                  print(plan.route?.paths[0].duration);
                  print(plan.route?.paths[0].steps[0].instruction);

                  appState.setRoutePlan(plan);
                },
                label: const Text("规划"),
                icon: const Icon(Icons.travel_explore),
              )
            ],
          ),
        );
      }),
    );
  }
}

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var path = appState.routePlan?.route?.paths[0];

    if (path != null) {
      return ListView.builder(
        itemCount: path.steps.length,
        itemBuilder: (context, index) {
          var step = path.steps[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.instruction,
                            textAlign: TextAlign.left,
                          ),
                          Text('${step.road == null ? '' : '${step.road!}：'}'
                              '向${step.orientation}'
                              '步行约 ${step.distance} 米，'
                              '约 ${(step.duration / 60).toStringAsFixed(1)} 分钟'),
                        ],
                      ),
                      actionIntoIcon(step.action),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const Center(
      child: Text("请先规划路径"),
    );
  }
}
