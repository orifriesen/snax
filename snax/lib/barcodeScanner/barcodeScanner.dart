import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/homePage/specificSnack.dart';
import 'package:camerakit/CameraKitController.dart';
import 'package:camerakit/CameraKitView.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool searching = false;

  bool flashEnabled = false;
  CameraKitController cameraKitController = CameraKitController();

  // A list of upc's that should not be searched again
  List<int> blacklist = [];

  searchForSnack(int upc) {
    setState(() {
      this.searching = true;
    });
    print("searching for " + upc.toString());
  }

  void _barcodeScan(int code) async {
    print("BARCODE SCAN");
    // Lookup code
    if (this.searching == false && !this.blacklist.contains(code)) {
      setState(() {
        this.searching = true;
      });
      print("will be searching code " + code.toString());
      try {
        var snack = await SnaxBackend.upcResult(code);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ProductPage(item: snack)));
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Not Found"),
                  content: Text(
                      "Would you like to associate this barcode with a snack so other users can find it?"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                      textTheme: ButtonTextTheme.accent,
                    ),
                    FlatButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BarcodeAddCodePage(code)));
                        Navigator.of(context).pop();
                        showSearch(
                            context: context,
                            delegate:
                                BarcodeAddSearch((SnackSearchResultItem snack) {
                              setState(() {
                                this.searching = true;
                              });
                              SnaxBackend.addUpc(code, snack.id).then((_) {
                                Fluttertoast.showToast(
                                    msg: "Added Barcode",
                                    textColor: Colors.greenAccent);
                                blacklist.remove(code);
                              }).catchError((error) {
                                if (error.runtimeType.toString() == "String") {
                                  Fluttertoast.showToast(
                                      msg: error, textColor: Colors.redAccent);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Failed to Add",
                                      textColor: Colors.redAccent);
                                }
                              }).whenComplete(() {
                                setState(() {
                                  this.searching = false;
                                });
                              });
                            }, confirmDialog: true));
                      },
                      child: Text("Find This Snack"),
                    ),
                  ],
                ));
        this.blacklist.add(code);
        //Done loading
        setState(() {
          this.searching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan Barcode"),
          actions: [
            IconButton(
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off),
                onPressed: () {
                  setState(() {
                    this.cameraKitController.changeFlashMode(flashEnabled
                        ? CameraFlashMode.off
                        : CameraFlashMode.on);
                    this.flashEnabled = !this.flashEnabled;
                  });
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            // SizedBox(
            //   width: double.infinity,
            //   height: double.infinity,
            //   child: ScanPreviewWidget(
            //     onScanResult: (code) {
            //       this._barcodeScan(int.parse(code));
            //     },
            //   ),
            // )
                CameraKitView(
                  cameraKitController: cameraKitController,
                  hasBarcodeReader: true,
                  barcodeFormat: BarcodeFormats.FORMAT_ALL_FORMATS,
                  scaleType: ScaleTypeMode.fill,
                  previewFlashMode: CameraFlashMode.off,
                  onPermissionDenied: () {
                    print("Camera permission is denied.");
                    //ToDo on permission denied by user
                    //this.widget.callback(-1);
                  },
                  onBarcodeRead: (String code) {
                    if (code.length == 12 && int.tryParse(code) != null) {
                      this._barcodeScan(int.parse(code));
                    } else {
                      print("not a bardcode");
                      print(code);
                    }
                  },
                ),
              ] +
              ((this.searching)
                  ? [
                      Container(
                        color: Colors.black54,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ]
                  : []),
        ));
  }
}
