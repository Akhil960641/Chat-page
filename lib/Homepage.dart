import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample01/contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  bool flag = true;

  auth({required email, required password}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: (password));
  }

  authLogin({required email, required password}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: (password));
  }

Future<UserCredential>  signWithgoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    Constants.email = googleuser?.email;
   // SharedPreferences shref = await SharedPreferences.getInstance();
    //shref.setString('user', googleuser!.email);
    print('>>>>>>>${googleuser?.email}');
    GoogleSignInAuthentication? googleAuth = await googleuser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCred= await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCred.user!.email);
    final spref=await SharedPreferences.getInstance();
    spref.setString('email', userCred.user!.email??'qwert');

    return userCred;
  }

  signWithfacebook() async {}

  @override
  Widget build(BuildContext context) {
    if (flag == true) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Container(
                  child: Text('LOGIN',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.grey,
                          debugLabel: "login")),
                  color: Colors.white),
              SizedBox(
                height: 123,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextField(
                    controller: Email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 95)),
                        hintText: 'Email'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextField(
                    controller: Password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'password'),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    authLogin(email: Email.text, password: Password.text);
                  },
                  child: Text('Click')),
              SizedBox(
                height: 18,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("don't have account"),
                  InkWell(
                      onTap: () {
                        setState(() {
                          flag = false;
                        });
                      },
                      child: Text(
                        ' Sign up',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Container(
                  child: Text('SIGN UP',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.grey,
                          debugLabel: "login")),
                  color: Colors.white),
              SizedBox(
                height: 103,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextField(
                    controller: Email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 95)),
                        hintText: 'Email'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextField(
                    controller: Password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'password'),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    auth(email: Email.text, password: Password.text);
                  },
                  child: Text('Click')),
              SizedBox(
                height: 19,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("already a user...!"),
                  InkWell(
                      onTap: () {
                        setState(() {
                          flag = true;
                        });
                      },
                      child: Text(
                        '  login',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async{
                        UserCredential userCredential= await signWithgoogle();


                      },
                      child: CircleAvatar(
                        radius: 29,
                        foregroundImage:
                            AssetImage('asset/icons8-google-48.png'),
                        backgroundColor: Colors.transparent,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 30,
                      foregroundImage:
                          AssetImage('asset/icons8-facebook-48.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
