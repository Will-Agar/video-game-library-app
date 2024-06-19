import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/color-constants.dart';
import '../models/login-data.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static ColorConstants colorConstants = new ColorConstants();
  LoginData _loginData = new LoginData();
  final _passwordRegex = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}\$');
  final _formKey = GlobalKey<FormState>();
  final _emailValidationBuilder = new ValidationBuilder();
  final _passwordValidationBuilder = new ValidationBuilder();
  var _isHidden = true;
  var _displayLoginErrorMessage = false;
  var _displayAgeErrorMessage = false;
  var _state = 'login';
  String yearDropdownValue = new DateTime.now().year.toString();
  static final now = DateTime.now();

  final dropdownDatePicker = DropdownDatePicker(
    firstDate: ValidDate(year: now.year - 100, month: 1, day: 1),
    lastDate: ValidDate(year: now.year, month: now.month, day: now.day),
    textStyle: TextStyle(fontWeight: FontWeight.bold, color: colorConstants.primary),
    dropdownColor: colorConstants.secondary,
    dateHint: DateHint(year: 'year', month: 'month', day: 'day'),
    ascending: false,
    underLine: Container(
      height: 2,
      color: colorConstants.primary,
    ),
  );

  final OutlineInputBorder standardBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(color: colorConstants.primary, width: 2)
  );
  final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(color: colorConstants.error, width: 2)
  );
  final TextStyle inputTextStyle = TextStyle(
      color: colorConstants.primary,
      fontWeight: FontWeight.w500,
      fontSize: 20
  );
  final TextStyle inputHintTextStyle = TextStyle(
    color: colorConstants.primary,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  void toggleState(){
    setState(() {
      _state = (_state == 'login') ? 'signup' : 'login';
      _formKey.currentState.reset();
    });
  }

  void navigate(String route){
    Navigator.pushReplacementNamed(context, route);
  }

  void toggleHidden(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void submit() async{
    _formKey.currentState.save();

    var dateError = dropdownDatePicker.year != null && dropdownDatePicker.month != null && dropdownDatePicker.day != null;

    if(!dateError && _state == 'signup'){
      setState(() {
        this._displayAgeErrorMessage = true;
      });

      return;
    }

    else if(this._displayAgeErrorMessage && dateError){
      setState(() {
        this._displayAgeErrorMessage = false;
      });
    }

    if(_formKey.currentState.validate()){
      var route = _state=='login'? 'login':'sign-up';
      var email = _loginData.email.trim();

      var response = await http.post(
        "https://the-video-game-library.herokuapp.com/auth/${route}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email":email,
          "password":_loginData.password,
          "age": <String, dynamic>{
            "year": dropdownDatePicker.year,
            "month": dropdownDatePicker.month,
            "day": dropdownDatePicker.day
          }
        }),
      );

      if(response.statusCode == 200){
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        var authToken = jsonResponse['data']['authToken'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("authToken", authToken);
        Navigator.pushReplacementNamed(context, '/app');
      }

      else{
        setState(() {
          this._displayLoginErrorMessage = true;
        });
      }
    }
  }

  String confirmPasswords(value){
      if (value != _loginData.password) {
        return 'Passwords must match';
      }
      return null;
  }

  @override
  Widget build(BuildContext context) {
    var formPadding = (_state == 'login')? 60.0 : 40.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorConstants.secondary,
      body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        'lib/assets/logo4.png',
                        height: 100,
                        width: 200,
                        fit: BoxFit.fitWidth,
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                      child: Text(
                        (_state == 'login') ? 'Login' : 'Sign Up',
                        style: TextStyle(
                            color: colorConstants.tertiary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3.0
                        ),
                      )
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(30.0, formPadding, 20.0, 0),
                                child: TextFormField(
                                  cursorColor: colorConstants.primary,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: inputHintTextStyle,
                                      errorMaxLines: 2,
                                      enabledBorder: standardBorder,
                                      focusedBorder: standardBorder,
                                      errorBorder: errorBorder,
                                      focusedErrorBorder: errorBorder
                                  ),
                                  style: inputTextStyle,
                                  validator: _emailValidationBuilder.email("Please enter a valid email and make sure there are no trailing spaces").maxLength(30).build(),
                                  onSaved: (String value) {
                                    this._loginData.email = value;
                                  },
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                                child: TextFormField(
                                  obscureText: _isHidden,
                                  cursorColor: colorConstants.primary,
                                  decoration: InputDecoration(
                                      suffix: Padding(
                                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                                          child: InkWell(
                                              onTap: toggleHidden,
                                              child: Icon(
                                                  _isHidden? Icons.visibility : Icons.visibility_off,
                                                  color: colorConstants.primary
                                              )
                                          )
                                      ),
                                      hintText: "Password",
                                      hintStyle: inputHintTextStyle,
                                      errorMaxLines: 2,
                                      enabledBorder: standardBorder,
                                      focusedBorder: standardBorder,
                                      errorBorder: errorBorder,
                                      focusedErrorBorder: errorBorder
                                  ),
                                  style: inputTextStyle,
                                  validator: _passwordValidationBuilder.regExp(_passwordRegex, "Please enter a minimum 8 letter password containing an uppercase, lowercase and a numeric character").build(),
                                  onSaved: (String value) {
                                    this._loginData.password = value;
                                  },
                                )
                            ),
                            _state == 'signup' ?
                            Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                                child: TextFormField(
                                    obscureText: _isHidden,
                                    cursorColor: colorConstants.primary,
                                    decoration: InputDecoration(
                                        suffix: Padding(
                                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                                            child: InkWell(
                                                onTap: toggleHidden,
                                                child: Icon(
                                                    _isHidden? Icons.visibility : Icons.visibility_off,
                                                    color: colorConstants.primary
                                                )
                                            )
                                        ),
                                        hintText: "Confirm Password",
                                        hintStyle: inputHintTextStyle,
                                        errorMaxLines: 2,
                                        enabledBorder: standardBorder,
                                        focusedBorder: standardBorder,
                                        errorBorder: errorBorder,
                                        focusedErrorBorder: errorBorder
                                    ),
                                    style: inputTextStyle,
                                    validator: confirmPasswords
                                )
                            )
                                :
                            Container(),
                            _state == 'signup' ?
                            Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Age', style: inputHintTextStyle),
                                        Container(
                                          width: 200,
                                          child: dropdownDatePicker,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        this._displayAgeErrorMessage ?
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            'Please select a date',
                                            style: TextStyle(color: colorConstants.error),
                                          ),
                                        )
                                        :
                                        Container()
                                      ],
                                    )
                                  ],
                                )
                            )
                            :
                            Container(),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                                child: MaterialButton(
                                  height: 50.0,
                                  minWidth: 200.0,
                                  color: colorConstants.primary,
                                  textColor: colorConstants.secondary,
                                  child: Text(
                                    (_state == 'login') ? 'Login' : 'Sign Up',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                  ),
                                  onPressed: submit,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                )
                            ),
                            this._displayLoginErrorMessage ?
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                'Invalid username or password',
                                style: TextStyle(color: colorConstants.error),
                              ),
                            )
                            :
                            Container()
                          ]
                      )
                  ),
                  GestureDetector(
                    onTap: toggleState,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                      child: Text(
                        (_state == 'login') ? 'Sign Up' : 'Login',
                        style: TextStyle(color: colorConstants.primary, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => navigate('/app'),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                      child: Text(
                        'Continue without signing in',
                        style: TextStyle(color: colorConstants.primary, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}