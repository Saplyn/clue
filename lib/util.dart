import 'dart:convert';

import 'package:clue/main.dart';
import 'package:clue/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Icon actionIntoIcon(String? action) {
  switch (action) {
    case '左转':
      return const Icon(Icons.turn_left);
    case '右转':
      return const Icon(Icons.turn_right);
    case '向左前方':
      return const Icon(Icons.turn_slight_left);
    case '向右前方':
      return const Icon(Icons.turn_slight_right);
    case '向左后方':
      return const Icon(Icons.u_turn_left);
    case '向右后方':
      return const Icon(Icons.u_turn_right);
    case '直行':
      return const Icon(Icons.arrow_upward);
    case '靠左':
      return const Icon(Icons.turn_sharp_left);
    case '靠右':
      return const Icon(Icons.turn_sharp_right);
    case '通过人行横道':
      return const Icon(Icons.arrow_circle_up);
    case '通过过街天桥':
      return const Icon(Icons.arrow_circle_up);
    case '通过地下通道':
      return const Icon(Icons.arrow_circle_up);
    case '通过广场':
      return const Icon(Icons.arrow_circle_up);
    case '到道路斜对面':
      return const Icon(Icons.arrow_circle_up);
    default:
      return const Icon(Icons.arrow_upward);
  }
}

class PlanButton extends StatelessWidget {
  const PlanButton({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var locations = appState.locations;
    var key = appState.apiKey;
    var origId = appState.origId;
    var destId = appState.destId;
    var requestInProgress = appState.requestInProgress;

    if (requestInProgress) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton.icon(
      onPressed: () async {
        appState.toggleRequestInProgress();
        var uriStr = "https://restapi.amap.com/v3/direction/walking?"
            "origin=${locations[origId].lat},${locations[origId].lon}&"
            "destination=${locations[destId].lat},${locations[destId].lon}&"
            "key=$key";
        print(uriStr);
        final resp = await http.get(Uri.parse(uriStr));
        print(resp.body.toString());
        var plan = RoutePlan.fromJson(jsonDecode(resp.body));
        appState.setRoutePlan(plan);
        appState.toggleRequestInProgress();
      },
      label: const Text("规划"),
      icon: const Icon(Icons.travel_explore),
    );
  }
}
