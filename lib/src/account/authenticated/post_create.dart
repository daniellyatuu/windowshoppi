import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class PostCreate extends StatefulWidget {
  @override
  _PostCreateState createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  final _postFormKey = GlobalKey<FormState>();
  String _postCaptionText;

  Widget _buildPostCaption() {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            child: Icon(Icons.account_circle, color: Colors.grey[300]),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Write Caption...',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'caption is required';
              }
              return null;
            },
            onSaved: (value) => _postCaptionText = value,
          ),
        ),
      ],
    );
  }

  void _notification(String txt, Color bgColor, Color btnColor) {
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSelectionBloc, ImageSelectionStates>(
      builder: (context, state) {
        if (state is ImageSelected) {
          var data = state.resultList;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => BlocProvider.of<ImageSelectionBloc>(context)
                  ..add(ClearImage(resultList: data)),
                icon: Icon(Icons.clear),
              ),
              title: Text('new post'),
              actions: <Widget>[
                BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                    builder: (context, state) {
                  if (state is IsAuthenticated) {
                    return BlocListener<CreatePostBloc, CreatePostStates>(
                      listener: (context, state) {
                        print('CREATE POST LISTENER $state');
                        if (state is CreatePostSubmitting) {
                          return showDialog(
                            barrierDismissible: false,
                            useRootNavigator: false,
                            context: context,
                            builder: (dialogContext) => Material(
                              type: MaterialType.transparency,
                              child: Center(
                                // Aligns the container to center
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Posting..',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (state is CreatePostError) {
                          Navigator.of(context).pop();
                          _notification('Error occurred, please try again.',
                              Colors.red, Colors.white);
                        } else if (state is CreatePostSuccess) {
                          Navigator.of(context).pop();

                          // add post
                          BlocProvider.of<UserPostBloc>(context)
                            ..add(UserPostInsert(post: state.post));

                          // remove selected image
                          BlocProvider.of<ImageSelectionBloc>(context)
                            ..add(ClearImage(resultList: data));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () async {
                            print('save post in here');
                            if (_postFormKey.currentState.validate()) {
                              _postFormKey.currentState.save();

                              FocusScope.of(context).requestFocus(FocusNode());

                              print(_postCaptionText);
                              print(data);

                              BlocProvider.of<CreatePostBloc>(context)
                                ..add(
                                  CreatePost(
                                    accountId: state.user.accountId,
                                    caption: _postCaptionText,
                                    resultList: data,
                                  ),
                                );
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                'POST ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Icon(Icons.send, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
            body: Center(
              child: Form(
                key: _postFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: <Widget>[
                      _buildPostCaption(),
                      Divider(),
                      Container(
                        child: GridView.count(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: List.generate(
                            data.length,
                            (index) {
                              Asset asset = data[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: AssetThumb(
                                  asset: asset,
                                  width: 300,
                                  height: 300,
                                  spinner: Center(
                                    child: SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is ImageError) {
          return Center(
            child: Text(
              '${state.error}',
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
