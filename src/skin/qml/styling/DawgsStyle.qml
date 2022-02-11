pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQml 2.15

import "qrc:/qml_components"
//-----------------------------------------------------------------------------
// Styling used through out the App. This also allows us to "hot" swap colors.
//
// useful Links:
//
//   Known system color Constants and values:
//   https://doc.qt.io/qt-5/qml-color.html
//
//   Animations:
//   https://doc.qt.io/archives/qt-5.9/qtquick-animation-example.html
//   https://doc.qt.io/qt-5/qtquick-statesanimations-animations.html
//
//   Color:
//   https://doc.qt.io/qt-5/qml-color.html
//
//   Behavours:
//   https://doc.qt.io/qt-5/qtquick-statesanimations-behaviors.html
//
//   Gradients:
//   https://doc.qt.io/qt-5/qml-qtquick-gradient.html
//
//   Default Font:
//   https://stackoverflow.com/questions/42041482/change-default-application-font
//
//  Qt5 to Qt6 Notes:
//
//  QtGraphicalEffects replaced with:
//   Qt5Compact  ->  QtQuick.MultiEffect
//   Qt6 -> Qt5Compat.GraphicalEffects
//
//  TreeView requires a seperate license.
//
//-----------------------------------------------------------------------------
// DawgsStyle.qml
//-----------------------------------------------------------------------------
QtObject {
  id: styleRoot
  // The current QML UIUX version/revision number:
  property int qml_release_version: 2
  // App Window name:
  property string qml_app_name: "SpaceDawgs Wallet"
  // Enable NFC UI components: TODO auto detection.
  property bool has_nfc_device: false
  // Enable QR code camera scanning UI components: TODO auto detection.
  property bool has_qrCode_scanner: false
	// Enable token searching for ablility to add assets to the wallet.
	property bool can_search_tokens: false
  // Enable OT Exchange UI components: TODO bugzilla#34
  property bool ot_exchanges: false
  //----------------------
  //debugger:
  // Skipping Splash Startup?
  property bool qml_skip_splash: false
  // On splash complete, override default navigation to debug a QML view:
  //"pages/existingusers/dashboard.qml" "pages/dawgs_component_test.qml" "pages/onboardingflow/onboard_card_frame.qml" 
  property string splash_qml_firstpage: "" // Default: "" *blank* string.
  // On dashboard's first view, display this frame to debug it's view.
  // "dashboard_send_funds" "advanced_wallet_details"
  property string debug_dashboard_frame: "" // Default: "" *blank* string.
  // Set to card start, or leave blank string for default onboarding card navigation.
  //"qrc:/boarding_cards/welcome.qml"
  property string debug_onboard_card: "" // Default: "" *blank* string.
  // Skip pin walls:
  property bool debug_skipPinWalls: false // Default: false
  //-----------------------------------------------------------------------------
  // Margins
  property int horizontalMargin:  12
  property int verticalMargin:    12
  // Commonly used Font Sizes:
  property int fsize_xlarge:  32
  property int fsize_pinnum:  28
  property int fsize_title:   23
  property int fsize_button:  20
  property int fsize_alert:   18
  property int fsize_accent:  16
  property int fsize_normal:  14
  property int fsize_lable:   14
  property int fsize_small:   12
  property int fsize_contex:  10
  //-----------------------------------------------------------------------------
  // Colors used threw out Application"s Dark/Light mode.
  //  Qt.rgba(1,1,1,1.0)
  //
  // Color Value Note **
  //   Hex color values are Alpha first not last. So some colors may be off if
  //   they include an alpha channel in the color value. To fix this, move the alpha
  //   bytes from the last position to the first postition in the byte array.
  //
  //----------------------
  // Button contextual apperance changes:
  readonly property double but_shrink:    1.00  // Shrink scale for button interaction.
  readonly property double but_distrans:  0.50  // When disabled, become this transparent.
  //-----------------------------------------------------------------------------
  // Dawgs Faces: *Default is index 0  "qrc:/assets/faces/"
  readonly property var faceFileNames: [
    "basic", "btc", "daw", "dead", "mad", "smile", "wink"
  ]

  readonly property var faceBGcolors: [
    "#1d9bcd", "#818CF8", "#7ed2c6", "#4cd350", "#17181b", "#d6734c", "#5863d7"
  ]

  //-----------------------------------------------------------------------------
	property var theme_loaded: undefined // Current loaded theme from json source.
  property bool is_darkmode: true      // Theme's 'dark_mode' 'light_mode'
  property string app_theme: "default" // Name of the theme being used.

  // Get current Style for application usage. *Is updated through setting a Theme*
  property color font_color:      "#e9eaf3"
  property color page_bg:         "#0c1921"
  property color norm_bg:         "#122631"
  // Button Type colors
  property color buta_active:     "#6D7AFF" // primary button type.  'Active'
  property color buta_selected:   "#626de4" // primary button activity fill color.
  property color buts_active:     "#f16509" // 'Secondary' button type. activity filler is 'aa_hovered_bg'
  property color but_disabled:    "#aebbc7" // For text, outline as bg becomes transparent.
  // Text colors
  property color but_txtnorm:     "#e9eaf3" // primary text color on buttons.
  property color text_descrip:    "#687B8D" // used for under shadowing the primary text color.
  property color text_accent:     "#6D7AFF" // when there is an accent 'popping' text color.
  // Active Area Highlight, drives most background elements.
  property color aa_norm_ol:      "#2C5065"
  property color aa_selected_ol:  "#6D7AFF"
  property color aa_selected_bg:  "#1a6d7aff"
  property color aa_hovered_bg:   "#800d1921"
  // Alert popup
  property color alert_ol:        "#613838"
  property color alert_bg:        "#d44e4e"
  property color alert_txt:       "#e9eaf3"
  //----------------------
  // Change the current theme used. What applys the color values.
  function change_theme(new_theme_uri, is_local = true, startup = false) {
    // debugger:
    //console.log("Loading Style:", new_theme_uri, is_local, startup)
    // is the new theme local or a remote .json file
		var success = false
    if (is_local) {
      success = styleRoot.local_theme(new_theme_uri)
    } else {
      success = styleRoot.remote_theme(new_theme_uri)
    }
		if (success === false) {
			console.log("StyleRoot, unable to change theme.", new_theme_uri, is_local)
			return
		}
    // set new_theme to current_theme
    styleRoot.app_theme = new_theme_uri
    // save current theme in UIUX persistant cache store
    if (startup === false) {
      UIUX_UserCache.changeData('currentThemeURI', styleRoot.new_theme_uri, false)
			if (is_local) {
				UIUX_UserCache.changeData('remoteThemeCached', {}, false)
			} else {
				UIUX_UserCache.changeData('remoteThemeCached', styleRoot.theme_loaded, false)
			}
			UIUX_UserCache.changeData('themeDarkmode', styleRoot.is_darkmode, true)
    }
  }

	//----------------------
	// Loads the last theme setting from UIUX cache.
	function load_cached_theme() {

    //TODO: finish remote theme support.
		var is_remote_theme = false //(UIUX_UserCache.data.remoteThemeCached !== undefined)
		// debugger:
    //console.log("Initializing startup theme variables:", is_remote_theme)
		//QML_Debugger.listEverything(UIUX_UserCache.data.remoteThemeCached)
    
		styleRoot.is_darkmode = UIUX_UserCache.data.themeDarkmode
		// loading local or using a remote theme from cache?
		if (is_remote_theme) {
			styleRoot.theme_loaded = UIUX_UserCache.data.remoteThemeCached
			styleRoot.app_theme = UIUX_UserCache.data.currentThemeURI
			styleRoot.set_theme_colors()
		} else {
			styleRoot.local_theme(UIUX_UserCache.data.currentThemeURI)
		}
	}

	//----------------------
	// Retrives a remote theme .json file and caches it locally.
	function remote_theme(theme_uri) {
		console.log("Error: styleRoot does not load remote files yet.")
		return false
	}

  //----------------------
  // Loads a theme from json file, puts the converted object into styleRoot variable space.
  function local_theme(theme_name) {
    // debugger:
    //console.log("Loading local Style theme:", theme_name)
    // load the inlcuded local qrc theme file
    var fileDir = "qrc:/local-themes/" + theme_name
    var rawFile = new XMLHttpRequest()
    //rawFile.overrideMimeType("application/json")
    rawFile.open("GET", fileDir)
    // async file read:
    rawFile.onreadystatechange = function () {
      if (rawFile.readyState == XMLHttpRequest.DONE) {
        styleRoot.theme_loaded = JSON.parse(rawFile.responseText)
        styleRoot.set_theme_colors()
        // debugger:
        //console.log("local style theme loaded:")
        //QML_Debugger.listProperties(styleRoot.theme_loaded)
				return true
      }
    }
    // load file error net
    rawFile.onerror = function () {
      console.log("Error: Style theme local file not found.", theme_name)
			return false
    }
    rawFile.send(null)
  }

  //----------------------
  // Sets the theme variables to match loaded theme .json:
  function set_theme_colors() {
    if (styleRoot.theme_loaded === undefined) {
      console.log("Error: There is no loaded theme json object.")
      return
    }
    // light/dark display modes
		var mode_style = undefined
    if (styleRoot.is_darkmode) {
      mode_style = theme_loaded.dark_mode
    } else {
      mode_style = theme_loaded.light_mode
    }
    // apply colors, ensures a color is defined before attempting to apply
    styleRoot.page_bg        = mode_style.page_bg !== undefined ? mode_style.page_bg : "#e9eaf3"
    styleRoot.norm_bg        = mode_style.norm_bg !== undefined ? mode_style.norm_bg : "#0c1921"
    styleRoot.font_color     = mode_style.plain_text !== undefined ? mode_style.plain_text : "#122631"
    styleRoot.buta_active    = mode_style.buta_active !== undefined ? mode_style.buta_active : "#6D7AFF"
    styleRoot.buta_selected  = mode_style.buta_selected !== undefined ? mode_style.buta_selected : "#626de4"
    styleRoot.buts_active    = mode_style.buts_active !== undefined ? mode_style.buts_active : "#f16509"
    styleRoot.but_disabled   = mode_style.but_disabled !== undefined ? mode_style.but_disabled : "#aebbc7"
    styleRoot.but_txtnorm    = mode_style.but_txtnorm !== undefined ? mode_style.but_txtnorm : "#e9eaf3"
    styleRoot.aa_norm_ol     = mode_style.aa_norm_ol !== undefined ? mode_style.aa_norm_ol : "#2C5065"
    styleRoot.aa_selected_ol = mode_style.aa_selected_ol !== undefined ? mode_style.aa_selected_ol : "#6D7AFF"
    styleRoot.aa_selected_bg = mode_style.aa_selected_bg !== undefined ? mode_style.aa_selected_bg : "#1a6d7aff"
    styleRoot.aa_hovered_bg  = mode_style.aa_hovered_bg !== undefined ? mode_style.aa_hovered_bg : "#800d1921"
    styleRoot.alert_ol       = mode_style.alert_ol !== undefined ? mode_style.alert_ol : "#d44e4e"
    styleRoot.alert_bg       = mode_style.alert_bg !== undefined ? mode_style.alert_bg : "#613838"
    styleRoot.alert_txt      = mode_style.alert_txt !== undefined ? mode_style.alert_txt : "#e9eaf3"
    //debugger:
    //console.log("Loaded .json theme:", styleRoot.app_theme, " DarkMode:", styleRoot.is_darkmode)
    //console.log("Color Alpha:", styleRoot.aa_hovered_bg.a, theme_loaded.dark_mode.aa_hovered_bg)
  }

	//----------------------
	// Animate the change in theme:
	Behavior on page_bg { ColorAnimation { duration: 700 } }
	Behavior on norm_bg { ColorAnimation { duration: 700 } }
	Behavior on font_color { ColorAnimation { duration: 700 } }
	Behavior on buta_active { ColorAnimation { duration: 700 } }
	Behavior on buta_selected { ColorAnimation { duration: 700 } }
	Behavior on buts_active { ColorAnimation { duration: 700 } }
	Behavior on but_disabled { ColorAnimation { duration: 700 } }
	Behavior on but_txtnorm { ColorAnimation { duration: 700 } }
	Behavior on aa_norm_ol { ColorAnimation { duration: 700 } }
	Behavior on aa_selected_ol { ColorAnimation { duration: 700 } }
	Behavior on aa_selected_bg { ColorAnimation { duration: 700 } }
	Behavior on aa_hovered_bg { ColorAnimation { duration: 700 } }
	Behavior on alert_ol { ColorAnimation { duration: 700 } }
	Behavior on alert_bg { ColorAnimation { duration: 700 } }
	Behavior on alert_txt { ColorAnimation { duration: 700 } }

  //----------------------
  // Watch for OS system changes to theme:
  /*  Note: Platform was removed and added to Qt.labs
  Connections {
    target: Platform

    function onSystemThemeChanged() {
      console.error("ThemeChanged current: ", Platform.systemTheme.mode);
      if (Platform.systemTheme.mode === SystemTheme.Light) {
        styleRoot.set_display_mode("light")
      } else {
        styleRoot.set_display_mode("dark")
      }
    }
  }
  */

	//----------------------
	// Change the theme pallet between dark and light mode:
	function set_display_mode(mode = "dark") {
		styleRoot.is_darkmode = (mode === "dark")
		UIUX_UserCache.changeData('themeDarkmode', styleRoot.is_darkmode, true)
		styleRoot.set_theme_colors()
	}

  // Toggles from light to dark modes for current theme:
  function toggle_display_mode() {
    var new_mode = (styleRoot.is_darkmode ? "light" : "dark")
    styleRoot.set_display_mode(new_mode)
  }

  //----------------------
  // Returns time elapsed since provided timestamp:
  function getElapsedTime(timestamp) {
    var current_time = new Date().getTime()
    // break down the distance in Date() stamping
    var ms_diff = current_time - timestamp
    var sec_diff = ms_diff / 1000
    var min_diff = sec_diff / 60
    var hour_diff = min_diff / 60
    var day_diff = hour_diff / 24
    var week_diff = day_diff / 7
    var year_diff = (current_time - timestamp) / 1000
    year_diff /= (60 * 60 * 24)
    year_diff = Math.abs(Math.round(year_diff/365.25))
    // format the return elapsed string
    if (ms_diff < 1000) {
      return ms_diff + " ms ago"
    } else if (sec_diff < 60 && sec_diff >= 1.0) {
      if (sec_diff > 1.0) return sec_diff.toFixed(1) + " secs ago"
      return sec_diff.round() + " sec ago"
    } else if (min_diff < 60 && min_diff >= 1.0) {
      if (min_diff > 1.0) return min_diff.toFixed(1) + " mins ago"
      return min_diff.round() + " min ago"
    } else if (hour_diff < 60 && hour_diff >= 1.0) {
      if (hour_diff > 1.0) return hour_diff.toFixed(1) + " hours ago"
      return hour_diff + " hour ago"
    } else if (day_diff < 25 && day_diff >= 1.0) {
      if (day_diff > 1.0) return day_diff.toFixed(1) + " days ago"
      return day_diff.round() + " day ago"
    } else if (week_diff < 4 && week_diff >= 1.0) {
      if (week_diff > 1.0) return week_diff.toFixed(1) + " weeks ago"
      return week_diff.round() + " week ago"
    } else if (year_diff < 1.0) {
      return timestamp.toLocaleDateString('en-US', {
          month: 'long'
        });
    } else if (year_diff >= 1.0) {
      return timestamp.toLocaleDateString('en-US', {
        year: 'numeric', month: 'numeric', day: 'numeric'
      });
    } 
    console.log("Time Issue?", timestamp, ms_diff, sec_diff, min_diff, hour_diff, day_diff, week_diff, year_diff)
    return "ts error"
  }

//-----------------------------------------------------------------------------
}//end 'styleRoot' 

