import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pluto_apk/User/generator.dart';
import 'package:pluto_apk/Worker/result.dart';

const bgColor = Color(0xfffafafa);

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {

  bool isScanCompleted = false;

  void closeScreen(){
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Container( child: Text("Scanner"),)),
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: (capture){
                        if(!isScanCompleted){
                          String code = capture.barcodes.last.rawValue ?? '---';
                          isScanCompleted = true;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Result(closeScreen: closeScreen, code: code,)));
                        }

                      },
                    ),
                    
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
