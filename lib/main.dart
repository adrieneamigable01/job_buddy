import 'package:job_buddy/bloc_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:cron/cron.dart';
import 'routes.dart';

import 'package:job_buddy/services/api_service.dart';
import 'package:job_buddy/models/response_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  HiveDBHelper hiveDBHelper = HiveDBHelper();
  await hiveDBHelper.openAndRegisterBoxes();
  await runCron();
  runApp(const MyApp());
}



  Future checkToken() async {
    final APIServiceRepo _apiServiceRepo = APIServiceRepo();
    var response = await _apiServiceRepo.get(kCheckToken);
    ResponseModel responseModel = ResponseModel(json: response);
    if(!responseModel.isError){
      if(kIsWeb){
       
      }else{
        await ChatCubit().getChatTreads();
      }
    }
  }

Future runCron() async {
  final cron = Cron();
  try {
    cron.schedule(Schedule.parse('*/10 * * * * *'), () async {
      if(!UserBox().isEmpty){
        await checkToken();
      }
    });

  } on ScheduleParseException {
    // "ScheduleParseException" is thrown if cron parsing is failed.
    await cron.close();
  }
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
      providers: BlocProviders.get(),
      child: MaterialApp.router(
        title: 'Job Buddy',
        routerConfig: router,
      ),
    );
  }
}