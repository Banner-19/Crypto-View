import 'dart:convert';

import 'package:cypto/models/appConfig.dart';
import 'package:cypto/pages/homePage.dart';
import 'package:cypto/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  runApp(const MyApp());
}

Future<void> loadConfig() async{
  String _configContent=await  rootBundle.loadString("assets/config/main.json");
  Map _configData=jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"],)
  );
}


void registerHTTPService(){
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'ArchitectsDaughter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor:const Color.fromRGBO(101, 183, 65, 1.0),
      ),
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}

