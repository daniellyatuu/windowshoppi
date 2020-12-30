import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/location/flutter_google_places.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PostCreate extends StatefulWidget {
  @override
  _PostCreateState createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
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
      print(_activeLocation);
      print(latitude);
      print(longitude);
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }
  // LOCATION .END

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
            key: homeScaffoldKey,
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
                          Navigator.of(context, rootNavigator: true).pop();
                          _notification('Error occurred, please try again.',
                              Colors.red, Colors.white);
                        } else if (state is CreatePostSuccess) {
                          Navigator.of(context, rootNavigator: true).pop();

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
                            if (_postFormKey.currentState.validate()) {
                              _postFormKey.currentState.save();

                              FocusScope.of(context).requestFocus(FocusNode());

                              print(_postCaptionText);
                              print(_activeLocation);
                              print(latitude);
                              print(longitude);
                              print(data);

                              BlocProvider.of<CreatePostBloc>(context)
                                ..add(
                                  CreatePost(
                                    accountId: state.user.accountId,
                                    caption: _postCaptionText,
                                    location: _activeLocation,
                                    lat: latitude,
                                    long: longitude,
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
                      _buildPostTagLocation(),
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
