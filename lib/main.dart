import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Password Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Random random = Random();
  //invoking random class here so that I don't have to invoke it in every function, it generates random obj,
  int _maxlength = 8;
  // this is the default length of the password,
  ValueNotifier<int> _passlength = ValueNotifier<int>(8);
  //this responds to change in value of the variable without having to invoke ``setstate()``
  ValueNotifier<int> _charlength = ValueNotifier<int>(0);
  //this responds to change in value of the variable without having to invoke ``setstate()``
  var _select = "";
  //this is the actual password, it is an empty string
  int _charlimit = 6;
  //this is the default character limit, assuming people usually choose passwords that have mostly characters

  String genChar(int _c) {
    String passC = "";
    //this is the final string that will be passed to _genPass()
    String someChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    //this is the character pool so to say, the random character is chosen from this string only
    int genc;
    for (int i = 0; i < _c; i++) {
      genc = random.nextInt(someChars.length);
      passC += someChars[genc];
    }
    return passC;
  }

  String genNumber(int _n) {
    String passN = "";
    //this is the final string that will be passed to _genPass()
    String someNos = '1234567890';
    //this is the number pool so to say, the random number is chosen from this string only
    int genN;
    for (int i = 0; i < _n; i++) {
      genN = random.nextInt(someNos.length);
      passN += someNos[genN];
    }
    return passN;
  }

  String genSym(int _s) {
    String passS = "";
    //this is the final string that will be passed to _genPass()
    String someSym = '!@#%^&*()_-+={}[]:";<>?,/.| \'';
    //this is the character pool so to say, the random character is chosen from this string only
    int genS;
    for (int i = 0; i < _s; i++) {
      genS = random.nextInt(someSym.length);
      passS += someSym[genS];
    }
    return passS;
  }

  void _genpass() {
    setState(() {
      int i = 0;
      _select = "";
      int position = 0;
      var passlength = new List(_maxlength);
      String passC = genChar(_charlimit);
      String passN = genNumber(random.nextInt(_maxlength - _charlimit));
      String passS = genSym(_maxlength - _charlimit - passN.length);
      bool found = false;
      String storedchar = passC + passN + passS;

      while (i < _maxlength) {
        position = random.nextInt(_maxlength);
        for (int j = 0; j < i; j++)
          if (position != passlength[i])
            found = false;
          else {
            found = true;
            break;
          }
        if (found) {
          position = random.nextInt(_maxlength);
          continue;
        } else
          passlength[i] = position;
        i++;
      }
      print(_maxlength.toString() +
          " " +
          passC +
          " " +
          passN +
          " " +
          passS +
          " " +
          storedchar +
          " " +
          passlength.toString());
      for (i = 0; i < _maxlength; i++) {
        int j = passlength[i];
        _select += storedchar[j];
      }
      print(_select);
    });
  }

  // void _genpass() {
  //   setState(() {
  //     _select = "";
  //     int i = 00;
  //     String pass = "";
  //     int _noOfChar = 0;
  //     while (i < _maxlength) {
  //       int selector = random.nextInt(4);
  //       switch (selector) {
  //         case 1:
  //           pass += genChar();
  //           _noOfChar++;
  //           break;
  //         case 2:
  //           pass += genNumber();
  //           break;
  //         case 3:
  //           pass += genSym();
  //           break;
  //       }

  //       _select += pass;
  //       pass = "";
  //       i++;
  //     }
  //     if (_select.length != _maxlength || _noOfChar != _charlimit) _genpass();
  //     print(_select.length);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _select,
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
              child: Text('Clear'),
              onPressed: () {
                setState(() {
                  _select = "";
                });
              },
            ),
            Slider(
              label: _maxlength.toString(),
              value: _maxlength.toDouble(),
              min: 8,
              max: 16,
              divisions: 8,
              onChanged: (double newvalue) {
                setState(() {
                  print(newvalue.toInt());
                  _maxlength = newvalue.toInt();
                  _passlength.value = _maxlength;
                });
              },
            ),
            ValueListenableBuilder(
              valueListenable: _passlength,
              builder: (BuildContext context, int _maxlength, Widget child) {
                return Text(
                  ' Length of Password : $_maxlength',
                  style: Theme.of(context).textTheme.body1,
                );
              },
            ),
            Slider(
              label: _charlimit.toString(),
              value: _charlimit.toDouble(),
              min: 1,
              max: _maxlength.toDouble() - 1,
              divisions: 8,
              onChanged: (double _newvalue) {
                setState(() {
                  print(_newvalue.toInt());
                  _charlimit = _newvalue.toInt();
                  _charlength.value = _newvalue.toInt();
                });
              },
            ),
            ValueListenableBuilder(
              valueListenable: _charlength,
              builder: (BuildContext context, int _maxlength, Widget child) {
                return Text(
                  'No of characters in the password : $_maxlength',
                  style: Theme.of(context).textTheme.body1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _genpass,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
