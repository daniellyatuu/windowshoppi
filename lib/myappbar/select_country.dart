import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/utilities/database_helper.dart';

class SelectCountry extends StatefulWidget {
  final VoidCallback onCountryChanged;
  final Function(String) countryIos2;
  SelectCountry({@required this.onCountryChanged, @required this.countryIos2});

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final dbHelper = DatabaseHelper.instance;

  var country = new List<Country>();
  var activeCountry = '';
  var activeFlag = '';
  var activeIos2 = '';
  bool _activeCountryLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // get countries
    _fetchCountry();
  }

  Future _fetchCountry() async {
//    print('step 1: start get country');

    /// check if country data available on local
    final allRows = await dbHelper.queryAllRows();
    if (allRows.length == 0) {
//      print('step 3: get countries from server');
      final response = await http.get(ALL_COUNTRY_URL);
      print(response.body);
      if (response.statusCode == 200) {
        var countryData = json.decode(response.body);

        // save data locally

        await _insert(countryData);
//        print('step 10: after insert data user model');
//        print('##############');
        _activeCountry();

        setState(() {
          Iterable list = countryData;
          country = list.map((model) => Country.fromJson(model)).toList();
        });
      } else {
        throw Exception('failed to load data from internet');
      }
    } else {
      //execute shared preference in here

//      print('step 3: insert countries from local db to variable list');
      setState(() {
        Iterable list = allRows;
        country = list.map((model) => Country.fromJson(model)).toList();
      });
      _activeCountry();
    }
  }

  _insert(data) async {
//    print('step 4: save all country data from server');
    var savedId = await dbHelper.insertCountryData(data);
//    print('step 6: receive saved ids');

//    print('step 7: save first id to user table');
    await _insertUser(savedId[0]);
  }

  _insertUser(data) async {
    // user data
    Map<String, dynamic> row = {
      DatabaseHelper.table_1ColumnName: 'username',
      DatabaseHelper.table_1ColumnCountryId: data
    };
//    print('step 8: pass userdata to db');
    await dbHelper.insertUserData(row);
  }

  void _activeCountry() async {
//    print('step 4: get active country');
    setState(() {
      _activeCountryLoading = true;
    });
    var activeCountryData = await dbHelper.getActiveCountryFromUserTable();
//    print('step 8: receive active country ##LAST STEP##');

    setState(() {
      if (activeCountryData != null) {
        activeCountry = activeCountryData['name'];
        activeFlag = activeCountryData['flag'];
        activeIos2 = activeCountryData['ios2'];
      }
      _activeCountryLoading = false;
    });

    widget.countryIos2(activeIos2);
  }

  _changeCountry(id) async {
//    print('step 1: change country');
    var result = await dbHelper.getCountry2(id);
//    print('step 6: received changed result');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _activeCountryLoading ? true : false,
      child: GestureDetector(
        onTap: () async {
          var selectedCountry = await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Select country',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: country.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.grey[100],
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pop(
                                    activeCountry == country[index].countryName
                                        ? null
                                        : {
                                            'id': country[index].id,
                                            'name': country[index].countryName,
                                            'iso2': country[index].ios2,
                                            'flag': country[index].flag,
                                          },
                                  );
                                },
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '${country[index].flag}',
                                  ),
                                ),
                                title: Text(
                                  country[index].countryName,
                                  style: activeCountry ==
                                          country[index].countryName
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : null,
                                ),
                                trailing:
                                    activeCountry == country[index].countryName
                                        ? Icon(Icons.check)
                                        : Text(''),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          widget.onCountryChanged();
          if (selectedCountry != null) {
            setState(() {
              _activeCountryLoading = true;
            });
            var res = await _changeCountry(selectedCountry['id']);

            setState(() {
              _activeCountryLoading = false;
              if (res == true) {
                activeCountry = selectedCountry['name'];
                activeFlag = selectedCountry['flag'];
                activeIos2 = selectedCountry['iso2'];
              }
            });

            // return notification to reload active page

            widget.onCountryChanged();
            widget.countryIos2(activeIos2);
//            print('after finish change country');
//            print(res);
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 25,
                width: 25,
                child: _activeCountryLoading
                    ? Text('')
                    : activeFlag != ''
                        ? ExtendedImage.network(
                            activeFlag,
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
                          )
                        : Text(''),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: AnimatedDefaultTextStyle(
                  style: _activeCountryLoading
                      ? TextStyle(color: Colors.teal)
                      : TextStyle(color: Colors.white),
                  duration: Duration(milliseconds: 400),
                  child: _activeCountryLoading
                      ? Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: CupertinoActivityIndicator(),
                        )
                      : Text('  ' + activeCountry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
