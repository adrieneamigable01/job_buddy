import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';

final AlertDialogWidget alertDialog = AlertDialogWidget();

class ResetPasswordMobilePortait extends StatefulWidget {
  const ResetPasswordMobilePortait({super.key});

  @override
  State<ResetPasswordMobilePortait> createState() =>
      _ResetPasswordMobilePortaitState();
}

class _ResetPasswordMobilePortaitState
    extends State<ResetPasswordMobilePortait> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      Object payload = {
        'email': _emailController.text,
        'token': _tokenController.text,
        'new_password': _newPasswordController.text
      };
      BlocProvider.of<AuthCubit>(context).resetPassword(payload: payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          _isLoading = state.isLoading;
        }
        if (state is SuccessForgotPasswordState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Reset Password!'),
                content: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.successMessage)),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      context.push('/splash');
                    },
                    child: const Text("Back to Login"),
                  ),
                ],
              );
            },
          );
        }
        if (state is FailureForgotPasswordState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Reset Password Failed!'),
                content: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage)),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Only closes the dialog
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Enter your email, 5-digit token, and new password.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Token
                TextFormField(
                  controller: _tokenController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    labelText: 'Reset Token (5-digit)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length != 5) {
                      return 'Enter a valid 5-digit code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // New Password
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is LoadingAuthState) {
                      _isLoading = state.isLoading;
                    }
                    return ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const Text("Reseting Password")
                          : const Text('Reset Password'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
