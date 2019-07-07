import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'RescueMe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle optionStyle2 =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  final List<Widget> _widgetOptions = <Widget>[
    Container(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
        Container(
          height: 100,
          color: Colors.blue[100],
          child: const Center(child: Text('Home',style: optionStyle,)),
        ),
        Container(
          height: 230,
          color: Colors.blue[400],
          child: const Center(child: Text('!',style: optionStyle,)),
        ),
        Container(
          height: 350,
          color: Colors.blue[600],
          child: const Center(child: Text('Lo demas',style: optionStyle,)),
        ),
      ],
    ),
    ),
    Container(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
        Container(
          child: Center(
            child: Container(
              width: 190.0,
              height: 190.0,
              color: Colors.grey[400],
              
          ),
          
          ),
        ),
        Container(
          height: 170,
          color: Colors.white,
          child: const Center(child: Text('Datos',style: optionStyle2,)),
        ),
        Container(
          height: 170,
          color: Colors.white,
          child: const Center(child: Text('Mas datos',style: optionStyle2,)),
        ),
      ],
    ),
    ),
    /*
    Container(
      child: Center(
      child: Container(
      width: 190.0,
      height: 190.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
                 "https://i.imgur.com/BoN9kdC.png")
                 )
        )),
      ),
    ),
    */
    Container(
      child: Center(
        child: Text(
          'Map',
          style: optionStyle,
        ),
      ),
    ),
    Container(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
        Container(
          height: 100,
          color: Colors.blue[100],
          child: Row(
            children: <Widget>[
              Container(
                height: 100,
                width: 50,
                color: Colors.cyan[100],
                child: Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 50,
                color: Colors.cyan[200],
                child: Center(
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 50,
                color: Colors.cyan[300],
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 50,
                color: Colors.cyan[400],
                child: Center(
                  child: Icon(
                    Icons.memory,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 230,
          color: Colors.blue[250],
          child: const Center(child: Text('!',style: optionStyle,)),
        ),
        Container(
          height: 350,
          color: Colors.blue[350],
          child: const Center(child: Text('Lo demas',style: optionStyle,)),
        ),
      ],
    ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RescueMe'),
        backgroundColor: Colors.blueGrey
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Coord'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: messages.map(buildMessage).toList(),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
