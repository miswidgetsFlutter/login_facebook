import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn=false;


  void initiateFacebookLogin() async{
    var login = FacebookLogin();
    var result= await login.logIn(['email']);
    
    switch(result.status){
      case FacebookLoginStatus.error:
        print('hubo un error');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelado por el usuario');
        break;
      case FacebookLoginStatus.loggedIn:
        onLoginStatusChange(true);
        //getUserInfo(result);
        break;
    }
  }
  
  void getUserInfo(FacebookLoginResult result) async{
    final token = result.accessToken.token;
    final graphResponse = await http.get(
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);

    print(profile['email']);
  }

  void onLoginStatusChange(bool isLoggedIn){
    setState(() {
      this.isLoggedIn=isLoggedIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: isLoggedIn?Text('bienvenido')
            :RaisedButton(child: Text('iniciar sesion con facebook'),onPressed: ()=>initiateFacebookLogin(),),
        ),
      ),
    );
  }
}



