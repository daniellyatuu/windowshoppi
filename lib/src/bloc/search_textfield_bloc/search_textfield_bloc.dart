import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextFieldBloc
    extends Bloc<SearchTextFieldEvents, SearchTextFieldStates> {
  SearchTextFieldBloc() : super(SearchTextFieldEmpty());

  @override
  Stream<SearchTextFieldStates> mapEventToState(
      SearchTextFieldEvents event) async* {
    if (event is ClearSearchedKeyword) {
      yield SearchTextFieldLoading();
      yield SearchTextFieldNotEmpty(keyword: '');
    }

    if (event is CheckSearchedKeyword) {
      if (state is SearchTextFieldNotEmpty) {
        String _txt = state.props.reversed.first.toString();

        yield SearchTextFieldLoading();
        yield SearchTextFieldNotEmpty(keyword: _txt);
      }
    }

    if (event is UserTypeOnSearchField) {
      String _keyword = event.keyword.trim();

      if (_keyword != '') {
        yield SearchTextFieldNotEmpty(keyword: _keyword);
      } else {
        yield SearchTextFieldEmpty();
      }
    }
  }
}
