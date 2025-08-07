import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:meta/meta.dart';

import 'package:job_buddy/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final UserBox _userBox = UserBox();

  clearBoxes() async {
    await _userBox.clear();
  }

  void login({required String email, required String password}) async {
    emit(const LoadingAuthState(true));
    print("**** Login email.... : $email");
    print("**** Login password.... : $password");
    Object payload = {
      'username': email,
      'password': password,
    };
    var response = await _apiServiceRepo.post(kAuthLogin, payload);

    ResponseModel responseModel = ResponseModel(json: response);
    String message = responseModel.message;

    if (!responseModel.isError) {
      await clearBoxes();

      dynamic userInformation = responseModel.data['user_information'][0];
      String accessToken = responseModel.data['token'].toString();
      print("userInformation: $userInformation");
      userInformation['accessToken'] = accessToken;
      userInformation['usertype'] = responseModel.data['user_type'];

      if (kIsWeb) {
      } else {
        if (userInformation['usertype'].toString() == 'student' ||
            userInformation['usertype'].toString() == 'employer') {
          await _userBox.insert(userInformation);
          emit(const LoadingAuthState(false));
          emit(SuccessAuthState(message, responseModel.isError));
        } else {
          emit(const LoadingAuthState(false));
          emit(FailureState(
              '${userInformation['usertype']} is not allowed to login', true));
        }
      }
    } else {
      emit(const LoadingAuthState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
    }
  }

  void register({required Object payload}) async {
    emit(const LoadingAuthState(true));

    var response = await _apiServiceRepo.post(kAuthRegister, payload);

    ResponseModel responseModel = ResponseModel(json: response);
    String message = responseModel.message;

    if (!responseModel.isError) {
      emit(const LoadingAuthState(false));
      emit(SuccessAuthState(message, responseModel.isError));
    } else {
      emit(const LoadingAuthState(false));
      emit(FailureForgotPasswordState(
          responseModel.message, responseModel.isError));
    }
  }

  void sendResetPassword({required Object payload}) async {
    emit(const LoadingAuthState(true));

    var response = await _apiServiceRepo.post(kSendResetPassword, payload);

    ResponseModel responseModel = ResponseModel(json: response);
    String message = responseModel.message;

    if (!responseModel.isError) {
      emit(const LoadingAuthState(false));
      emit(SuccessForgotPasswordState(message, responseModel.isError));
    } else {
      emit(const LoadingAuthState(false));
      emit(FailureForgotPasswordState(
          responseModel.message, responseModel.isError));
    }
  }

  void resetPassword({required Object payload}) async {
    emit(const LoadingAuthState(true));

    var response = await _apiServiceRepo.post(kResetPasswordWithToken, payload);

    ResponseModel responseModel = ResponseModel(json: response);
    String message = responseModel.message;

    if (!responseModel.isError) {
      emit(const LoadingAuthState(false));
      emit(SuccessForgotPasswordState(message, responseModel.isError));
    } else {
      emit(const LoadingAuthState(false));
      emit(FailureForgotPasswordState(
          responseModel.message, responseModel.isError));
    }
  }

  logout() async {
    emit(LoadingLogoutState(true));
    var response = await _apiServiceRepo.get(kLogout);
    print("Logout Response : ${jsonEncode(response)}");
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      await clearBoxes();
      String message = responseModel.message;
      emit(LoadingLogoutState(false));
      emit(SuccessLogoutAuthState(message, responseModel.isError));
    } else {
      emit(LoadingLogoutState(false));
      emit(
          SuccessLogoutAuthState(responseModel.message, responseModel.isError));
    }
  }
}
