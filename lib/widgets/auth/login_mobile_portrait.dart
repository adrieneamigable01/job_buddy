import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/widgets/common/textfield_widget.dart';
import 'package:job_buddy/widgets/common/color.dart';

final formKey = GlobalKey<FormState>();
final TextEditingController _emailController =
    TextEditingController(text: '');
final TextEditingController _passwordController =
    TextEditingController(text: '');
// final TextEditingController _emailController =
//     TextEditingController(text: 'employer@gmail.com');
// final TextEditingController _passwordController =
//     TextEditingController(text: 'password123');
final FocusNode phoneNumberFocus = FocusNode();
final PageController page = PageController();
final AlertDialogWidget alertDialog = AlertDialogWidget();

class LoginPageMobilePortrait extends StatelessWidget {
  LoginPageMobilePortrait({super.key});

  _fieldFocusChange(
      {required BuildContext context,
      required FocusNode currentFocus,
      required FocusNode nextFocus}) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    // RouteSettings routeSettings;
    bool isLoading = false;

    return SelectionArea(
        child: SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Ensure this is true or omitted
        backgroundColor: defaultBackgroundColor,
        body: Container(
          color: defaultBackgroundColor,
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is SuccessAuthState) {
                context.push('/splash');
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Center(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            // margin: const EdgeInsets.only(top: 20),
                            child: const Center(
                              child: Image(
                                image: AssetImage('assets/logo/logo.png'),
                                width: 200,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              Widget errorMessage = Text("");
                              if (state is FailureState) {
                                errorMessage = Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.errorMessage,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        decoration: TextDecoration
                                            .underline, // Underline the text
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                );
                              }

                              return errorMessage;
                            },
                          ),
                          Text(
                            "Email or Username",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F94D4),
                              decoration: TextDecoration
                                  .underline, // Underline the text
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget().textWithBorder(
                              labelText: '',
                              controller: _emailController,
                              onChanged: (string) => {},
                              onFieldSubmitted: (string) => {}),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F94D4),
                              decoration: TextDecoration
                                  .underline, // Underline the text
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget().textWithBorder(
                              labelText: '',
                              controller: _passwordController,
                              obscureText: true,
                              onChanged: (string) => {},
                              onFieldSubmitted: (string) => {}),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to forgot password screen or show dialog
                                context.push('/forgot-password');
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xff1F94D4),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14.0),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Don’t have account? ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push('/registration');
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 250.0,
                                maxWidth: 250.0,
                                minHeight: 20.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color:
                                    defaultButtonBackgroundColor, // Keep the background transparent
                                border: Border.all(
                                  color: Colors.grey
                                      .shade300, // Set the border color to grey
                                  width: 1.5, // Set the border width
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.25), // Shadow color
                                    blurRadius: 10, // Blur radius
                                    spreadRadius: 2, // Spread radius
                                    offset:
                                        Offset(0, 5), // Position of the shadow
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: !isLoading
                                    ? () {
                                        if (formKey.currentState!.validate()) {
                                          BlocProvider.of<AuthCubit>(context)
                                              .login(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text);
                                        }
                                      }
                                    : null,
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    Widget button = Text(
                                      "Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: defaultTextColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                    if (state is LoadingAuthState) {
                                      button = Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text('Loading...'),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                        ],
                                      );
                                    }
                                    return button;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
