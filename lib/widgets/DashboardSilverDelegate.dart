import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  TextEditingController searchController = TextEditingController();

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  EdgeInsets _standard = EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0);

  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;

    return Container(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              toolbarHeight: 50.0,
              backgroundColor: Palette.themeColor,
              brightness: Brightness.dark,
              /* leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ), */
              elevation: 0.0,
              title: Opacity(
                opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                child: searchCard(),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            right: 20.0,
            left: 20.0,
            bottom: 10.0,
            child: Opacity(
              opacity: percent,
              child: topNameWidget(),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * percent),
                child: Card(
                  elevation: 10.0,
                  shape: Palette.topCardShape,
                  child: Column(
                    children: [
                      searchCard(),
                      Container(
                        child: Text('India'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Widget profileCard() {
    String greetingMes = greetingMessage();
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.all(0),
      shape: Palette.cardShape,
      child: Container(
        margin: _standard * 2,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Text(
                    '$greetingMes',
                    //style: Palette.walletTime,
                  )),
                  SizedBox(height: 3.0),
                  Container(
                      child: Text(
                    'Abhi Codes',
                    //style: Palette.walletUserName,
                  ))
                ],
              ),
            ),
            /* Container(
              child: Card(
                elevation: 0,
                shape: Palette.profileShape,
                color: Colors.orange,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: Image.asset(
                    "assets/img/avatar.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ) */
          ],
        ),
      ),
    );
  }

  Widget searchCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: Palette.seachBoxCardShape,
      child: TextField(
        controller: searchController,
        keyboardType: TextInputType.name,
        autocorrect: true,
        style: TextStyle(fontSize: 14.0, decoration: TextDecoration.none),
        onChanged: (value) {
          debugPrint('Something changed in Lead Name Text Field');
          //updateLeadName();
        },
        decoration: InputDecoration(
          //labelText: 'Lead Name',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Search Projects, Localities, Cities etc.',
          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget topNameWidget() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Container(
              child: Text(
                'Hi there',
                style: Palette.whiteHeader,
              ),
            )
          ],
        ))
      ],
    );
  }
}
