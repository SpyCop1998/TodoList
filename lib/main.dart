import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/splashProvider.dart';
import 'package:todo_app/providers/todoProvider.dart';
import 'package:todo_app/screens/homeScreen.dart';

// import 'package:todo_app/screens/loginScreen.dart';
import 'package:todo_app/screens/splashScreen.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'providers/authProvider.dart';
// import './testView/homeScreen.dart';

void main() async {
  //for testing
  // runApp(MaterialApp(home: LoginScreen()));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
      ],
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final email = auth.email;
    return Scaffold(
      body: Center(
          child: email == null
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/peakpx.jpg",
                        ),
                        fit: BoxFit.cover,
                        opacity: 1),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    // crossAxisAlignment: ,
                    children: [
                      // SizedBox(height: MediaQuery.of(context).size.width/4,),
                      // Text("Welcome",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: RoundedButton(
                          buttonText: 'Continue with Google',
                          onPressed: () => {auth.signInWithGoogle()},
                        ),
                      )
                    ],
                  ),
                )
              : HomeSceen()),
    );
  }
}
