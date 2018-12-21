import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';
import 'dart:async';

void main() => runApp(SoccerApp ());

var userInputs = [];
var playerNames = [];
var playersOut = [];

var playerCharts = new List<Widget>();
var playerAmount = int.parse(userInputs[0]);
var totalTime = int.parse(userInputs[1]);
var playersInAmount = int.parse(userInputs[2]);
var substitutionFrequency = int.parse(userInputs[3]);

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
                onPressed: null,
              )
          )
      )
  );

}

// main application widget
class SoccerApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SUB OUT',
        home: InputFields(),
        routes: <String, WidgetBuilder> {
//        '/playerNames': (BuildContext context) => MyPage(title: 'Player Names')
        }
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
  bool _canVibrate = true;

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

  void submit() {
    playerNames = [];
    _formKey.currentState.save();
    print(playerNames);
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
          counterText: '',
          labelText: title,
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
//            myController.dispose();
            this.submit();
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => PlayerNames())
//            );
          },
        )
    )
    );

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