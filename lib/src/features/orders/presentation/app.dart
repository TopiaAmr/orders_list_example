import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders_list_example/src/features/orders/presentation/bloc/orders_bloc.dart';
import '../../../core/config/app_config.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(
          create: (_) => sl<OrdersBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
