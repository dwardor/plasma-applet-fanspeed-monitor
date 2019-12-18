import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

    property alias cfg_updateInterval: updateIntervalSpinBox.value

    GridLayout {
        Layout.fillWidth: true
        columns: 2

        Label {
            text: i18n('Update interval:')
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            id: updateIntervalSpinBox
            decimals: 1
            stepSize: 0.1
            minimumValue: 0.1
            suffix: i18nc('Abbreviation for seconds', 's')
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

    }

}
