import 'package:windowshoppi/src/location/flutter_google_places.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/api.dart';
import 'package:flutter/material.dart';

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class UpdatePostForm extends StatefulWidget {
  final Post post;
  UpdatePostForm({@required this.post}) : super();
  @override
  _UpdatePostFormState createState() => _UpdatePostFormState();
}

class _UpdatePostFormState extends State<UpdatePostForm> {
  final _postFormKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  String _postCaptionText;

  // for location
  String _activeLocation;
  String latitude, longitude;

  Widget _buildPostCaption() {
    return Row(
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
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
            initialValue: widget.post.caption,
            decoration: InputDecoration(
              hintText: 'Write Caption',
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
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
                    child: Text(
                      _activeLocation ?? 'Tag Location',
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
    }
  }
  // LOCATION .END

  void _notification(String txt, Color bgColor, Color btnColor) {
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _setLocationInitValue() {
    setState(() {
      _activeLocation = widget.post.taggedLocation;
      latitude = widget.post.latitude.toString();
      longitude = widget.post.longitude.toString();
    });
  }

  @override
  void initState() {
    _setLocationInitValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('update post'),
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<ImageSelectionBloc>(context)..add(CheckImage());
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          BlocBuilder<AuthenticationBloc, AuthenticationStates>(
              builder: (context, state) {
            if (state is IsAuthenticated) {
              return BlocListener<UpdatePostBloc, UpdatePostStates>(
                listener: (context, state) {
                  if (state is UpdatePostSubmitting) {
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
                                'Updating..',
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
                  } else if (state is UpdatePostError) {
                    Navigator.of(context, rootNavigator: true).pop();
                    _notification('Error occurred, please try again.',
                        Colors.red, Colors.white);
                  } else if (state is UpdatePostSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();

                    // replace post
                    BlocProvider.of<UserPostBloc>(context)
                      ..add(ReplacePost(
                          prevPost: widget.post, newPost: state.newPost));

                    // remove selected image
                    BlocProvider.of<ImageSelectionBloc>(context)
                      ..add(CheckImage());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (_postFormKey.currentState.validate()) {
                        _postFormKey.currentState.save();

                        FocusScope.of(context).requestFocus(FocusNode());

                        if (_postCaptionText != widget.post.caption ||
                            _activeLocation != widget.post.taggedLocation) {
                          dynamic postData = {
                            'caption': _postCaptionText,
                            'location_name': _activeLocation,
                            'latitude':
                                _activeLocation != null ? latitude : null,
                            'longitude':
                                _activeLocation != null ? longitude : null,
                            'active': true,
                          };

                          BlocProvider.of<UpdatePostBloc>(context)
                            ..add(UpdatePost(
                              postId: widget.post.id,
                              data: postData,
                            ));
                        } else {
                          _notification('Change data and click update',
                              Colors.black, Colors.red);
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          'UPDATE ',
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: widget.post.productPhoto.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ExtendedImage.network(
                          widget.post.productPhoto[index].filename,
                          cache: true,
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return CupertinoActivityIndicator();
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
                      );
                    },
                  ),
                ),
                Divider(),
                _buildPostTagLocation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
