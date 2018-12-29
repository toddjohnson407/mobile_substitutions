import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:vibrate/vibrate.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

//import 'dart:async';

//import 'package:flutter_launcher_icons/android.dart';
//import 'package:flutter_launcher_icons/constants.dart';
//import 'package:flutter_launcher_icons/custom_exceptions.dart';
//import 'package:flutter_launcher_icons/ios.dart';
//import 'package:flutter_launcher_icons/main.dart';
//import 'package:flutter_launcher_icons/xml_templates.dart';

void main() => runApp(SoccerApp ());

//final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

var userInputs = [];
var playerNames = [];
var playersOut = [];
var inAndOut = [];
var togglePlay = true;

var firstPress = true;
var animationValue = 0;
var pauseDisplay = 0;
var position = 0;
var previousAnimationValue = 0;

IconData iconDisplay  = Icons.play_arrow;

var playerCharts = new List<Widget>();
var playerAmount = int.parse(userInputs[0]);
var totalTime = int.parse(userInputs[1]);
var playersInAmount = int.parse(userInputs[2]);
var substitutionFrequency = int.parse(userInputs[3]);
var stopwatch = new Stopwatch();

// main application widget
class SoccerApp extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
//    _firebaseMessaging.configure();
    return MaterialApp(
        title: 'SUB OUT',
        home: InputFields(),
        routes: <String, WidgetBuilder> {
//        '/playerNames': (BuildContext context) => MyPage(title: 'Player Names')
        }
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  Animation<int> animation;
  var secondCounter = 59.toString();
  var notify = '';
  var subFrequency = int.parse(userInputs[3]);
  var totalMinute = int.parse(userInputs[1]);
  @override

  build(BuildContext context){

    animationValue = animation.value;

    var secondCounterInt = int.parse(secondCounter);
    var timeDisplay = '';
    var minute = (animation.value ~/ 60);

    if (previousAnimationValue != animation.value) {
      if (animation.value % 60 == 0 && minute <= (totalMinute - subFrequency) && minute % subFrequency == 0 && togglePlay != true) {
        print('notification: $notify');
        if (position > (totalMinute / subFrequency) - 2) {
          position = 0;
        }
        notify = inAndOut[position];
        position += 1;
      } else if (minute > (totalMinute - subFrequency)) {
        position = 0;
        notify = '';
      }
    }

    if (animation.value % 60 == 0) {
      timeDisplay = '$minute:00';
    }
    else {
      if (secondCounterInt < 10 && secondCounterInt > 0) {
        secondCounter = '0${(animation.value.toInt() % 60)}';
      } else {
        secondCounter = (animation.value.toInt() % 60).toString();
      }
      timeDisplay = '${(animation.value ~/ 60)}:$secondCounter';
    }

    if (togglePlay == true) {
      secondCounter = (pauseDisplay.toInt() % 60).toString();
      timeDisplay = '${pauseDisplay ~/ 60}:${secondCounter}';
    }

    if (firstPress == true && animation.value == 0) {
      print(animation.value);
      var start = int.parse(userInputs[1]) * 60;
      timeDisplay = '${start ~/ 60}:00';
    }

    previousAnimationValue = animation.value;

    return new Text.rich(
      TextSpan(
        children: <TextSpan>[
          new TextSpan(
            text: timeDisplay + '\n',
            style: new TextStyle(fontSize: 125.0),
          ),
          new TextSpan(
            text: "$notify",
            style: new TextStyle(fontSize: 20)
          )
        ],
      )
    );
  }
}

class StartGame extends StatefulWidget {
  @override
  StartGameState createState() => new StartGameState();
}

class StartGameState extends State<StartGame> with TickerProviderStateMixin {
  @override
  AnimationController _controller;

  var _totalTime = int.parse(userInputs[1]) * 60;

  @override
  void initState() {
    print("hello");
    print(_totalTime);
    firstPress = true;
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      value: _totalTime.toDouble(),
      duration: new Duration(seconds: _totalTime),
    );
  }

  Widget build(BuildContext context) {
    print(animationValue);
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Game Time")
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          togglePlay = togglePlay == true ? false : true;
          setState(() {
            iconDisplay = iconDisplay == Icons.play_arrow ? Icons.pause : Icons.play_arrow; // Change icon and setState to rebuild
          });
          if (firstPress == true) {
            _controller.forward(from: 0);
            firstPress = false;
          } else {
            if (togglePlay == true) {
              print("togglePlay");
              print(animationValue);
              pauseDisplay = animationValue;
              _controller.stop(canceled: true);
            } else {
              _controller.stop(canceled: false);
              _controller.forward(from: 0);
            }
          }
        },
        child: new Icon(iconDisplay),
      ),
      body: new Center(
        child: new Container(
        alignment: Alignment.center,
//          margin: EdgeInsets.only(top: 20.0, left: 25.0),
          child: new Countdown(
            animation: new StepTween(
              begin: _totalTime - animationValue,
              end: 0
            ).animate(_controller),
          )
        ),
      )
    );
  }
}

