import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/models/PainterModel.dart';

class PainterState extends BaseState<PainterModel> {
  PainterState() : super(name: 'painter', initialState: PainterModel.init());
  @override
  Stream<PainterModel> mapActionToState(
      PainterModel state, Action action) async* {
    switch (action.type) {
      case 'paintColor':
        yield state.copyWith(color: action.payload, colorPickerOpened: false);
        break;
      case 'addOffset':
        if (action.payload == null) {
          if (state.points.length == 0 || state.points.last == null) {
            yield state;
            return;
          }
        }
        state.points
            .add(OffsetStatus(action.payload, state.color, state.strokeWidth));
        yield state.copyWith();
        break;
      case 'clearOffset':
        state.points.clear();
        yield state.copyWith();
        break;
      case 'openColorPicker':
        yield state.copyWith(colorPickerOpened: !state.colorPickerOpened);
        break;
      case 'setStrokeWidth':
        yield state.copyWith(strokeWidth: action.payload);
        break;
      case 'painterLines':
        if (state.totalLines == action.payload) {
          yield state;
          return;
        }
        yield state
            .copyWith(totalLines: action.payload, currentIndex: 0, points: []);
        break;
      case 'painterPrev':
        if (state.currentIndex > 0)
          yield state.copyWith(currentIndex: state.currentIndex - 1);
        else
          yield state;
        break;
      case 'painterNext':
        if (state.currentIndex + 1 < state.totalLines)
          yield state.copyWith(currentIndex: state.currentIndex + 1);
        else
          yield state;
        break;
      default:
        yield latestState(this);
    }
  }
}
