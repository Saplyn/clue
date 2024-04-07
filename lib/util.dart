import 'dart:convert';

import 'package:clue/main.dart';
import 'package:clue/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

IconData actionIntoIcon(String? action) {
  switch (action) {
    case '左转':
      return Icons.turn_left;
    case '右转':
      return Icons.turn_right;
    case '向左前方':
      return Icons.turn_slight_left;
    case '向右前方':
      return Icons.turn_slight_right;
    case '向左后方':
      return Icons.u_turn_left;
    case '向右后方':
      return Icons.u_turn_right;
    case '直行':
      return Icons.arrow_upward;
    case '靠左':
      return Icons.turn_sharp_left;
    case '靠右':
      return Icons.turn_sharp_right;
    case '通过人行横道':
      return Icons.arrow_circle_up;
    case '通过过街天桥':
      return Icons.arrow_circle_up;
    case '通过地下通道':
      return Icons.arrow_circle_up;
    case '通过广场':
      return Icons.arrow_circle_up;
    case '到道路斜对面':
      return Icons.arrow_circle_up;
    default:
      return Icons.arrow_upward;
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

    var planButton = ElevatedButton.icon(
      onPressed: () async {
        appState.toggleRequestInProgress();
        var uriStr = "https://restapi.amap.com/v3/direction/walking?"
            "origin=${locations[origId].lat},${locations[origId].lon}&"
            "destination=${locations[destId].lat},${locations[destId].lon}&"
            "key=$key";
        final resp = await http.get(Uri.parse(uriStr));
        var plan = RoutePlan.fromJson(jsonDecode(resp.body));
        appState.setRoutePlan(plan);
        appState.toggleRequestInProgress();
      },
      label: const Text("规划"),
      icon: const Icon(Icons.travel_explore),
    );

    if (appState.routePlan == null || !appState.routePlan!.status) {
      return planButton;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        planButton,
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => appState.setPageId(1),
          icon: const Icon(Icons.arrow_back),
          label: const Text("路线"),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => appState.setPageId(2),
          icon: const Icon(Icons.arrow_back),
          label: const Text("地图"),
        )
      ],
    );
  }
}
