import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  final int index;
  Explore({@required this.index}) : super();

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int maxScrollIndex;
  final _scrollThresholdIndex = 2;

  void _onScroll() {
    final currentScrollIndex =
        itemPositionsListener.itemPositions.value.last.index + 1;

    if (_scrollThresholdIndex >= maxScrollIndex - currentScrollIndex) {
      int _limit = 21;
      if (maxScrollIndex >= _limit) {
        BlocProvider.of<AllPostBloc>(context)
          ..add(AllPostFetched(from: 'explore'));
      }
    }
  }

  Future<void> refresh() async {
    BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
    await Future.delayed(Duration(milliseconds: 700));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollControllerInitiated();
    });
    itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  void _scrollControllerInitiated() {
    itemScrollController.jumpTo(index: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: BlocBuilder<AllPostBloc, AllPostStates>(
        builder: (context, state) {
          if (state is AllPostSuccess) {
            var data = state.posts;
            maxScrollIndex = data.length;

            if (state.posts.isEmpty) {
              return Center(
                child: Text(
                  'No Posts',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: refresh,
              child: ScrollablePositionedList.builder(
                itemCount: state.hasReachedMax ? data.length : data.length + 1,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return index >= data.length
                      ? BottomLoader()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            PostHeader(
                              post: data[index],
                            ),
                            if (data[index].group == 'vendor')
                              if (data[index].businessBio != '')
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(5.0),
                                  color: Colors.black87,
                                  child: ExpandableText(
                                    text: '${data[index].businessBio}',
                                    widgetColor: Colors.white,
                                    textBold: true,
                                    trimLines: 2,
                                    readMore: false,
                                    readLess: false,
                                  ),
                                ),
                            PostImage(
                              postImage: data[index].productPhoto,
                            ),
                            AccountPostCaption(
                              post: data[index],
                            ),
                            Divider(),
                          ],
                        );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
