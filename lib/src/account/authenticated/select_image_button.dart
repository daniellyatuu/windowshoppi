import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class SelectImageButton extends StatefulWidget {
  @override
  _SelectImageButtonState createState() => _SelectImageButtonState();
}

class _SelectImageButtonState extends State<SelectImageButton> {
  // #######################
  // images selection .start
  // #######################

  List<Asset> _images = List<Asset>();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'NoError';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#F44336",
          actionBarTitle: "Choose Photo",
          statusBarColor: '#B73228',
          allViewTitle: "All Photos",
          useDetailsView: false,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (resultList.length != 0) {
      if (error == 'NoError') {
        BlocProvider.of<ImageSelectionBloc>(context)
          ..add(SelectImage(resultList: resultList, imageUsedFor: 'post'));
      } else {
        BlocProvider.of<ImageSelectionBloc>(context)
          ..add(ImageSelectionError(error: error));
      }
    }
  }

  // #####################
  // images selection .end
  // #####################

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: loadAssets,
      tooltip: 'post a photo',
      child: Icon(Icons.add_box),
    );
  }
}
