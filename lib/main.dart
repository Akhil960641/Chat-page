import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample01/Homepage.dart';
import 'package:sample01/contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ThirdPage();
              } else {
                return HomePage();
              }
            }));
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<String> Chat = [];
  TextEditingController msg = TextEditingController();

String? email;

  Future<String?> shrf() async{
    SharedPreferences shref=await SharedPreferences.getInstance();
   email= shref.getString('email');
   return email;
  }

  auth() {
    FirebaseAuth.instance.signOut();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Rebeeh',style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),

          child: CircleAvatar(
            child: Icon(Icons.person),
          ),

        ),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
              onPressed: () {
                auth();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: shrf(),
        builder: (context,snap) {
          if (!snap.hasData) {
            return Text('no email');
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white38),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('col')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var temp3 = snapshot.data!.docs;
                              temp3.sort((b, a) =>
                              //    a.data()['count'].compareTo(b.data()['count']));
                              DateTime.parse(a.data()['Time']).compareTo(
                                  DateTime.parse(b.data()['Time'])));
                              //  lastMessageCount= snapshot.data!.docs.last.data()['count'];


                              print('${snapshot.data!.docs}');
                              //  var temp = snapshot.data!.docs;
                              return ListView.separated(
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    var temp = snapshot.data!.docs;
                                    String? user =
                                    temp3[index].data()['username'];
                                    return Row(
                                      mainAxisAlignment: user == email
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ${temp3[index].data()['message']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              backgroundColor: Colors.grey,
                                              color: Colors.black,
                                              fontSize: 19),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 6,
                                    );
                                  },
                                  itemCount: snapshot.data!.docs.length);
                            } else {
                              return Text('null error');
                            }
                          })),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: msg,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'message',
                              prefixIcon: Icon(Icons.message),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection('col')
                                        .add({
                                      'username':email,

                                      'message': msg.text,
                                      'Time': DateTime.now().toString()
                                    });

                                    setState(() {
                                      Chat.add(msg.text);

                                      msg.text = '';
                                    });
                                    print(Chat);
                                  },
                                  icon: Icon(Icons.send))),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        }
      ),
    );
  }
}
