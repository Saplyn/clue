import 'package:flutter/material.dart';

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
