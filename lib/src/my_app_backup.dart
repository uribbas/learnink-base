import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnInk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //color: Colors.blue[800],
          gradient: LinearGradient(
            begin:Alignment.topLeft,
            end:Alignment.bottomRight,
          colors:[Colors.blue[500],Colors.blue[900]])
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 20.0,
              top: 20.0,
              child: SafeArea(
                left: true,
                top: true,
                child: Image.asset(
                  'assets/icons/bg-art.png',
                ),
              ),
            ),
            Positioned(
              right: 20.0,
              top: 20.0,
              child: SafeArea(
                top: true,
                right: true,
                child: FlatButton(
                  color: Colors.transparent,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Positioned(
              top: 180.0,
              left: 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Experience',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: Text(
                      'the',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    'Difference',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child:Text('This is a test')
                  ),
                  /*Flexible(
                    fit: FlexFit.loose,
                    child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          child:
                              const Text('He\'d have you all unravel at the'),
                          color: Colors.teal[100],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('Heed not the rabble'),
                          color: Colors.teal[200],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('Sound of screams but the'),
                          color: Colors.teal[300],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('Who scream'),
                          color: Colors.teal[400],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('Revolution is coming...'),
                          color: Colors.teal[500],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text('Revolution, they...'),
                          color: Colors.teal[600],
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
