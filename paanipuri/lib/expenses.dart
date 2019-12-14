import 'package:flutter/material.dart';

class BodyWidget extends StatefulWidget {
  final Map data;

  BodyWidget({this.data});

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget>
    with SingleTickerProviderStateMixin {
  bool showText = false;
  Animation<double> animation;
  Animation<double> textMove;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //animationController.reset();
          //animationController.resync(this);
        } else if (status == AnimationStatus.dismissed) {}
      });
    animationController.forward();
    showTextBlock();
  }

  showTextBlock() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showText = true;
      });
    });
  }

  @override
  Widget build(BuildContext cx) {
    var tt = Theme.of(cx).textTheme;
    var pd = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 33,
          ),
          Row(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 33,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              AnimatedOpacity(
                opacity: showText ? 1.0 : 0.0,
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.all(24),
                  child: Text(
                    "Expenditure",
                    style: TextStyle(fontSize: 33),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: (widget.data['tx'] as List).length + 1,
            itemBuilder: (c, i) {
              if (i == 0) {
                return Container();
              }
              var tx = widget.data['tx'][i - 1];
              return Container(
                transform: Matrix4.translationValues(
                    (animation.value * -100) * (5 * i), 0.0, 0.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: pd,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.shopping_cart,
                            size: 24.0, color: Colors.blueGrey),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(tx['m'],
                                  style: TextStyle(color: Colors.black)),
                              Text(tx['t'],
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                        ),
                        Text(tx['a'],
                            style: tt.body2.apply(color: Colors.deepOrange))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
