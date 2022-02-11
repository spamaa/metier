pragma Singleton
import QtQuick 2.0

//-----------------------------------------------------------------------------
// An index of the font awesome unicode icons used for better Fonts usage.
// Synopsis:
/*
    Text {
        text: IconIndex.sd_chevron_right
        font.family: Fonts.icons_spacedawgs
        font.styleName: "Regular"
        font.pixelSize: <size of font icon>
    }
*/
//-----------------------------------------------------------------------------
// Notes:
//   *Setting font.weight to anything but normal can break some characters.
//-----------------------------------------------------------------------------
QtObject {
    // FontAwesome Solid: Fonts.icons_solid   font.styleName: "Solid"
    readonly property string exclamation_circle: "\uf06a"
    readonly property string fa_check:           "\uf00c"
    readonly property string fa_copy:            "\uf0c5"
    readonly property string fa_qrcode:          "\uf029"
    readonly property string fa_chevron_left:    "\uf053"
    readonly property string fa_seedling:        "\uf4d8"
    readonly property string fa_code:            "\uf121"
    readonly property string fa_credit_card:     "\uf09d"
    readonly property string fa_wallet:          "\uf555"
    readonly property string fa_image:           "\uf03e"
    readonly property string fa_clone:           "\uf24d"

    // Dawgs Font: Fonts.icons_spacedawgs  font.styleName: "Regular"
    readonly property string sd_add:            "\ue900"
    readonly property string sd_add_user:       "\ue901"
    readonly property string sd_alert:          "\ue902"
    readonly property string sd_arrow_external: "\ue903"
    readonly property string sd_arrow_right:    "\ue904"
    readonly property string sd_bell:           "\ue905"
    readonly property string sd_bell_off:       "\ue906"
    readonly property string sd_chat:           "\ue907"
    readonly property string sd_chat_more:      "\ue908"
    readonly property string sd_chevron_right:  "\uE909"
    readonly property string sd_close:          "\ue90a"
    readonly property string sd_edit:           "\ue90b"
    readonly property string sd_link:           "\ue90c"
    readonly property string sd_menu:           "\ue90d"
    readonly property string sd_moon:           "\ue90e"
    readonly property string sd_more:           "\ue90f"
    readonly property string sd_nfc:            "\ue910"
    readonly property string sd_qr:             "\ue911"
    readonly property string sd_return:         "\ue912"
    readonly property string sd_search:         "\ue913"
    readonly property string sd_send:           "\ue914"
    readonly property string sd_settings:       "\ue915"
    readonly property string sd_share:          "\ue916"
    readonly property string sd_sun:            "\ue917"
    readonly property string sd_suppot:         "\ue918"
}

//-----------------------------------------------------------------------------
