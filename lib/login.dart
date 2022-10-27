import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';
import 'utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginScreen({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //variable of getCurrentLocation()
  var locationMessage = "";
  //variable of signin()
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = TextEditingController();
  CollectionReference detail =
      FirebaseFirestore.instance.collection('ueserdetails');

  //for add of current date & location on firebase.
  Future<void> addUser() {
    String Detail =
        DateFormat('dd-MM-yy time: KK:mm: a').format(DateTime.now());
    return detail.add({
      'detail': Detail,
      'location': locationMessage,
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

//for take current location
  Future<String?> getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    locationMessage = "${position.latitude}, ${position.longitude}";
    double latitude = position.latitude;
    double longitude = position.longitude;
    var _currentAddress = "";
    try {
      List<Placemark> placmark = await GeocodingPlatform.instance
          .placemarkFromCoordinates(latitude, longitude);
      Placemark? place = placmark[0];
      _currentAddress =
          '${place.street},${place.country},${place.locality},${place.subLocality}';
    } catch (e) {
      print(e);
    }
    return _currentAddress;
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 133, 113, 212),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'LOGIN HERE.',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: ' SIGN UP',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.brown[50],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 25),
                            child: TextFormField(
                              controller: emailController,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? 'Enter a valid email.'
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Enter your username.",
                                labelText: "Username.",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.brown[50],
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 25),
                            child: TextFormField(
                              controller: passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Enter more then 6 characters'
                                      : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter your password.",
                                labelText: "Password.",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 29, left: 29),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    title: Text("Please share your current location"),
                    subtitle: Text(locationMessage),
                    onTap: () async {
                      PermissionStatus locationStatus =
                          await Permission.location.request();
                      if (locationStatus == PermissionStatus.granted) {
                        //Todo :
                      }
                      if (locationStatus == PermissionStatus.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("The permission is recommended")));
                      }
                      if (locationStatus ==
                          PermissionStatus.permanentlyDenied) {
                        openAppSettings();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.brown, fontSize: 15),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Color.fromARGB(255, 141, 73, 231),
                      child: Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 128, 64, 255),
                              minimumSize: Size.fromHeight(50)),
                          onPressed: signIn,
                          icon: Icon(Icons.lock_open),
                          label: Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    await getCurrentLocation();
    addUser();
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        barrierDismissible: false);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
