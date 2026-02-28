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
npm ci
npm run package      # produces dist/*.exe or installer
```

`npm start` will launch the un‑packaged Electron app for manual testing.

#### Continuous integration

Two workflows are defined:

* `dart.yml` – performs `flutter pub get`, `dart analyze` and `dart test`
	using a Flutter SDK >=4.0.0 (bundles Dart 3.7.2+) so that
	`environment.sdk: ^3.7.2` in the pubspec resolves correctly.
* `electron-windows.yml` – runs on `windows-latest`, builds the web app
	and then packages it via Electron, uploading the resulting `.exe` as
	an artifact.

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

## Packaging as a Windows executable via Electron

This repository is primarily a Flutter web app, but you can wrap the
`build/web` output in an Electron shell and create a Windows `.exe` or
installer.  Two workflows are provided:
1. **CI pipeline** – see `.github/workflows/electron-windows.yml`.  It runs on a
	`windows-latest` runner, builds the web application, then invokes an
	Electron project in `electron-app/` to produce the executable.  The
	produced artifact is uploaded for download.

2. **Local build** – you can perform the same steps on your Linux machine
	(Wine is required for Windows packaging):

	```bash
	# 1. build the web app with Flutter (still on 3.7.2 or later)
	flutter pub get
	flutter build web --release

	# 2. enter the Electron project
	cd electron-app
	npm ci                # installs electron & electron-builder

	# 3. package for Windows; electron-builder will spawn Wine on Linux
	npm run package       # produces `dist/*.exe` or installer
	```

	If you just want to run the app locally without packaging, use
	`npm start` after the web build step.

	> On Linux the Windows build step requires Wine installed and
	> accessible in your `$PATH`.  Electron-builder will warn if Wine is
	> missing.

	The `electron-app` directory contains `main.js` (loads
	`../build/web/index.html`) and a minimal `package.json` with the
	appropriate `electron-builder` configuration.

Feel free to tweak the `electron-app/build` section to adjust installer
options, targets, or the application ID.