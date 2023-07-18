import 'package:get_it/get_it.dart';
import 'package:phonepeproperty/utils/callMessageService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}