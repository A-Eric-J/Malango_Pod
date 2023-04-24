import 'package:flutter/material.dart';
import 'package:malango_pod/enums/lifecycle_state.dart';

/// [LifecycleProvider] is for all Providers to handle lifecycle states
class LifecycleProvider extends ChangeNotifier {

  /// Handle lifecycle states
  LifecycleState _lifecycleState = LifecycleState.none;
  void setLifecycleState(LifecycleState newState){
    _lifecycleState = newState;
    switch(_lifecycleState){
      case LifecycleState.none:
        break;
      case LifecycleState.pause:
        lifecyclePauseListener();
        break;
      case LifecycleState.resume:
        lifecycleResumeListener();
        break;
    }
    notifyListeners();
  }
  LifecycleState get lifecycleState => _lifecycleState;


  void lifecycleResumeListener() {}

  void lifecyclePauseListener() {}

}
