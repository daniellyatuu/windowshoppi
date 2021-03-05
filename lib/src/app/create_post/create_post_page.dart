import 'package:extended_image/extended_image.dart';
import 'package:windowshoppi/src/location/flutter_google_places.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/api.dart';
import 'package:flutter/material.dart';

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CreatePostPage extends StatefulWidget {
  final List<Asset> imageList;
  CreatePostPage({@required this.imageList});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _postFormKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  String _postCaptionText;
  bool _showButtonSelection = false;
  String _url = '';
  String _link;
  String _buttonSelected = 'visit';
  bool _linkError = false;

  // for location
  String _activeLocation;
  String latitude, longitude;

  Widget _buildPostCaption() {
    return Row(
      children: <Widget>[
        BlocBuilder<AuthenticationBloc, AuthenticationStates>(
          builder: (context, state) {
            if (state is IsAuthenticated) {
              return Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: state.user.profileImage == null
                    ? FittedBox(
                        child:
                            Icon(Icons.account_circle, color: Colors.grey[400]),
                      )
                    : ClipOval(
                        child: ExtendedImage.network(
                          '${state.user.profileImage}',
                          cache: true,
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return FittedBox(
                                  child: Icon(Icons.account_circle,
                                      color: Colors.grey[400]),
                                );
                                break;

                              ///if you don't want override completed widget
                              ///please return null or state.completedWidget
                              //return null;
                              //return state.completedWidget;
                              case LoadState.completed:
                                return ExtendedRawImage(
                                  fit: BoxFit.cover,
                                  image: state.extendedImageInfo?.image,
                                );
                                break;
                              case LoadState.failed:
                                // _controller.reset();
                                return GestureDetector(
                                  child: Center(
                                    child: Icon(Icons.refresh),
                                  ),
                                  onTap: () {
                                    state.reLoadImage();
                                  },
                                );
                                break;
                            }
                            return null;
                          },
                        ),
                      ),
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Write Caption*',
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: Colors.grey[700],
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

  Widget _buildPostView() {
    return Container(
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(
          widget.imageList.length,
          (index) {
            Asset asset = widget.imageList[index];
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
    );
  }

  Widget _buildPostTagLocation() {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _searchLocation();
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.location_on_outlined, size: 30, color: Colors.grey),
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: _activeLocation != null
                        ? Text(
                            _activeLocation,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          )
                        : Text(
                            'Add Location (option)',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_activeLocation != null)
          IconButton(
            onPressed: () {
              setState(() {
                _activeLocation = null;
                latitude = null;
                longitude = null;
              });
            },
            icon: Icon(Icons.clear),
            color: Colors.black54,
          ),
      ],
    );
  }

  setSelectedRadio(String val) {
    setState(() {
      _buttonSelected = val;
    });
  }

  Widget _buildAddLink() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: <Widget>[
              Focus(
                onFocusChange: (hasFocus) {
                  int _urlLength = _url.length;

                  setState(() {
                    if (hasFocus) {
                      _showButtonSelection = true;
                    } else {
                      if (_urlLength != 0) {
                        _showButtonSelection = true;
                      } else {
                        _showButtonSelection = false;
                      }
                    }
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_link, size: 30, color: Colors.grey),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Add Link (option)',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                        onChanged: (value) {
                          setState(() {
                            _url = value;

                            if (_linkError == true) _linkError = false;
                          });
                        },
                        onSaved: (value) => _link = value,
                      ),
                    ),
                  ],
                ),
              ),
              if (_linkError)
                Container(
                  margin: EdgeInsets.only(left: 40.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Invalid url',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_showButtonSelection)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Select a button for the link',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          title: Text('Visit'),
                          value: 'visit',
                          groupValue: _buttonSelected,
                          onChanged: (value) {
                            setSelectedRadio(value);
                          },
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          title: Text('Read it'),
                          value: 'read it',
                          groupValue: _buttonSelected,
                          onChanged: (value) {
                            setSelectedRadio(value);
                          },
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          title: Text('Watch it'),
                          value: 'watch it',
                          groupValue: _buttonSelected,
                          onChanged: (value) {
                            setSelectedRadio(value);
                          },
                        ),
                      ),
                      Container(
                        child: RadioListTile(
                          title: Text('Buy'),
                          value: 'buy',
                          groupValue: _buttonSelected,
                          onChanged: (value) {
                            setSelectedRadio(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // LOCATION .START
  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _searchLocation() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
//      mode: _mode,
//       language: 'en',
//       components: [Component(Component.country, 'tz')],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        _activeLocation = p.description;
        latitude = lat.toString();
        longitude = lng.toString();
      });

//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }
  // LOCATION .END

  void _toastNotification(
      String txt, Color color, Toast length, ToastGravity gravity) {
    // close active toast if any before open new one
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        msg: '$txt',
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('new post'),
        actions: <Widget>[
          BlocBuilder<AuthenticationBloc, AuthenticationStates>(
            builder: (context, state) {
              if (state is IsAuthenticated) {
                return BlocListener<CreatePostBloc, CreatePostStates>(
                  listener: (context, state) {
                    if (state is CreatePostSubmitting) {
                      return showDialog(
                        barrierDismissible: false,
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
                    } else if (state is CreatePostNoInternet) {
                      Navigator.of(context, rootNavigator: true).pop();
                      _toastNotification('No internet connection', Colors.red,
                          Toast.LENGTH_SHORT, ToastGravity.CENTER);
                    } else if (state is CreatePostError) {
                      Navigator.of(context, rootNavigator: true).pop();
                      _toastNotification('Error occurred, please try again.',
                          Colors.red, Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
                    } else if (state is CreatePostSuccess) {
                      Navigator.of(context, rootNavigator: true).pop();

                      // add post
                      BlocProvider.of<UserPostBloc>(context)
                        ..add(UserPostInsert(post: state.post));

                      BlocProvider.of<AllPostBloc>(context)
                        ..add(AllPostInsert(post: state.post));

                      // close create post page
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_postFormKey.currentState.validate()) {
                          _postFormKey.currentState.save();

                          // validate link
                          if (_link != '') {
                            bool _validURL = Uri.parse(_link).isAbsolute;

                            print(_validURL);
                            if (_validURL == false) {
                              setState(() {
                                _linkError = true;
                              });
                            }
                          }

                          if (_linkError == false) {
                            FocusScope.of(context).requestFocus(FocusNode());

                            BlocProvider.of<CreatePostBloc>(context)
                              ..add(
                                CreatePost(
                                  accountId: state.user.accountId,
                                  caption: _postCaptionText,
                                  location: _activeLocation,
                                  lat: latitude,
                                  long: longitude,
                                  url: _link,
                                  urlText: _buttonSelected,
                                  resultList: widget.imageList,
                                  postType: 1,
                                ),
                              );
                          }
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
            },
          ),
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
                _buildPostView(),
                Divider(),
                _buildPostTagLocation(),
                Divider(),
                _buildAddLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
