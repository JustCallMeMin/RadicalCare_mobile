import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class Global {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
