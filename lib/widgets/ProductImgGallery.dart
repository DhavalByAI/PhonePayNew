import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductImgGallery extends StatefulWidget {
  final int selectedIndex;
  final String imageBaseURL;
  final List productImgs;
  ProductImgGallery(this.selectedIndex, this.imageBaseURL, this.productImgs);

  @override
  State<StatefulWidget> createState() => _ProductImgGalleryState(
      this.selectedIndex, this.imageBaseURL, this.productImgs);
}

class _ProductImgGalleryState extends State<ProductImgGallery> {
  int selectedIndex;
  String imageBaseURL;
  List productImgs;

  _ProductImgGalleryState(
      this.selectedIndex, this.imageBaseURL, this.productImgs);

  int _currentIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage('$imageBaseURL/${productImgs[index]}'),
            initialScale: PhotoViewComputedScale.contained * 1,
            //heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
          );
        },
        itemCount: productImgs.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        //backgroundDecoration: widget.backgroundDecoration,
        pageController: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
