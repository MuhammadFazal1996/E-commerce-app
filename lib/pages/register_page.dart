import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _isSubmitting = false, _obscureText = true;

  String _username, _password, _email;

  Widget _showTitle() {
    return Text(
      'Register',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) => val.length < 6 ? 'Username too short' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter username, min length 6',
                icon: Icon(
                  Icons.face,
                  color: Colors.grey,
                ))));
  }

  _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val,
            validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter a valid email',
                icon: Icon(
                  Icons.mail,
                  color: Colors.grey,
                ))));
  }

  _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _password = val,
            validator: (val) => val.length < 6 ? 'Password is short' : null,
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                ),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter password, min length 6',
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ))));
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              : RaisedButton(
                  child: Text(
                    'Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.black),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: _submit,
                ),
          FlatButton(
            child: Text('Existing user? Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post(
        'http://192.168.1.108:1337/auth/local/register',
        body: {"username": _username, "email": _email, "password": _password});

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() {
        _isSubmitting = false;
      });
      final String errorMsg =
          responseData['message'][0]['messages'][0]['message'].toString();
      print('---$errorMsg');
      _showErrorSnack(errorMsg);
    }
  }

  void _showSuccessSnack() {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey,
      content: Text(
        'User $_username successfully created!',
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.grey,
      content: Text(
        errorMsg,
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    throw Exception('Error registering: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/products');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _showTitle(),
                        _showUsernameInput(),
                        _showEmailInput(),
                        _showPasswordInput(),
                        _showFormActions(),
                      ],
                    )))),
      ),
    );
  }
}
