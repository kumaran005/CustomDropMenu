import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  TextEditingController _controller;
  String status = "Status";
  List<String> menuItems = ['Profile', 'Value', 'Setting'];
  GlobalKey key = LabeledGlobalKey('button_icon');
  OverlayEntry overlayEntry;
  Size buttonSize;
  Offset buttonPosition;
  bool isMenuOpen = false;
  IconData icon;

  findButton() {
    RenderBox renderBox = key.currentContext.findRenderObject();
    buttonPosition = renderBox.localToGlobal(Offset.zero);
    buttonSize = renderBox.size;
  }

  void openMenu() {
    findButton();
    overlayEntry = overlayEntryBuilder();
    Overlay.of(context).insert(overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    findButton();
    overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  Widget _buildRow(int idx) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            if (idx < menuItems.length) Divider(),
            Text(menuItems[idx], style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          status = menuItems[idx];
        });

        closeMenu();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Custom",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  )),
              Text("DropMenu",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            ]),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                child: Container(
                  key: key,
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 3),
                            spreadRadius: 3,
                            blurRadius: 7)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Icon(
                          isMenuOpen
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (isMenuOpen) {
                    closeMenu();
                  } else {
                    openMenu();
                  }
                }),
          ],
        ),
      ),
    );
  }

  String _searchText;
  String emptyStatus = 'Status';
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {
        _searchText = _controller.text;
      });
    });
  }

  OverlayEntry overlayEntryBuilder() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        top: buttonPosition.dy + buttonSize.height + 5,
        left: buttonPosition.dx,
        width: buttonSize.width,
        child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                    width: 80,
                    height: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              spreadRadius: 3,
                              blurRadius: 7)
                        ],
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              width: 80,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, right: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 27,
                                      child: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Colors.black12,
                                            hintText: "Enter"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 110,
                                      child: ListView.builder(
                                          itemCount: menuItems.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return _buildRow(i);
                                          }))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white),
                            child: Center(
                              child: IconButton(
                                  iconSize: 15,
                                  icon: Icon(Icons.done),
                                  onPressed: () {
                                    setState(() {
                                      if (_searchText.isNotEmpty) {
                                        status = _searchText;
                                        _controller.clear();

                                        closeMenu();
                                      } else {
                                        status = emptyStatus;
                                        closeMenu();
                                      }
                                    });
                                  }),
                            )),
                      ],
                    )),
              ],
            )),
      );
    });
  }
}
