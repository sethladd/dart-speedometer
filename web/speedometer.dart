import 'dart:html';
import 'package:speedometer/speedometer.dart';

void main() {
  var canvas = query('#speedometer');
  var speedometer = new Speedometer(canvas);
  speedometer.draw(75.0);
}