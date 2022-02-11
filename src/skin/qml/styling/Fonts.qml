pragma Singleton
import QtQuick 2.0

//-----------------------------------------------------------------------------
// Fonts.qml
// Loads fonts used through out the App so they are pre loaded for use.
//-----------------------------------------------------------------------------
Item {
	id: fonts
	
	// Load the external font files:
	readonly property FontLoader fontAwesomeRegular: FontLoader {
		id: fa_regular
		source: "qrc:/assets/fonts/fontAwesome/FA5-r400.otf"
	}
	readonly property FontLoader fontAwesomeSolid: FontLoader {
		id: fa_solid
		source: "qrc:/assets/fonts/fontAwesome/FA5-s900.otf"
	}
	readonly property FontLoader fontAwesomeBrands: FontLoader {
		id: fa_brands
		source: "qrc:/assets/fonts/fontAwesome/FA5-b400.otf"
	}
	readonly property FontLoader fontSpaceDawgs: FontLoader {
		id: spacedawgs
		source: "qrc:/assets/fonts/spacedawgs/dawgs-wallet-icons.ttf"
	}

	// Fonts not used for only Icons.
	readonly property FontLoader fontHindVadodara: FontLoader {
		id: hindVadodara
		source: "qrc:/assets/fonts/hind-vadodara/HindVadodara-Regular.ttf"
	}
	readonly property FontLoader fontHindVadodara_semibold: FontLoader {
		id: hindVadodara_semibold
		source: "qrc:/assets/fonts/hind-vadodara/HindVadodara-SemiBold.ttf"
	}
	readonly property FontLoader fontHindVadodara_bold: FontLoader {
		id: hindVadodara_bold
		source: "qrc:/assets/fonts/hind-vadodara/HindVadodara-Bold.ttf"
	}

	// Make loaded fonts accessible by string name, used for Font.family
	readonly property string icons_reg:   fa_regular.name
	readonly property string icons_solid: fa_solid.name
	readonly property string icons_brand: fa_brands.name
	readonly property string icons_spacedawgs: spacedawgs.name

	readonly property string font_HindVadodara: hindVadodara.name
	readonly property string font_HindVadodara_semibold: hindVadodara_semibold.name
	readonly property string font_HindVadodara_bold: hindVadodara_bold.name
}
