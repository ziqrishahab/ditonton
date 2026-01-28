import 'dart:async';

import 'package:ditonton/common/constants.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setTestEnvironment(true);
  await testMain();
}
