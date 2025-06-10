const String collageCreatorHeader = 'Collage Creator';
const String addImagesTxt = 'Add images';
const String saveCollageTxt = 'Save collage';
const String previewTxt = 'Preview';
const String noImagesSelectedTxt = "No images selected";
const String pickImagesTxt = 'Pick images';
const String pickAtLeastOneImgTxt =
    "Pick at least 1 more image to create a collage";
const String horizontalOrientation = 'horizontal';
const String verticalOrientation = 'vertical';
const String startImagePosition = 'start';
const String endImagePosition = 'end';
const String horizontalTxt = "Horizontal";
const String verticalTxt = "Vertical";
const String topTxt = "Top";
const String bottomTxt = "Bottom";
const String leftTxt = "Left";
const String rightTxt = "Right";
const String showBordersTxt = 'Show Borders';
const String colorTxt = 'Color:';
const String chooseBorderColorTxt = 'Choose Border Color';
const String okTxt = 'OK';
const String widthTxt = 'Width:';
const String transparentBgPath = 'images/transparent_bg.png';
const String bgTemplate1Path = 'images/bg_template1.jpg';
const String bgTemplate2Path = 'images/bg_template2.jpg';
const String bgTemplate3Path = 'images/bg_template3.jpg';
const String bgTemplate4Path = 'images/bg_template4.jpg';

const List<String> fonts = [
  'Roboto',
  'Arial',
  'Times New Roman',
  'Courier New',
  'Georgia',
  'Verdana',
  'Dancing Script',
];

const List<double> fontSizeOptions = [
  12.0,
  14.0,
  16.0,
  18.0,
  20.0,
  24.0,
  28.0,
  32.0,
  36.0,
  40.0,
  44.0,
  48.0,
  52.0,
  56.0,
  60.0,
  64.0,
  68.0,
  72.0,
];

enum CollageMode { grid, freeform }

enum CollageShape { rectangle, hexagon, circle, mixed }

enum BackgroundOption { none, template1, template2, template3, template4 }

const Map<BackgroundOption, String?> backgroundOptions = {
  BackgroundOption.none: transparentBgPath,
  BackgroundOption.template1: bgTemplate1Path,
  BackgroundOption.template2: bgTemplate2Path,
  BackgroundOption.template3: bgTemplate3Path,
  BackgroundOption.template4: bgTemplate4Path,
};
