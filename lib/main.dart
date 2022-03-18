
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
                return const Text('Done');
              default:
                return const Text('Loading...');
            }
          },
        ),
    );
  }
}