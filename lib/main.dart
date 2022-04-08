import 'package:flutter/material.dart';
import 'package:flutter_to_do/db/db_helper.dart';
import 'package:flutter_to_do/services/theme_services.dart';
import 'package:flutter_to_do/ui/home.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
     theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,

      home:  Home(),
    );
  }
}
