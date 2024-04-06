// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:clue/main.dart';
import 'package:clue/util.dart';
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
              PlanButton(),
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
      return Scaffold(
        body: ListView.builder(
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
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            appState.setPageId(0);
          },
          icon: Icon(Icons.arrow_back),
          label: Text("请先规划路径"),
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.routePlan == null || !appState.routePlan!.status) {
      return Scaffold(
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              appState.setPageId(0);
            },
            icon: Icon(Icons.arrow_back),
            label: Text("请先规划路径"),
          ),
        ),
      );
    }

    String? polyline;
    for (var step in appState.routePlan!.route!.paths[0].steps) {
      if (polyline == null) {
        polyline = step.polyline;
      } else {
        polyline += ';${step.polyline}';
      }
    }

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        int width = min(constraints.maxWidth.toInt(), 1024);
        int height = min(constraints.maxHeight.toInt(), 1024);
        String orig = appState.routePlan!.route!.origin;
        String dest = appState.routePlan!.route!.destination;

        String url = 'https://restapi.amap.com/v3/staticmap?'
            'size=$width*$height&'
            'paths=3,0xffa500,1,,:$polyline&'
            'markers=mid,0xFFFFFF,起:$orig|mid,0xFFFFFF,终:$dest&'
            'key=b0782224d5e9af4baa9f35244dcbd8aa';
        return Center(
          child: Image.network(url),
        );
      }),
    );
  }
}
