pragma Singleton
import QtQuick 2.0
import Qt.labs.platform 1.1
//-----------------------------------------------------------------------------
// UIUX_UserCache.qml
//
// Maintains the handeling of GUI context settings. This enables UI specific
// persistent instance settings. Ones that stick around for the duration of
// having the app open, and others between application launches.
//
// QStandardPaths:: AppDataLocation  DataLocation  TempLocation  CacheLocation
// AppLocalDataLocation  AppConfigLocation
//
// TODO: on file save for the json settings, this warning apears.
// "XMLHttpRequest: Using PUT on a local file is dangerous and will be disabled 
// by default in a future Qt version.Set QML_XHR_ALLOW_FILE_WRITE to 1 if you 
// wish to continue using this feature."
// This same warning is seen when the 3rd party lotty animation .js script is
// loading a file. Qt5 dropped XHR services.
//-----------------------------------------------------------------------------
QtObject {
  id: uiuxCacheRoot
  readonly property string fileName: "UIUX_Cache.json"

  // Props:
  property bool ready: false  // Is the cache ready to be utilized or not.

  // The current user GUI data loaded. This data is what QML reads from.
  // Changes will be displayed, but are not perminant until save_changes()
  // is called to write data to file.
  property var data: ({})

  signal saved()     // Fired off when cache finishes saving data.
  signal loaded()    // Fired off when cache finishes loading settings from file.
  signal recached()  // Fired off when there was a data change.
  signal error()     // Fired off when there is any error.

  //-----------------------------------------------------------------------------
  // Data only persistent of the App's current running instace.
  property var temp: ({
    lastEnteredPasswordWhen: "",
    createdNewSeed: false
  })
  //----------------------
  // Default UIUX settings:
  readonly property var defaults: ({
    settingVersion:  0.1,        // Version framework used in saving data.
    lastModified:    "",         // Timestamp of last save.
    walletMode:      "soft",     // [soft, hard] wallet seed type.
    currentThemeURI: "default",  // Wallet UI deligate theme.
    themeDarkmode:   true,       // User perfers dark mode over light mode.
    remoteThemeCached: {},       // Remote theme json stored locally.
    spacecardStyle:  "launch",   // Spacecard design.
    spacecardText:   "#e9eaf3",  // Spacecard text color.
    pinLengthMode:   6,          // Perfered pin length.
    avatarBGIndex:   0,          // Local setting for User's displayed Avatar.
    avatarFileIndex: 0           // Local setting for User's displayed Avatar.
  })

  //-----------------------------------------------------------------------------
  // Prep the cache singlton for app useage.
  function start() {
    // check if settings exist
    var file_dir = StandardPaths.standardLocations(StandardPaths.AppDataLocation)
    if (file_dir[0] === undefined) {
      // do nothing special, file_dir is already a string
    } else {
      // use the first index from array if is one
      file_dir = file_dir[0]
    }
    var file_exists = uiuxCacheRoot.does_exist()
    if (file_exists) {
      uiuxCacheRoot.load_existing(true)
    } else {
      // create new if needed
      uiuxCacheRoot.create_new(file_dir + "/" + uiuxCacheRoot.fileName)
    }
    uiuxCacheRoot.ready = true
    console.log("UIUX cache started. Loaded Existing?", file_exists)
  }

  //----------------------
  // Create a new user GUI data cache. Can also be used to reset to Default.
  function create_new(file_dir) {
    for (var prop in uiuxCacheRoot.defaults) {
      if (prop === "lastModified") {
        var date = new Date() //Qt.formatTime(new Date(), "MM ddd hh:mm:ss")
        uiuxCacheRoot.data[prop] = date
      } else {
        uiuxCacheRoot.data[prop] = uiuxCacheRoot.defaults[prop]
      }
    }
    uiuxCacheRoot.save_changes(file_dir)
  }

  //----------------------
  // Check if there is a cache file. If so, return its uri.
  function does_exist() {
    var resolved = StandardPaths.locate(StandardPaths.AppDataLocation, uiuxCacheRoot.fileName)
    resolved = resolved.toString()
    if (resolved.length > 0) {
      return true
    }
    return false
  }

  //----------------------
  // Load an existing user cache.
  function load_existing(startup = false) {
    if (uiuxCacheRoot.ready !== true && startup === false) {
      console.log("Error: UIUX is not ready for file reading.")
      uiuxCacheRoot.error()
      return
    }
    var resolved = StandardPaths.locate(StandardPaths.AppDataLocation, uiuxCacheRoot.fileName)
    resolved = resolved.toString()
    var rawFile = new XMLHttpRequest()
    //rawFile.overrideMimeType("application/json")
    rawFile.open("GET", resolved)
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState == XMLHttpRequest.DONE) {
        uiuxCacheRoot.data = JSON.parse(rawFile.responseText)
        // debugger:
        //console.log("UIUX cache loaded:", uiuxCacheRoot.data)
        //QML_Debugger.listProperties(uiuxCacheRoot.data)
        uiuxCacheRoot.loaded()
      }
    }
    rawFile.onerror = function () {
      console.log("Error: UIUX file wont load.")
      uiuxCacheRoot.error()
    }
    rawFile.send(null);
  }

  //----------------------
  // Saves the 'data' propery to hard file.
  function save_changes(file_dir = "") {
    if (uiuxCacheRoot.ready !== true && file_dir === "") {
      console.log("Error: UIUX is not ready for file saving.")
      uiuxCacheRoot.error()
      return
    }
    if (file_dir === "") {
      file_dir = StandardPaths.locate(StandardPaths.AppDataLocation, uiuxCacheRoot.fileName)
      if (file_dir.length < 1) {
        console.log("Error: UIUX could not save cache.", file_dir)
        uiuxCacheRoot.error()
        return
      }
    }
    var request = new XMLHttpRequest()
    request.open("PUT", file_dir)
    request.onreadystatechange = function () {
      if (request.readyState == XMLHttpRequest.DONE) {
        uiuxCacheRoot.saved()
      }
    }
    request.onerror = function () {
      console.log("Error: UIUX cache can not save:", request.status, file_dir)
      uiuxCacheRoot.error()
    }
    request.send( JSON.stringify(uiuxCacheRoot.data) )
  }

  //-----------------------------------------------------------------------------
  // Update a setting in the file cache.
  function changeData(prop, new_value, save = false) {
    if (uiuxCacheRoot.data[prop] !== undefined) {
      uiuxCacheRoot.data[prop] = new_value
      uiuxCacheRoot.recached()
      if (save === true) {
        uiuxCacheRoot.save_changes()
      }
    } else {
      console.log("Error: UIUX cache does not contain that data key:", prop, new_value)
    }
  }

  //-----------------------------------------------------------------------------
  // Check pin last entered time period from now.
  function hasEnteredPassRecently(newTimeStamp = false) {
    var dateNow = new Date()
    if (newTimeStamp === true) {
      // resetting the pin time stamp
      //console.log("Sat new pin timestamp:", dateNow)
      uiuxCacheRoot.temp.lastEnteredPasswordWhen = dateNow
    } else {
      // has never entered pin before in past
      if (uiuxCacheRoot.temp.lastEnteredPasswordWhen === "") return false;
      // checking the time between last entry
      var lengthBetweenMins = (dateNow - uiuxCacheRoot.temp.lastEnteredPasswordWhen) / 60000
      //console.log("Time in minutes since last pin entry:", lengthBetweenMins)
      // see if last entry time was with in reset window
      if (lengthBetweenMins < 5) {
        return true
      } else {
        // was too long ago
        uiuxCacheRoot.temp.lastEnteredPasswordWhen = ""
      }
    }
    return false
  }

//-----------------------------------------------------------------------------
}//end 'uiuxCacheRoot'