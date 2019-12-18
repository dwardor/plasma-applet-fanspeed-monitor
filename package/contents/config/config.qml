import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n('Fan Speed')
         icon: Qt.resolvedUrl('../images/fan-Icon-made-by-Freepik-from-www.flaticon.com.svg').replace('file://', '')
         source: 'config/ConfigFanspeeds.qml'
    }
    ConfigCategory {
         name: i18n('Appearance')
         icon: 'preferences-desktop-color'
         source: 'config/ConfigAppearance.qml'
    }
    ConfigCategory {
         name: i18n('Misc')
         icon: 'preferences-system-other'
         source: 'config/ConfigMisc.qml'
    }
}
