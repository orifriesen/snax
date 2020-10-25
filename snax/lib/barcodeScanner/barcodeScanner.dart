import 'package:flutter/material.dart';
import 'package:camerakit/CameraKitController.dart';
import 'package:camerakit/CameraKitView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/homePage/specificSnack.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool searching = false;

  CameraKitController cameraKitController = CameraKitController();
  bool flashEnabled = false;

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
        showDialog(context: context, builder: (context) => AlertDialog(title: Text("Not Found"),content: Text("Would you like to associate this barcode with a snack so other users can find it?"),actions: [
          FlatButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("Cancel"),textTheme: ButtonTextTheme.accent,),
          FlatButton(onPressed: () {
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BarcodeAddCodePage(code)));
            Navigator.of(context).pop();
            showSearch(context: context, delegate: BarcodeAddSearch((SnackSearchResultItem snack) {
              setState(() {
                this.searching = true;
              });
              SnaxBackend.addUpc(code, snack.id).then((_) {
                Fluttertoast.showToast(msg: "Added Barcode", textColor: Colors.greenAccent);
                blacklist.remove(code);
              }).catchError((error) {
                if (error.runtimeType.toString() == "String") {
                  Fluttertoast.showToast(msg: error,textColor: Colors.redAccent);
                } else {
                  Fluttertoast.showToast(msg: "Failed to Add",textColor: Colors.redAccent);
                }
              }).whenComplete(() {
                setState(() {
                  this.searching = false;
                });
              });
            }));
          }, child: Text("Find This Snack"),),
        ],));
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
                CameraKitView(
                  cameraKitController: cameraKitController,
                  hasBarcodeReader: true,
                  barcodeFormat: BarcodeFormats.FORMAT_UPC_A,
                  scaleType: ScaleTypeMode.fill,
                  previewFlashMode: CameraFlashMode.off,
                  onPermissionDenied: () {
                    print("Camera permission is denied.");
                    //ToDo on permission denied by user
                    //this.widget.callback(-1);
                  },
                  onBarcodeRead: (code) {
                    this._barcodeScan(int.parse(code));
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
