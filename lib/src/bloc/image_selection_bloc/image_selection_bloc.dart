import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class ImageSelectionBloc
    extends Bloc<ImageSelectionEvents, ImageSelectionStates> {
  ImageSelectionBloc() : super(ImageNotSelected());

  @override
  Stream<ImageSelectionStates> mapEventToState(
      ImageSelectionEvents event) async* {
    if (event is CheckImage) {
      yield ImageNotSelected();
    } else if (event is SelectImage) {
      if (event.resultList.length != 0) {
        yield ImageSelected(
            resultList: event.resultList, imageUsedFor: event.imageUsedFor);
      } else {
        yield ImageNotSelected();
      }
    } else if (event is ClearImage) {
      event.resultList.clear();
      yield ImageNotSelected();
    } else if (event is ImageSelectionError) {
      yield ImageError(error: event.error);
    } else if (event is EditPost) {
      yield EditPostActive(post: event.post);
    }
  }
}
