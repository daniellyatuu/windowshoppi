import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:windowshoppi/src/location/flutter_google_places.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/google_location/google_location_files.dart';
import 'package:windowshoppi/api.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

// // to get places detail (lat/lng)
// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CreateRecommendPage extends StatefulWidget {
  final String name;
  final int recommendationType;
  CreateRecommendPage({@required this.name, @required this.recommendationType});

  @override
  _CreateRecommendPageState createState() => _CreateRecommendPageState();
}

class _CreateRecommendPageState extends State<CreateRecommendPage> {
  final _recommendFormKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final _locationTextFieldController = TextEditingController();

  bool _searchLocation = false;

  String _recommendedName;
  String _recommendedCaptionText;
  String _phoneNumber;
  bool _showButtonSelection = false;
  String _url = '';
  String _link;
  String _buttonSelected = 'visit';
  bool _linkError = false;
  bool _noImage = false;

  PhoneNumber number = PhoneNumber(isoCode: 'TZ');
  String _enteredPhoneNumber;
  String _selectedIsoCode;
  String _selectedDialCode;

  // for location
  String _activeLocation;
  double latitude, longitude;

  Widget _buildRecommendedName() {
    return Row(
      children: <Widget>[
        // Icon(Icons.drive_file_rename_outline, size: 30, color: Colors.grey),
        // SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              prefixIcon: Icon(LineAwesomeIcons.product_hunt),
              labelText: 'Name of ${widget.name}*',
              labelStyle: TextStyle(
                color: Colors.grey[700],
                // fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: Colors.grey[700],
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onSaved: (value) => _recommendedName = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendCaption() {
    return Row(
      children: <Widget>[
        // BlocBuilder<AuthenticationBloc, AuthenticationStates>(
        //   builder: (context, state) {
        //     if (state is IsAuthenticated) {
        //       return Container(
        //         width: 30,
        //         height: 30,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[200],
        //           shape: BoxShape.circle,
        //         ),
        //         child: state.user.profileImage == null
        //             ? FittedBox(
        //                 child:
        //                     Icon(Icons.account_circle, color: Colors.grey[400]),
        //               )
        //             : ClipOval(
        //                 child: ExtendedImage.network(
        //                   '${state.user.profileImage}',
        //                   cache: true,
        //                   loadStateChanged: (ExtendedImageState state) {
        //                     switch (state.extendedImageLoadState) {
        //                       case LoadState.loading:
        //                         return FittedBox(
        //                           child: Icon(Icons.account_circle,
        //                               color: Colors.grey[400]),
        //                         );
        //                         break;
        //
        //                       ///if you don't want override completed widget
        //                       ///please return null or state.completedWidget
        //                       //return null;
        //                       //return state.completedWidget;
        //                       case LoadState.completed:
        //                         return ExtendedRawImage(
        //                           fit: BoxFit.cover,
        //                           image: state.extendedImageInfo?.image,
        //                         );
        //                         break;
        //                       case LoadState.failed:
        //                         // _controller.reset();
        //                         return GestureDetector(
        //                           child: Center(
        //                             child: Icon(Icons.refresh),
        //                           ),
        //                           onTap: () {
        //                             state.reLoadImage();
        //                           },
        //                         );
        //                         break;
        //                     }
        //                     return null;
        //                   },
        //                 ),
        //               ),
        //       );
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
        // SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              prefixIcon: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
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
                              child: Icon(Icons.account_circle,
                                  color: Colors.grey[400]),
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
              labelText: ' Write Caption*',
              labelStyle: TextStyle(
                color: Colors.grey[700],
                // fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              color: Colors.grey[700],
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onSaved: (value) => _recommendedCaptionText = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationPhotos() {
    return images.length == 0 ? _buildImageSelection() : _buildPostView();
  }

  // #######################
  // images selection .start
  // #######################

  List<Asset> images = [];
  String _error;

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
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

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  // remove images
  _removeImages() {
    setState(() {
      images.clear();
    });
  }

  // #####################
  // images selection .end
  // #####################

  Widget _buildImageSelection() {
    return TextFormField(
      readOnly: true,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        loadAssets();
      },
      decoration: InputDecoration(
        isDense: true,
        // prefixIcon: Icon(Icons.account_circle, color: Colors.black54),
        labelText: 'Choose Photos*',
        prefixIcon: Icon(LineAwesomeIcons.image),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildPostView() {
    return Container(
      child: Stack(
        children: [
          GridView.count(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              images.length,
              (index) {
                Asset asset = images[index];
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
          Positioned(
            top: 3.0,
            right: 6.0,
            child: GestureDetector(
              onTap: () {
                _removeImages();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black.withOpacity(0.6),
                ),
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//   // LOCATION .START
//   void onError(PlacesAutocompleteResponse response) {
//     homeScaffoldKey.currentState.showSnackBar(
//       SnackBar(content: Text(response.errorMessage)),
//     );
//   }
//
//   Future<void> _searchLocation() async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     Prediction p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: onError,
//       mode: Mode.overlay,
// //      mode: _mode,
// //       language: 'en',
// //       components: [Component(Component.country, 'tz')],
//     );
//
//     displayPrediction(p, homeScaffoldKey.currentState);
//   }
//
//   Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//     if (p != null) {
//       // get detail (lat/lng)
//       PlacesDetailsResponse detail =
//           await _places.getDetailsByPlaceId(p.placeId);
//       final lat = detail.result.geometry.location.lat;
//       final lng = detail.result.geometry.location.lng;
//       setState(() {
//         _activeLocation = p.description;
//         latitude = lat.toString();
//         longitude = lng.toString();
//       });
//     }
//   }
//   // LOCATION .END

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InternationalPhoneNumberInput(
          validator: (value) {
            value = value.replaceAll(' ', '');
            String pattern = r'(^(?:[+0]9)?[0-9]{8,15}$)';
            RegExp regExp = new RegExp(pattern);
            if (value.isEmpty) {
              return null;
            } else if (!regExp.hasMatch(value)) {
              return 'Please enter valid phone number';
            }
            return null;
          },
          inputDecoration: InputDecoration(
            labelText: 'Phone number (option)',
            labelStyle: TextStyle(
              color: Colors.grey[700],
              // fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onInputChanged: (PhoneNumber number) {
            setState(() {
              _enteredPhoneNumber = number.phoneNumber;
              _selectedIsoCode = number.isoCode;
              _selectedDialCode = number.dialCode;
            });
            _phoneNumber =
                _enteredPhoneNumber.replaceFirst('${number.dialCode}', '');
          },
          // onInputValidated: (bool value) {
          //   // print(value);
          // },
          // onSaved: (value) => _phoneNumber = _enteredPhoneNumber,
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: number,
          inputBorder: OutlineInputBorder(),
        ),
        if (_enteredPhoneNumber != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_enteredPhoneNumber',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
      ],
    );
  }

  // Widget _buildPostTagLocation() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: FlatButton(
  //           padding: EdgeInsets.zero,
  //           onPressed: () {
  //             FocusScope.of(context).requestFocus(FocusNode());
  //             _searchLocation();
  //           },
  //           child: Row(
  //             children: <Widget>[
  //               Icon(Icons.location_on_outlined, size: 30, color: Colors.grey),
  //               SizedBox(width: 10.0),
  //               Expanded(
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(vertical: 8.0),
  //                   child: _activeLocation != null
  //                       ? Text(
  //                           _activeLocation,
  //                           style: TextStyle(
  //                             color: Colors.grey[700],
  //                           ),
  //                         )
  //                       : Text(
  //                           'Add Location (option)',
  //                           style: TextStyle(
  //                             color: Colors.grey[700],
  //                             fontSize: 16.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       if (_activeLocation != null)
  //         IconButton(
  //           onPressed: () {
  //             setState(() {
  //               _activeLocation = null;
  //               latitude = null;
  //               longitude = null;
  //             });
  //           },
  //           icon: Icon(Icons.clear),
  //           color: Colors.black54,
  //         ),
  //     ],
  //   );
  // }

  Widget _buildLocationTF() {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: () async {
            // generate a new token here
            final sessionToken = Uuid().v4();
            final Suggestion result = await showSearch(
              context: context,
              delegate: AddressSearch(sessionToken),
            );

            // This will change the text displayed in the TextField
            print(result);
            if (result != null) {
              print('GET RESULT IN HERE');
              setState(() {
                _searchLocation = true;
              });
              final placeDetails = await PlaceApiProvider(sessionToken)
                  .getPlaceDetailFromId(result.placeId);
              setState(() {
                _searchLocation = false;
              });

              setState(() {
                _locationTextFieldController.text = result.description;
                _activeLocation = result.description;
                latitude = placeDetails.lat;
                longitude = placeDetails.lng;
              });
            }
          },
          controller: _locationTextFieldController,
          decoration: InputDecoration(
            isDense: true,
            // prefixIcon: Icon(Icons.account_circle, color: Colors.black54),
            labelText: 'Add Location (option)',

            prefixIcon: _searchLocation
                ? CupertinoActivityIndicator()
                : Icon(LineAwesomeIcons.map_marker),
            border: OutlineInputBorder(),
          ),
          // validator: (value) {
          //   if (value.isEmpty) {
          //     return 'Pharmacy location is required';
          //   }
          //   return null;
          // },
        ),
        // if (_lat != null && _lng != null)
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Text(
        //           'lat:$_lat',
        //           style: Theme.of(context).textTheme.caption,
        //         ),
        //       ),
        //       Expanded(
        //         child: Align(
        //           alignment: Alignment.centerRight,
        //           child: Text(
        //             'lng:$_lng',
        //             style: Theme.of(context).textTheme.caption,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
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
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(LineAwesomeIcons.link),
                          labelText: 'Add Link (option)',
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            // fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(),
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
                          title: Text('Learn More'),
                          value: 'learn more',
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

  Widget _divider() {
    return SizedBox(
      height: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('Recommend ${widget.name}'.capitalizeFirstofEach),
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
                        builder: (dialogContext) => WillPopScope(
                          onWillPop: () async => false,
                          child: Material(
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

                      BlocProvider.of<AuthPostBloc>(context)
                        ..add(AuthAllPostInsert(post: state.post));

                      // Increment Added Post
                      BlocProvider.of<AccountInfoBloc>(context)
                        ..add(IncrementPostNo());

                      // close create post page
                      Navigator.of(context).pop();

                      //close cupertino action sheet
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_recommendFormKey.currentState.validate()) {
                          _recommendFormKey.currentState.save();

                          // VALIDATION
                          if (images.length == 0) {
                            setState(() {
                              _noImage = true;
                            });
                          }

                          // validate link
                          if (_link != '') {
                            bool _validURL = Uri.parse(_link).isAbsolute;

                            if (_validURL == false) {
                              setState(() {
                                _linkError = true;
                              });
                            }
                          }

                          if (images.length != 0 && _linkError == false) {
                            FocusScope.of(context).requestFocus(FocusNode());

                            BlocProvider.of<CreatePostBloc>(context)
                              ..add(
                                CreateRecommendationPost(
                                  accountId: state.user.accountId,
                                  caption: _recommendedCaptionText,
                                  recommendationName: _recommendedName,
                                  recommendationType: widget.recommendationType,
                                  recommendationPhoneIsoCode: _selectedIsoCode,
                                  recommendationPhoneDialCode:
                                      _selectedDialCode,
                                  recommendationPhoneNumber: _phoneNumber,
                                  location: _activeLocation,
                                  lat: latitude.toString(),
                                  long: longitude.toString(),
                                  url: _link,
                                  urlText: _buttonSelected,
                                  resultList: images,
                                  postType: 2,
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
      body: Form(
        key: _recommendFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                _divider(),
                _buildRecommendedName(),
                _divider(),
                _buildRecommendCaption(),
                _divider(),
                _buildRecommendationPhotos(),
                _divider(),
                _buildPhoneNumberTF(),
                _divider(),
                _buildLocationTF(),
                // _buildPostTagLocation(),
                // _buildPostView(),
                // Divider(),
                // _buildPostTagLocation(),
                _divider(),
                _buildAddLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
