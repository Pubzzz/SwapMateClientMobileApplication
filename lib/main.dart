import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swap_mate_mobile/db/authentication.dart';
import 'package:swap_mate_mobile/ui/root_page/swap_mate_app_view.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  final user = await Authentication().getLoggedUser();

  runApp(SwapMateAppView(user?.email));

}

