import 'package:collage_creator_web_app/collage_creator/collage_creator.dart';

class CollagePreview extends StatefulWidget {
  final List<Uint8List> images;
  final CollageMode mode;
  final Color bgColor;
  final Uint8List? bgImage;
  final CollageShape shape;
  final String orientation;
  final String largeImagePosition;
  final bool showBorders;
  final double borderWidth;
  final Color borderColor;
  final GlobalKey collageKey;

  const CollagePreview({
    super.key,
    required this.images,
    required this.mode,
    required this.bgColor,
    this.bgImage,
    required this.shape,
    required this.orientation,
    required this.largeImagePosition,
    required this.showBorders,
    required this.borderWidth,
    required this.borderColor,
    required this.collageKey,
  });

  @override
  State<StatefulWidget> createState() => _CollagePreviewState();
}

class _CollagePreviewState extends State<CollagePreview> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildExpandedImageWidget(
    Uint8List img, {
    bool top = true,
    bool right = true,
    bool bottom = true,
    bool left = true,
  }) {
    return SizedBox.expand(
      child: buildImageWithBorder(
        img,
        widget.bgColor,
        widget.showBorders,
        widget.borderColor,
        widget.borderWidth,
        bgImage: widget.bgImage,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
    );
  }

  Widget _buildGridCollage() {
    if (widget.images.length < 2) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          height: 800,
          width: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              getSmallHeaderText(pickAtLeastOneImgTxt),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    if (widget.images.length == 2 &&
        widget.orientation == verticalOrientation) {
      return Column(
        children: [
          Expanded(
            child: buildExpandedImageWidget(widget.images[0], bottom: false),
          ),
          Expanded(
            child: buildExpandedImageWidget(widget.images[1], top: false),
          ),
        ],
      );
    }

    if (widget.images.length == 3 &&
        widget.orientation == verticalOrientation) {
      if (widget.largeImagePosition == startImagePosition) {
        return Row(
          children: [
            Expanded(
              child: buildExpandedImageWidget(widget.images[0], right: false),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[1],
                      left: false,
                      bottom: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[2],
                      left: false,
                      top: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[0],
                      right: false,
                      bottom: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[1],
                      right: false,
                      top: false,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: buildExpandedImageWidget(widget.images[2], left: false),
            ),
          ],
        );
      }
    }

    if (widget.images.length == 5 &&
        widget.orientation == verticalOrientation) {
      if (widget.largeImagePosition == startImagePosition) {
        return Row(
          children: [
            Expanded(
              child: buildExpandedImageWidget(widget.images[0], right: false),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[1],
                            left: false,
                            right: false,
                            bottom: false,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[2],
                            left: false,
                            bottom: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[3],
                            left: false,
                            right: false,
                            top: false,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[4],
                            left: false,
                            top: false,
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
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[0],
                            right: false,
                            bottom: false,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[1],
                            left: false,
                            right: false,
                            bottom: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[2],
                            right: false,
                            top: false,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildExpandedImageWidget(
                            widget.images[3],
                            left: false,
                            right: false,
                            top: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: buildExpandedImageWidget(widget.images[4], left: false),
            ),
          ],
        );
      }
    }

    if (widget.images.length == 6 &&
        widget.orientation == verticalOrientation) {
      return Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              children: [
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[0],
                    right: false,
                    bottom: false,
                  ),
                ),
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[1],
                    top: false,
                    right: false,
                    bottom: false,
                  ),
                ),
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[2],
                    right: false,
                    top: false,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              children: [
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[3],
                    left: false,
                    bottom: false,
                  ),
                ),
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[4],
                    left: false,
                    bottom: false,
                    top: false,
                  ),
                ),
                Expanded(
                  child: buildExpandedImageWidget(
                    widget.images[5],
                    left: false,
                    top: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    switch (widget.images.length) {
      case 2:
        return Row(
          children: [
            Expanded(
              child: buildExpandedImageWidget(widget.images[0], right: false),
            ),
            Expanded(
              child: buildExpandedImageWidget(widget.images[1], left: false),
            ),
          ],
        );
      case 3:
        if (widget.largeImagePosition == startImagePosition) {
          return Column(
            children: [
              Expanded(
                child: buildExpandedImageWidget(
                  widget.images[0],
                  bottom: false,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: buildExpandedImageWidget(
                        widget.images[1],
                        top: false,
                        right: false,
                      ),
                    ),
                    Expanded(
                      child: buildExpandedImageWidget(
                        widget.images[2],
                        top: false,
                        left: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: buildExpandedImageWidget(
                        widget.images[0],
                        bottom: false,
                        right: false,
                      ),
                    ),
                    Expanded(
                      child: buildExpandedImageWidget(
                        widget.images[1],
                        bottom: false,
                        left: false,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: buildExpandedImageWidget(widget.images[2], top: false),
              ),
            ],
          );
        }
      case 4:
        return GridView.count(
          crossAxisCount: 2,
          children: [
            buildImageWithBorder(
              widget.images[0],
              widget.bgColor,
              widget.showBorders,
              widget.borderColor,
              widget.borderWidth,
              bgImage: widget.bgImage,
              right: false,
              bottom: false,
            ),
            buildImageWithBorder(
              widget.images[1],
              widget.bgColor,
              widget.showBorders,
              widget.borderColor,
              widget.borderWidth,
              bgImage: widget.bgImage,
              left: false,
              bottom: false,
            ),
            buildImageWithBorder(
              widget.images[2],
              widget.bgColor,
              widget.showBorders,
              widget.borderColor,
              widget.borderWidth,
              bgImage: widget.bgImage,
              right: false,
              top: false,
            ),
            buildImageWithBorder(
              widget.images[3],
              widget.bgColor,
              widget.showBorders,
              widget.borderColor,
              widget.borderWidth,
              bgImage: widget.bgImage,
              left: false,
              top: false,
            ),
          ],
        );
      case 5:
        if (widget.largeImagePosition == startImagePosition) {
          return Column(
            children: [
              Expanded(
                child: buildExpandedImageWidget(
                  widget.images[0],
                  bottom: false,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[1],
                              right: false,
                              top: false,
                              bottom: false,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[2],
                              right: false,
                              top: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[3],
                              left: false,
                              top: false,
                              bottom: false,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[4],
                              left: false,
                              top: false,
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
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[0],
                              right: false,
                              bottom: false,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[1],
                              right: false,
                              top: false,
                              bottom: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[2],
                              left: false,
                              bottom: false,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: buildExpandedImageWidget(
                              widget.images[3],
                              left: false,
                              top: false,
                              bottom: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: buildExpandedImageWidget(widget.images[4], top: false),
              ),
            ],
          );
        }
      case 6:
        return Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                children: [
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[0],
                      right: false,
                      bottom: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[1],
                      left: false,
                      right: false,
                      bottom: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[2],
                      left: false,
                      bottom: false,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                children: [
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[3],
                      right: false,
                      top: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[4],
                      left: false,
                      right: false,
                      top: false,
                    ),
                  ),
                  Expanded(
                    child: buildExpandedImageWidget(
                      widget.images[5],
                      left: false,
                      top: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.mode == CollageMode.grid
        ? RepaintBoundary(key: widget.collageKey, child: _buildGridCollage())
        : FreeformCollageCanvas(
          collageKey: widget.collageKey,
          bgColor: widget.bgColor,
          bgImage: widget.bgImage,
          imageBytesList: widget.images,
          collageShape: widget.shape,
        );
  }
}
