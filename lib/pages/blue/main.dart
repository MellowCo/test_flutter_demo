import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BluePage extends StatefulWidget {
  const BluePage({super.key});

  @override
  State<BluePage> createState() => _BluePageState();
}

class _BluePageState extends State<BluePage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('蓝牙'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<bool>(
                    stream: flutterBlue.isScanning,
                    initialData: false,
                    builder: (c, snapshot) {
                      if (snapshot.data!) {
                        return ElevatedButton.icon(
                          onPressed: () => flutterBlue.stopScan(),
                          icon: const Icon(Icons.stop),
                          label: const Text("停止"),
                        );
                      } else {
                        return OutlinedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text("扫描"),
                            onPressed: () => flutterBlue.startScan(
                                timeout: const Duration(seconds: 4)));
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => flutterBlue.connectedDevices),
                initialData: const [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data!
                      .map((r) => ListTile(
                            title: Text(r.name),
                            subtitle: Text(r.id.toString()),
                            trailing: ElevatedButton(
                                child: const Text("连接成功"), onPressed: () {}),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<ScanResult>>(
                stream: flutterBlue.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((r) => ListTile(
                          leading: Text(r.rssi.toString()),
                          title: Text(r.device.name.isEmpty
                              ? 'unknown device'
                              : r.device.name),
                          subtitle: Text(r.device.id.toString()),
                          trailing: ElevatedButton(
                            onPressed: r.advertisementData.connectable
                                ? () async {
                                    try {
                                      print("ElevatedButton $r");
                                      EasyLoading.show(
                                          status: '连接中...',
                                          maskType: EasyLoadingMaskType.black);

                                      await r.device.connect(
                                          timeout: const Duration(seconds: 10));

                                      EasyLoading.showToast("连接成功");
                                    } catch (e) {
                                      print(e);
                                      EasyLoading.showToast("连接失败 $e");
                                    } finally {
                                      EasyLoading.dismiss();
                                    }
                                  }
                                : null,
                            child: const Text("连接"),
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
