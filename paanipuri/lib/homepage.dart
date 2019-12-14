import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paanipuri/scale_navigate.dart';
import 'package:sensors/sensors.dart';
import 'package:shimmer/shimmer.dart';
import 'card_selector.dart';
import 'expenses.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List _cs;
  Map _c;
  double _w = 0;
  double topPos = -10.0;
  double leftPos = -15.0;
  bool showCard = true;
  Animation<double> animation;
  Animation<double> textMove;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString("assets/in.json").then((d) {
      _cs = json.decode(d);
      setState(() => _c = _cs[0]);
    });
    // gyroscopeEvents.listen((GyroscopeEvent event) {
    //   // print(event);
    //   setState(() {
    //     topPos = (event.y * 10000).floor().toDouble();
    //     leftPos = (event.x * 10000).floorToDouble();
    //   });
    // });

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.4, 1.0, curve: Curves.bounceInOut)));
    textMove = Tween<double>(begin: 0.0, end: -180.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.4, curve: Curves.easeOut)))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //animationController.reset();
          //animationController.resync(this);
        } else if (status == AnimationStatus.dismissed) {}
      });
  }

  @override
  Widget build(BuildContext c) {
    if (_cs == null) return Container();
    if (_w <= 0) _w = MediaQuery.of(context).size.width - 40.0;
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 55, 70, 1),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: new ExactAssetImage('assets/layers.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.only(top: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: _w * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: showCard ? 0 : textMove.value,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(42, 42, 0, 42),
                              width: 150,
                              child: Text(
                                "Know your Crads.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 44),
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: Image.asset(
                                "assets/gg.gif",
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        )),
                    showCard
                        ? SizedBox()
                        : Positioned(
                            left: (-_w - 55) * animation.value,
                            child: Container(
                              height: _w * 0.63,
                              width: _w,
                              margin: EdgeInsets.all(24),
                              child: Material(
                                elevation: 34.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CardAtm(_c),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              showCard
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(left: 32, right: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Balance',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 8.0),
                              Text(_c['bl'],
                                  style: TextStyle(color: Colors.white)),
                              //SizedBox(height: 24.0),
                              //Text('Today', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context,
                                  ScaleRoute(page: BodyWidget(data: _c)));
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.pinkAccent,
                          ),
                        ],
                      ),
                    ),

              //,
              Container(
                margin: EdgeInsets.fromLTRB(0, 12, 0, 32),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: CardSelector(
                    cards: _cs
                        .map((c) => Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: CardAtm(c)))
                        .toList(),
                    mainCardWidth: _w,
                    mainCardHeight: _w * 0.63,
                    mainCardPadding: -16.0,
                    onChanged: (i) {
                      print("here in on Change $i");
                      if (animationController.isCompleted) {
                        animationController.reset();
                      }
                      animationController.forward();
                      setState(() {
                        i == 0 ? _c = _cs[4] : _c = _cs[i - 1];
                        // if (i == 1) {
                        //   showCard = true;
                        // } else {
                        showCard = false;
                        // }
                      });
                    },
                    // onChanged: (i) => setState(() => _c = _cs[i])),
                  ),
                ),
              ),
              //  Expanded(child: Amounts(_c)),
            ],
          ),
        ),
      ),
    );
  }
}

class CardAtm extends StatelessWidget {
  final Map _c;

  CardAtm(this._c);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Color(_c['co']),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/${_c['txt']}.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_c['bk'], style: tt.title),
                  Text(_c['ty'].toUpperCase(), style: tt.caption),
                  Expanded(child: Container()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(_c['nm'],
                            style: tt.subhead, overflow: TextOverflow.ellipsis),
                      ),
                      Image.asset('assets/${_c['br']}.png', width: 48.0)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
