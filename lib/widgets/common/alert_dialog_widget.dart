import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertDialogWidget {
  showDetailsDialog(
      {required BuildContext context,
      required String title,
      required String desc,
      required Widget content}) async {
    await Alert(
      type: AlertType.none,
      context: context,
      title: title,
      desc: desc,
      content: content,
      buttons: [
        DialogButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
      closeFunction: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    ).show();
  }

  showAlertMessage(
      {required BuildContext context,
      required String title,
      required String desc,
      bool isError = false}) async {
    await Alert(
      type: isError == true ? AlertType.error : AlertType.success,
      context: context,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
      closeFunction: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    ).show();
  }

  showAlertMessage2(
      {required BuildContext context,
      required String title,
      required String desc,
      bool isError = false}) async {
    await Alert(
      type: isError == true ? AlertType.error : AlertType.success,
      context: context,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            })
      ],
      closeFunction: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
      },
    ).show();
  }

  DialogButton customDialogButton(
      {required String text,
      required VoidCallback onPressed,
      required TextStyle textStyle,
      Color buttonColor = Colors.blue,
      double buttonRadius = 12.0,
      double width = double.infinity,
      double height = 45.0,
      Color borderColor = Colors.blueAccent,
      double borderWidth = 2.0}) {
    return DialogButton(
      child: Container(
        alignment: Alignment.center,
        width: width, // Button width
        height: height, // Button height
        child: Text(
          text,
          style: textStyle,
        ),
      ),
      color: buttonColor, // Background color
      radius: BorderRadius.circular(buttonRadius), // Button border radius
      onPressed: onPressed,

      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ), // Border color and width
    );
  }

  showCustomButton({
    required String text,
    required VoidCallback onPressed,
    required TextStyle textStyle,
    double width = double.infinity,
    ButtonStyle buttonStyle = const ButtonStyle(),
  }) {
    return Container(
      width: width,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  void showCustomAlert(
      {required BuildContext context,
      required String title,
      required String desc,
      required TextStyle titleStyle,
      required TextStyle descStyle,
      required List<Widget> actions}) {
    showDialog(
      context: context,
      useRootNavigator: false, //this property needs to be added
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: titleStyle,
          ),
          content: Text(
            desc,
            style: descStyle,
          ),
          actions: actions,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5.0), // Custom shape with rounded corners
          ),
        );
      },
    );
  }

  Future showAlertDialog({
    required bool isError,
    required String title,
    required String content,
    required BuildContext context,
    required VoidCallback onPressed,
    ButtonStyle buttonStyle = const ButtonStyle(),
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 20),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isError
                  ? const Icon(Icons.warning_rounded, color: Colors.amber)
                  : const Icon(Icons.check_circle_outline, color: Colors.green),
              const SizedBox(width: 5.0),
              Flexible(child: Text(content)),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ✅ close only the dialog
                onPressed(); // ✅ run your callback after closing
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future showConfirmDialog({
    required bool isError,
    required String title,
    required String content,
    required BuildContext context,
    required VoidCallback onPressedConfirm,
    required VoidCallback onPressCancel,
    ButtonStyle buttonStyle = const ButtonStyle(),
  }) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isError
                    ? const Icon(
                        Icons.warning_rounded,
                        color: Colors.amber,
                        size: 50,
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 50,
                      ),
                const SizedBox(width: 5.0),
                Flexible(
                  child: Text(content),
                )
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: buttonStyle,
                onPressed: onPressCancel,
                child: Text("Cancel"),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: onPressedConfirm,
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  showLoadingDialog(
      {required BuildContext context,
      required Function onPressed,
      String loadingMessage = 'Loading...'}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loadingMessage),
                SizedBox(
                  width: 15.0,
                ),
              ],
            ),
            actions: null,
          );
        });
  }

  showLogoutLoadingDialog({
    required BuildContext context,
    required Function onPressed,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Logging out...'),
                SizedBox(
                  width: 15.0,
                ),
                CircularProgressIndicator(),
              ],
            ),
            actions: null,
          );
        });
  }

  showCustomContentDialog({
    required BuildContext context,
    required Widget content,
    required Widget title,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            titlePadding: const EdgeInsets.all(0),
            titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
            title: Container(
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  title,
                  Spacer(),
                  TextButton(
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.75,
              child: content,
            ),
            actions: null,
          );
        });
  }

  showCustomFormDialog({
    required BuildContext context,
    required Widget form,
    required Widget title,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            titlePadding: const EdgeInsets.all(0),
            titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
            title: Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  title,
                  Spacer(),
                  TextButton(
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.75,
              child: form,
            ),
            actions: null,
          );
        });
  }

  showCustomFormDialogCustom({
    required BuildContext context,
    required Widget form,
    required Widget title,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            titlePadding: const EdgeInsets.all(0),
            titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
            title: Container(
              color: Colors.blueAccent,
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  title,
                  Spacer(),
                  TextButton(
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.9,
              child: form,
            ),
            actions: null,
          );
        });
  }

  showCustomConfirmsDialog({
    required BuildContext context,
    required Widget body,
    required Widget title,
    required Function confirmCallback,
    Function? cancelCallback,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: Row(
              children: [
                title,
                Spacer(),
                TextButton(
                    child: const Icon(
                      FontAwesomeIcons.xmark,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.blue,
                    size: 100,
                  ),
                  body,
                ],
              ),
            ),
            actions: [
              Container(
                  constraints: const BoxConstraints(
                      minWidth: 300.0, maxWidth: 300.0, minHeight: 20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        // Color(0xff03E5B7),
                        Colors.blueAccent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      confirmCallback();
                    },
                    child: const Text(
                      "Yes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Container(
                  constraints: const BoxConstraints(
                      minWidth: 300.0, maxWidth: 300.0, minHeight: 20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.redAccent,
                        // Color(0xff03E5B7),
                        Colors.redAccent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "No",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          );
        });
  }
}
