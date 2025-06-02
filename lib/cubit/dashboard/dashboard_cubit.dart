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
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboard_state.dart';
final APIServiceRepo _apiServiceRepo = APIServiceRepo();
UserBox _userBox = UserBox();
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  logout() async {
   
    Object payload = {
      'platform': kIsWeb ? 'web' : 'mobile',
    };
    var response = await _apiServiceRepo.post(kLogout, payload);

    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      emit(const LoadingDashboardState(false));
      emit(SuccessLogoutState(responseModel.message, responseModel.isError));
    } else {
      emit(const LoadingDashboardState(false));
      emit(FailureDashboardState(responseModel.message, responseModel.isError));
    }
  }
  setDashboardIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('dashboardIndexPage',index);
    emit(SetDashboardIndex(index));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('dashboardIndexPage') ?? 0;
    emit(SetDashboardIndex(index));
  }
}

