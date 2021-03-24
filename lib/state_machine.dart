import 'package:flutter/widgets.dart';

/*
class FsmContext {
  final _StateMachineWidgetState _widgetState;
  final BuildContext _buildContext;

  get buildContext => _buildContext;

  FsmContext(this._buildContext, this._widgetState);

  void setState(FsmState nextState) {
    _widgetState.state = nextState;
  }
}
*/

abstract class FsmState {
  late final _StateMachineWidgetState _widgetState;

  set widgetState(_StateMachineWidgetState widgetState) => _widgetState = widgetState;

  void setState(FsmState nextState) {
    nextState._widgetState = _widgetState;
    _widgetState.state = nextState;
  }

  Widget render();
}

class _StateMachineWidgetState extends State<StateMachineWidget> {
  FsmState _state;
  FsmState get state => _state;
  set state(FsmState next) => setState(() => _state = next);

  _StateMachineWidgetState(this._state) : super() {
    _state.widgetState = this;
  }

  @override
  Widget build(BuildContext ctx) => state.render();
}

abstract class StateMachineWidget extends StatefulWidget {
  @override
  _StateMachineWidgetState createState() => _StateMachineWidgetState(initialState());

  @protected
  FsmState initialState();
}