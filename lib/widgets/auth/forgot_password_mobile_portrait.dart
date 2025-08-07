import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/widgets/common/color.dart';

import '../common/alert_dialog_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final alertDialog = AlertDialogWidget();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: '');
  bool _isSubmitting = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Simulate a network request for password reset
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Password Reset"),
          content: const Text(
              "If the email exists, a password reset link has been sent."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Object payload = {'email': _emailController.text};
                BlocProvider.of<AuthCubit>(context)
                    .sendResetPassword(payload: payload);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          _isSubmitting = state.isLoading;
        }
        if (state is SuccessForgotPasswordState) {
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Fogot Password',
            content: state.successMessage,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.push('/reset-password');
            },
            context: context,
          );
        }
        if (state is FailureForgotPasswordState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Fogot Password Failed',
            content: state.errorMessage,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            context: context,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 216, 245, 254),
        appBar: AppBar(
          title: const Text("Forgot Password"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your email address to receive a password reset link.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is LoadingAuthState) {
                      _isSubmitting = state.isLoading;
                    }
                    return Center(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                child: Text('Submitting'),
                              )
                            : const Text("Send Reset Link"),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
