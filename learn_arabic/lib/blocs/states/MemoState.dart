import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';

class MemoState extends BaseState<MemoModel> {
  MemoState()
      : super(
            name: 'memo',
            initialState: MemoModel(
                lessRanSeconds: 0,
                wordSpace: 1.0,
                tts: false,
                fontSize: 2.0,
                isLandscape: false));
  @override
  Stream<MemoModel> mapActionToState(MemoModel state, Action action) async* {
    switch (action.type) {
      case ActionTypes.SYNC_WITH_PREFERENCE:
        yield action.payload['memo'];
        break;
      case ActionTypes.SAVE_LESS_RUNNING_TIME:
        double vprogress =
            100 * action.payload['ranTime'] / action.payload['totalTime'];
        AppService.saveInPref('${action.payload['ranTime']}-$vprogress',
            AppService.prefkey_less_ran_times);

        yield state.copyWith(
            lessRanSeconds: action.payload['ranTime'],
            videoProgress: vprogress);
        break;
      case ActionTypes.SET_WORDSPACE:
        AppService.saveInPref(action.payload, AppService.prefkey_wordSpace);
        yield state.copyWith(wordSpace: action.payload);
        break;
      case ActionTypes.SET_FONTSIZE:
        AppService.saveInPref(action.payload, AppService.prefkey_fontSize);
        yield state.copyWith(fontSize: action.payload);
        break;

      case ActionTypes.SET_LANDSCAPE:
        AppService.saveInPref(action.payload, AppService.prefkey_landscape);
        yield state.copyWith(isLandscape: action.payload);
        break;
      case ActionTypes.SET_THEME:
        AppService.saveInPref(action.payload.index, AppService.prefkey_theme);
        yield state.copyWith(theme: action.payload);
        break;
      case ActionTypes.SET_TTS:
        AppService.saveInPref(action.payload, AppService.prefkey_tts);
        yield state.copyWith(tts: action.payload);
        break;
      case ActionTypes.SET_VIDEO_ID:
        AppService.saveInPref(action.payload, AppService.prefkey_videoid);
        yield state.copyWith(videoId: action.payload);
        break;
      case ActionTypes.SET_SCROLL_OFFSET:
        AppService.saveInPref<String>(
            '${action.payload['scroll']}-${action.payload['refPerScroll']}',
            AppService.prefkey_scrollOffset);
        yield state.copyWith(
            scrollOffset: action.payload['scroll'],
            pageIndexPerScroll: action.payload['refPerScroll']);
        break;
      case ActionTypes.SELECT_WORD:
        AppService.saveInPref<String>(
            action.payload['wordIndex'], AppService.prefkey_wordIndex);

        yield state.copyWith(
            selectedWord: action.payload['word'],
            wordIndex: action.payload['wordIndex']);
        break;
      case ActionTypes.SELECT_WORD_ONLY:
        yield state.copyWith(selectedWord: action.payload);
        break;
      case ActionTypes.LECTURE_CATEGORY:
        AppService.saveInPref<int>(
            action.payload, ActionTypes.LECTURE_CATEGORY);
        yield state.copyWith(lectureCategory: action.payload);
        break;
      case ActionTypes.WORDMEANING_CATEGORY:
        AppService.saveInPref<int>(
            action.payload, ActionTypes.WORDMEANING_CATEGORY);
        yield state.copyWith(wordMeaningCategory: action.payload);
        break;
      default:
        yield state;
    }
  }
}
