import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plugin_demo/pages/blue/main.dart';
import 'package:plugin_demo/pages/camera/main.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plugin_demo/pages/new-route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'plugin demo'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // 当前选中的底部导航栏索引
  int _selectedIndex = 1;

  // 底部导航栏点击事件
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void testFor() {
    for (var i = 0; i < 99999999; i++) {}
  }

  void _incrementCounter() {
    print("点击了 $_counter");
    log("log: 点击了 $_counter");

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    testFor();

    return Scaffold(
      // 顶部导航栏
      appBar: AppBar(
        // 标题
        title: Text(widget.title),
        //导航栏右侧菜单
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                print("点击了分享");
              }),
        ],
      ),
      // 主体内容
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text("router"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const NewRoute(id: "000");
                  }),
                );
              },
            ),
            ElevatedButton(
              child: const Text("相机"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const CameraPage();
                  }),
                );
              },
            ),
            OutlinedButton(
              child: const Text("蓝牙"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const BluePage();
                  }),
                );
              },
            ),
            Text(
              'You have pushed the button this many times: $_counter',
            ),
          ],
        ),
      ),
      // 浮动按钮
      floatingActionButton: FloatingActionButton(
        // 点击事件
        onPressed: _incrementCounter,
        // 提示
        tooltip: 'Increment',
        // 图标
        child: const Icon(Icons.add),
      ),
      // 底部导航
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      // 抽屉菜单
      drawer: const MyDrawer(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add account'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
