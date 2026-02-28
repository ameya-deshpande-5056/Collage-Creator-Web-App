const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1024,
    height: 768,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
    }
  });

  // load the Flutter web build output
  // When we run `electron .` during development the web build lives in
  // `../build/web` relative to this file.  After packaging however the entire
  // contents of the `electron-app` directory (including the web build) are
  // bundled into an ASAR archive under `resources/app.asar`.  At runtime
  // `__dirname` points _inside_ that archive, so attempting to climb out with
  // `..` results in a path under `resources/` which is outside the sandbox and
  // will be rejected with "Not allowed to load local resource" (exactly what
  // you saw when you installed the `.deb`).
  //
  // To support both scenarios we compute the path differently depending on
  // whether the app is packaged.
  let indexPath;
  if (app.isPackaged) {
    // packaged: the web build is located inside the ASAR under `build/web`
    indexPath = path.join(__dirname, 'build', 'web', 'index.html');
  } else {
    // development: still outside the ASAR
    indexPath = path.join(__dirname, '..', 'build', 'web', 'index.html');
  }
  win.loadFile(indexPath);
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
