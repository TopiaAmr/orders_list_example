import 'package:flutter/material.dart';
import 'src/core/di/injection_container.dart' as di;
import 'src/features/orders/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}