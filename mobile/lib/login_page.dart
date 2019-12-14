import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/homepage.dart';
import 'package:mobile/scale_navigate.dart';

import 'Quotes.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }
}

class FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  bool showNextButton = false;
  bool showNameLabel = false;
  bool alignTop = false;
  bool increaseLeftPadding = false;
  bool showGreetings = false;
  bool showQuoteCard = false;
  bool showImage = false;
  String name = '';

  double screenWidth;
  double screenHeight;
  String quote;

  @override
  void initState() {
    super.initState();
    Random random = new Random();
    int quoteIndex = random.nextInt(Quotes.quotesArray.length);
    quote = Quotes.quotesArray[quoteIndex];
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 78, 147, 1),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: new ExactAssetImage('assets/layers.png'),
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(32, 44, 0, 0),
                child: _getGreetingLabelWidget(),
              ),
            ),
            _getAnimatedAlignWidget(),
/*          Align(
              alignment: Alignment.center,
              child: _getQuoteCardWidget(),
            ),*/
            _getAnimatedImageWidget(),
            _getAnimatedPositionWidget(),
            Align(
              alignment: Alignment.bottomRight,
              child: _getAnimatedOpacityButton(),
            )
          ],
        ),
      ),
    );
  }

  _getAnimatedOpacityButton() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      // reverseDuration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      opacity: showNextButton ? 1 : 0,
      child: _getButton(),
    );
  }

  _getAnimatedCrossfade() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      alignment: Alignment.center,
      reverseDuration: Duration(milliseconds: 300),
      firstChild: _getNameInputWidget(),
      firstCurve: Curves.easeInOut,
      secondChild: _getNameLabelWidget(),
      secondCurve: Curves.easeInOut,
      crossFadeState:
          showNameLabel ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  _getAnimatedAlignWidget() {
    return AnimatedAlign(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      alignment: alignTop ? Alignment.topLeft : Alignment.center,
      child: _getAnimatedPaddingWidget(),
    );
  }

  _getAnimatedPaddingWidget() {
    return AnimatedPadding(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      padding: increaseLeftPadding
          ? EdgeInsets.only(left: 28.0)
          : EdgeInsets.only(left: 0),
      child: _getAnimatedCrossfade(),
    );
  }

  _getNameLabelWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.0),
      child: Container(
          margin: EdgeInsets.fromLTRB(8, 44, 0, 0),
          width: screenWidth / 2,
          height: 75.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(fontSize: 28.0, color: Colors.white),
            ),
          )),
    );
  }

  _getNameInputWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: screenWidth / 2,
        height: 120.0,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Hey! May I know your name?",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 18,
              ),
              Theme(
                data: new ThemeData(
                  splashColor: Colors.transparent,
                  primaryColor: Colors.white,
                  accentColor: Colors.white,
                  hintColor: Colors.white,
                ),
                child: new TextField(
                  onChanged: (v) {
                    name = v;
                    if (v.length > 0) {
                      setState(() {
                        showNextButton = true;
                      });
                    } else {
                      setState(() {
                        showNextButton = false;
                      });
                    }
                  },
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(33, 47, 61, 1)),
                  decoration: new InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(55.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55.0),
                        borderSide: new BorderSide(color: Colors.white)),
                    // hintText: "May I know your name?",
                    // //  helperText: 'Keep it short, this is just a demo.',
                    // labelText: "What's your name?",
                    // labelStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color.fromRGBO(33, 47, 61, 1),
                    ),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                // TextField(
                //   decoration: InputDecoration(
                //       enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: Colors.redAccent),
                //       ),
                //       hintText: 'Name'),
                //   textAlign: TextAlign.left,
                //   textCapitalization: TextCapitalization.words,
                //   onChanged: (v) {
                //     name = v;
                //     if (v.length > 0) {
                //       setState(() {
                //         showNextButton = true;
                //       });
                //     } else {
                //       setState(() {
                //         showNextButton = false;
                //       });
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getGreetingLabelWidget() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: showGreetings ? 1.0 : 0.0,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8.0,
        ),
        child: Container(
            width: screenWidth / 2,
            height: 75.0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hi,",
                style: TextStyle(fontSize: 28.0, color: Colors.white),
              ),
            )),
      ),
    );
  }

  _showGreetings() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showGreetings = true;
      });
    });
  }

  _increaseLeftPadding() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        increaseLeftPadding = true;
      });
    });
  }

  _getAnimatedPositionWidget() {
    return AnimatedOpacity(
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      opacity: showQuoteCard ? 1.0 : 0.0,
      child: _getQuoteCardWidget(),
      // right: 80,
      // top: screenHeight / 2 - 20,
      // left: 18,
    );
  }

  _getAnimatedImageWidget() {
    return AnimatedPositioned(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: getImageWidget(),
      right: 160,
      top: screenHeight / 2 - 200,
      left: 5,
    );
  }

  getImageWidget() {
    return AnimatedOpacity(
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      opacity: showImage ? 1.0 : 0.0,
      child: Container(
        height: 200,
        width: screenWidth - 60,
        child: Image.asset("assets/credit.png"),
      ),
    );
  }

  _getQuoteCardWidget() {
    return
        //Card(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //elevation: 6.0,
        _getAnimatedSizeWidget();
    //);
  }

  _getAnimatedSizeWidget() {
    return _getQuoteContainer();
    // return AnimatedSize(
    //   duration: Duration(seconds: 1),
    //   curve: Curves.easeInOut,
    //   vsync: this,
    //   child: _getQuoteContainer(),
    // );
  }

  _getQuoteContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, screenHeight / 2, 0, 0),
      height: showQuoteCard ? 180 : 0,
      width: screenWidth - 120,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Text(
          "You can check your credit and debit card balance from this app, just swipe from the collection of your card and know your balance and your expenditure.",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  _showQuote() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showQuoteCard = true;
      });
    });
  }

  _showImage() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showImage = true;
      });
    });
  }

  _getButton() {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: FloatingActionButton(
        onPressed: showQuoteCard
            ? () {
                Navigator.push(context, ScaleRoute(page: HomePage()));
                print("object");
              }
            : () {
                FocusScope.of(context).unfocus();
                setState(() {
                  showNameLabel = true;
                  alignTop = true;
                });
                _increaseLeftPadding();
                _showGreetings();
                _showImage();
                _showQuote();
              },
        child: Icon(
          Icons.arrow_forward,
          color: Color.fromRGBO(33, 47, 61, 1),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
