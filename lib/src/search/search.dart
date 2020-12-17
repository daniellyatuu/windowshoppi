import 'package:flutter/material.dart';
import 'package:windowshoppi/src/route/fade_transition.dart';
import 'package:windowshoppi/src/search/search_files.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              FadeRoute(
                widget: SearchViewInit(),
              ),
            );
          },
          icon: Icon(
            Icons.search,
            size: 25.0,
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 255, 255, 255),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  widget: SearchViewInit(),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: AbsorbPointer(
                    absorbing: true,
                    child: TextField(
                      autofocus: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(
              widget: SearchViewInit(),
            ),
          );
        },
        child: SearchWelcomeText(txt: 'Search'),
      ),
    );
  }
}

class SearchWelcomeText extends StatelessWidget {
  final String txt;
  SearchWelcomeText({this.txt = 'Search'}) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300], width: 10.0),
                // borderRadius: BorderRadius.circular(8.0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_outlined,
                color: Colors.grey[300],
                size: 100,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  '$txt',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Discover new ideas to try.',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
