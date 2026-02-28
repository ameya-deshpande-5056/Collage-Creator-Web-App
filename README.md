# collage_creator_web_app

[Live Demo — View the app on GitHub Pages](https://ameya-deshpande-5056.github.io/Collage-Creator-Web-App/)

A web application for creating collage, written in Flutter.
This project is a **Flutter web application** that lets users assemble
collages from their own images and export the result as a PNG.  It
also includes an Electron wrapper so the same web build can be
packaged as a standalone Windows executable.

### 🚀 Key features
* Add up to six images from the device camera/gallery
* Switch between **freeform** and **grid** collage modes
* Choose from rectangular/circular/hexagonal shapes
* Reorder images by drag‑and‑drop (grid mode)
* Toggle borders, set border color/width
* Set background color or pick a background image/asset
* Change orientation and large‑image position in grid layouts
* Add text and emojis with resizable, draggable widgets (freeform)
* Live preview and download/export collage as PNG
* Responsive layouts for mobile, tablet and desktop

### 🗂 Code structure

```
lib/
	main.dart                 # entry point
	collage_creator/          # core library exported by collage_creator.dart
		collage_creator.dart    # barrel file with imports/exports
		models/                 # data models (Collage, FreeformItem)
		utils/                  # helpers (image loading, constants)
		screens/                # top-level screen widget
		layouts/                # mobile/tablet/desktop responsive widgets
		widgets/                # reusable UI pieces (grid, canvas, controls)
assets/                     # images, fonts, and background templates
electron-app/               # Electron wrapper project for desktop packaging
	main.js
	package.json             # electron-builder config
.github/workflows/         # CI definitions (analysis, tests, electron build)
```

Files under `collage_creator/widgets` implement the various
controls (border editor, orientation picker, emoji panel) and the
canvas for drawing freeform collages.  `collage_creator/screens` holds
the main screen which wires everything together and maintains `Collage`
state.

### 🛠 Building & running

#### Web (Flutter)

```bash
git clone ... && cd Collage-Creator-Web-App
flutter pub get
flutter run -d chrome            # development
flutter build web --release      # production files in build/web/
```

The app is responsive; use `flutter run -d chrome` in dev mode and
resize the browser to see mobile/tablet/desktop layouts.

#### Windows executable (Electron)

This project includes a minimal Electron app under `electron-app/`
that loads `build/web/index.html`.  After building the web output, run
the following (Wine required on non‑Windows hosts):

```bash
# from project root
flutter build web --release
cd electron-app
npm install
npm run package      # produces dist/*.exe, dist/*.AppImage, dist/*.deb
```

`npm start` will launch the un‑packaged Electron app for manual testing.

#### Linux packages (Electron)

The same Electron setup can also build `.AppImage` and `.deb` packages for Linux:

```bash
flutter build web --release
cd electron-app
npm install
npm run package      # produces .AppImage and .deb files
```

#### Continuous integration

The project uses a unified GitHub Actions workflow (`.github/workflows/electron-build-and-release.yml`) that:
- Builds the web app using Flutter
- Builds Windows executables on `windows-latest`
- Builds Linux packages (AppImage + .deb) on `ubuntu-latest`
- Publishes all binaries to a single GitHub Release

Additionally, `dart.yml` performs `flutter pub get` and `flutter analyze`
using the stable Flutter channel to ensure code quality.

#### Testing

```bash
flutter test            # runs any existing unit/widget tests under /test
```

### 📦 Dependencies

The app uses a few key packages, all declared in `pubspec.yaml`:

* `responsive_builder` – adaptive layouts for different screen sizes
* `reorderable_grid_view` – drag‑and‑drop grid rearrangement
* `flutter_colorpicker` – color picker dialog
* `emoji_picker_flutter` – emoji selection panel
* `image_picker` – access device camera/gallery

Dev dependencies include `flutter_test` and `flutter_lints`.

### 📝 Notes

* The Dart SDK constraint in `pubspec.yaml` is intentionally set to
	`^3.7.2` so that the project requires Dart 3.7.2 or newer.  The
	workflows install a compatible Flutter release.
* The Electron build is optional; you can ignore the `electron-app`
	subdirectory if you only care about the web target.

## Packaging as an Electron executable (Windows & Linux)

This repository is primarily a Flutter web app, but you can wrap the
`build/web` output in an Electron shell to create standalone binaries
for Windows and Linux.

### Automated CI/CD pipeline

A unified GitHub Actions workflow (`.github/workflows/electron-build-and-release.yml`)
automatically:
1. Builds the Flutter web app (`flutter build web --release`)
2. Packages for Windows using Electron (runs on `windows-latest`)
3. Packages for Linux using Electron (runs on `ubuntu-latest`)
4. Creates a single GitHub Release containing all binaries (.exe, .AppImage, .deb)

Releases are created automatically on each push to `main` and tagged with
`release-<run-number>`. You can find them on the **Releases** page.

### Local build

You can perform the same steps on your own machine:

	```bash
	# 1. build the web app with Flutter
	flutter pub get
	flutter build web --release

	# 2. enter the Electron project and build
	cd electron-app
	npm install                # installs electron & electron-builder
	npm run package            # produces dist/*.exe, *.AppImage, *.deb
	```

	If you just want to run the app locally without packaging, use
	`npm start` after the web build step.

	> On Linux, the Windows build step requires Wine installed and
	> accessible in your `$PATH`.  Electron-builder will warn if Wine is
	> missing.

	The `electron-app` directory contains `main.js` (loads
	`../build/web/index.html`) and a `package.json` with the
	`electron-builder` configuration for both Windows and Linux targets.

Feel free to tweak the `electron-app/package.json` `build` section to adjust
installer options, targets, appId, or other Electron settings.

## Downloaded Artifacts

The unified workflow publishes binaries to:
- **GitHub Releases page** – all builds tagged `release-<run-number>` (recommended)
  - Single release contains `.exe`, `.AppImage`, and `.deb` files
- **GitHub Actions artifacts tab** – individual platform artifacts (temporary)
  - Available for 90 days per GitHub's default retention policy
- **GitHub Actions artifacts tab** – latest builds from each workflow run
- **Releases page** – persistent releases tagged `latest-windows` and `latest-linux`
  (updated on each push to `main`)