// creates new state containing game substitution results
class SubstitutionResults extends StatefulWidget {
  @override
  SubstitutionResultsState createState() => new SubstitutionResultsState();
}

// creates time based substitution widgets
class SubstitutionResultsState extends State<SubstitutionResults> {
  @override
//  bool _canVibrate = true;

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Results")
        ),
        body: new Container(
            margin: EdgeInsets.only(top: 20.0),
            child: new ListView(
                children:
                playerCharts
            )
        )
    );
  }
}

// create player names state from user input
class PlayerNames extends StatefulWidget {
  @override
  PlayerNamesState createState() => new PlayerNamesState();
}

// create player names from user input
class PlayerNamesState extends State<PlayerNames> {
  @override
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var localInAndOut = [];

  void submit() {
    playerNames = [];
    _formKey.currentState.save();
    print(playerNames);
  }

  void startNow() {
    animationValue = int.parse(userInputs[1]) * 60;
    print(inAndOut);
    print('starting');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StartGame())
    );
  }

  void calculateResults() {
    playerCharts = [];
    playerAmount = int.parse(userInputs[0]);
    totalTime = int.parse(userInputs[1]);
    playersInAmount = int.parse(userInputs[2]);
    substitutionFrequency = int.parse(userInputs[3]);

    var playersPerSubstitution = playerAmount - playersInAmount;
    var substitutionTotal = totalTime / substitutionFrequency;
    var index = 0;
    var cycleCount = 0;
    var lastPlayer = 0;

    print(playersInAmount);
    print(substitutionTotal);

    for (var i = 0; i < substitutionTotal; i++) {
      var playingArray = [];
      if (index > playerAmount - playersPerSubstitution) {
        print("if");
        index = cycleCount;
        var starts = playerAmount - lastPlayer;
        print(starts);
        for (var q = 0; q < starts; q++) {
          print("first");
          if (q < playersInAmount) {
            playingArray.add(playerNames[lastPlayer + q]);
          }
        }
        print(playingArray.length);
        var enders = playersInAmount - playingArray.length;
        for (var v = 0; v < enders; v++) {
          print("here");
          print(v);
          playingArray.add(playerNames[v]);
        }
      }
      else {
        print(index);
        print("else");
        print(lastPlayer);

        if (lastPlayer > 0 && lastPlayer < playerAmount - playersInAmount) {
          print("DID");
          for (var q = 0; q < playersInAmount; q++) {
            playingArray.add(playerNames[lastPlayer + q]);
          }
//          playingArray.add(playerNames.sublist(lastPlayer, lastPlayer + 3));
        } else if (lastPlayer > playerAmount - playersInAmount) {
          print("OIII");
          for (var q = 0; q < playerAmount - lastPlayer; q++) {
            playingArray.add(playerNames[lastPlayer + q]);
          }
          var enders = playersInAmount - playingArray.length;
          for (var v = 0; v < enders; v++) {
            print("here");
            print(v);
            playingArray.add(playerNames[v]);
          }
//          playingArray.add(playerNames.sublist(lastPlayer, playerAmount));
        } else {
          print("OH");
          for (var q = 0; q < playersInAmount; q++) {
            playingArray.add(playerNames[lastPlayer + q]);
          }
//          playingArray.add(playerNames.sublist(lastPlayer, lastPlayer + 3));
        }

      }

      var playersIn = [];

      for (var p = 0; p < playersPerSubstitution; p++) {
        playersIn.add(playingArray[playingArray.length - 1 - p]);
      }

      var output = <Widget>[];

      output.add(new Container(
          width: 300.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5), top: BorderSide(color: Colors.black, width: 1.5))),
          padding: EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 2.0),
          child: new Text(
              'Time: ${i * substitutionFrequency}:00',
              style: TextStyle(color: Colors.white)
          )
      ));

      if (i > 0) {
        localInAndOut.add('${playersIn.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', ' and')} in for ${playersOut.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', ' and')}');
        output.add(
            new Container(
                width: 300.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5))),
                padding: EdgeInsets.only(left: 35.0, top: 6.0, right: 35.0, bottom: 3.5),
                child:
                Center(
                    child: new Text(
                      '${playersIn.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', ' and')} in for ${playersOut.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', ' and')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                )
            )
        );
      }

      for (var play in playingArray) {
        output.add(new Container(
            width: 300.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 35.0, top: 8.0, right: 35.0, bottom: 8.0),
            child: new Text(
              '$play',
              style: TextStyle(color: Colors.white),
            )
        ));
      }



      playerCharts.add(
          new Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2.0, style: BorderStyle.none)),
              child: Center(
                  child: Card(
                      elevation: 3.0,
                      color: Colors.black,
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: output
                      )
                  )
              )
          )
      );

      playersOut = [];
      print(playingArray);
      print("last");
      var lastName = playingArray[0 + playersPerSubstitution];
      lastPlayer = playerNames.indexOf(lastName);
      print(playingArray.length);
      index = index + playersPerSubstitution;

      for (var p = 0; p < playersPerSubstitution; p++) {
        playersOut.add(playingArray[0 + p]);
      }
    }

    playerCharts.add(
        new Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Center(
                child: new MaterialButton(
                  child: new Text(
                      'Start Game',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.black,
                  onPressed: () {
                    startNow();
                  },
                )
            )
        )
    );

  }

  Widget build(BuildContext context) {
    var playerAmount = int.parse(userInputs[0]);
    var playerWidgets = new List<Widget>();

    for (var i = 0; i < playerAmount; i++) {
      playerWidgets.add(new TextFormField(
          maxLength: 15,
          maxLines: 1,
          decoration: new InputDecoration(
            counterText: '',
            labelText: "Player ${i+1}",
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
            labelStyle: TextStyle(color: Colors.black)
          ),
          onSaved: (String value) {
            playerNames.add(value);
          }),
      );
    }

    playerWidgets.add(new Container(
        margin: EdgeInsets.only(top: 30.0),
        child:
        new MaterialButton(
          child: new Text(
              'Submit',
              style: TextStyle(color: Colors.white)),
          color: Colors.black,
          onPressed: () {
            this.submit();
            calculateResults();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubstitutionResults())
            );
          },
        )
    )
    );
    inAndOut = localInAndOut;
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Names"),
        backgroundColor: Colors.black,
      ),
      body: new Container(
        margin: new EdgeInsets.only(top: 15.0),
        padding: new EdgeInsets.all(50.0),
        child: new Form(
          key: this._formKey,
          child: new ListView(
              children:
              playerWidgets
          ),
        ),
      ),
    );
  }
}

