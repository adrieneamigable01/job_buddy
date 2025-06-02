import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';

// Register all providers here
class BlocProviders {
  static List<BlocProvider> get() {
    return [
      BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
    ];
  }
}