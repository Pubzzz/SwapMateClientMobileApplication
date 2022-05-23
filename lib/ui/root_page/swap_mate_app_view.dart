import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap_mate_mobile/ui/root_page/root_cubit.dart';
import 'package:swap_mate_mobile/ui/root_page/root_view.dart';

import '../../util/routes.dart';

class SwapMateAppView extends StatelessWidget {
  final String? email;

  SwapMateAppView(
    this.email,
  );

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SwapMate",
      // theme: PrimaryTheme.generateTheme(context),
      home: RootView(
        email: email,
      ),
      onGenerateRoute: Routes.generator,
    );

    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<RootCubit>(create: (context) => RootCubit(context)),
      ],
      child: materialApp,
    );
  }
}