// create input field state
class InputFields extends StatefulWidget {
  @override
  InputFieldsState createState() => new InputFieldsState();
}

// creates field boxes
class InputFieldsState extends State<InputFields> {
  @override
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void submit() {
    userInputs = [];
    _formKey.currentState.save();
    print(userInputs);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayerNames())
    );
    _formKey.currentState.reset();
  }

  final myController = TextEditingController();

  void _pushSaved() {
    _formKey.currentState.reset();
    _formKey.currentState.deactivate();
  }

  Widget build(BuildContext context) {
    var fieldList = { "playerAmount": "Total Amount of Players: ", "gameTime": "Total Time of Game: ", "playersInAmount": "Amount of Players in at a Time: ", "substitutionIncrement": "How Often Substitution Should Occur: " };
    var fieldTitles = fieldList.values;
    var fieldWidgets = new List<Widget>();

    // create input fields
    for (var title in fieldTitles) {
      fieldWidgets.add(new TextFormField(
//          controller: myController,
        maxLength: 3,
        maxLines: 1,
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
          labelStyle: TextStyle(color: Colors.black),
          counterText: '',
          labelText: title
        ),
        onSaved: (String value) {
          userInputs.add(value);
        },
      )
      );
    }

    // create submit button
    fieldWidgets.add(new Container(
        margin: EdgeInsets.only(top: 30.0),
        child:
        new MaterialButton(
          child: new Text(
              'Submit',
              style: TextStyle(color: Colors.white)),
          color: Colors.black,
          onPressed: () {
            this.submit();
          },
        )
    )
    );

//    _firebaseMessaging.requestNotificationPermissions();

    return Scaffold (
        appBar: AppBar (
            title: Text('SUB OUT'),
            backgroundColor: Colors.black,
            actions: <Widget>[      // Add 3 lines from here...
              new IconButton(icon: const Icon(Icons.refresh), onPressed: _pushSaved),
            ]
        ),
        body: new Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: new EdgeInsets.all(50.0),
          child: new Form(
              key: this._formKey,
              child: new ListView(
                children:
                fieldWidgets,
              )
          ),
        )
    );
  }
}