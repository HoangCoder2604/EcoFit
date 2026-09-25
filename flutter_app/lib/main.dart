import 'package:flutter/widgets.dart';

import 'app/eco_fit_app.dart';
export 'app/eco_fit_app.dart' show EcoFitApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcoFitApp());
}
