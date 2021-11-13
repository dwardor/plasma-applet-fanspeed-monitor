import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    
    property alias cfg_aliasFontSize: aliasFontSize.value
    property alias cfg_fanspeedFontSize: fanspeedFontSize.value
    property alias cfg_fanspeedWidthToHeightRatio: fanspeedWidthToHeightRatio.value
    property alias cfg_fanspeedRightMargin: fanspeedRightMargin.value
    property alias cfg_fanspeedNvidiaGPUMaxRpm: fanspeedNvidiaGPUMaxRpm.value
    property alias cfg_enableLabelDropShadow: enableLabelDropShadow.checked
    
    GridLayout {
        columns: 3
        anchors.left: parent.left
        anchors.right: parent.right
        
        Label {
            text: i18n('Alias font size:')
            Layout.alignment: Qt.AlignRight
        }
        Slider {
            id: aliasFontSize
            stepSize: 1
            minimumValue: 2
            maximumValue: 100
            Layout.fillWidth: true
        }
        Label {
            text: aliasFontSize.value
            Layout.alignment: Qt.AlignLeft
        }

        Label {
            text: i18n('Fan Speed font size:')
            Layout.alignment: Qt.AlignRight
        }
        Slider {
            id: fanspeedFontSize
            stepSize: 1
            minimumValue: 2
            maximumValue: 100
            Layout.fillWidth: true
        }
        Label {
            text: fanspeedFontSize.value
            Layout.alignment: Qt.AlignLeft
        }
        
        Label {
            text: i18n('Fan Speed right margin:')
            Layout.alignment: Qt.AlignRight
        }
        Slider {
            id: fanspeedRightMargin
            stepSize: 1
            minimumValue: 0
            maximumValue: 80
            Layout.fillWidth: true
        }
        Label {
            text: fanspeedRightMargin.value
            Layout.alignment: Qt.AlignLeft
        }

        Label {
            text: i18n('Width to Height Ratio:')
            Layout.alignment: Qt.AlignRight
        }
        Slider {
            id: fanspeedWidthToHeightRatio
            stepSize: 0.1
            minimumValue: 0.3
            maximumValue: 3.0
            Layout.fillWidth: true
        }
        Label {
            text: (fanspeedWidthToHeightRatio.value).toFixed(1)
            Layout.alignment: Qt.AlignLeft
        }
        
        Label {
            text: i18n('Nvidia GPU fan speed [rpm] when at 100%:')
            Layout.alignment: Qt.AlignRight
        }
        Slider {
            id: fanspeedNvidiaGPUMaxRpm
            stepSize: 50
            minimumValue: 100
            maximumValue: 4000
            Layout.fillWidth: true
        }
        Label {
            text: fanspeedNvidiaGPUMaxRpm.value
            Layout.alignment: Qt.AlignLeft
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 3
        }
        
        CheckBox {
            id: enableLabelDropShadow
            Layout.columnSpan: 3
            text: i18n('Enable label drop shadow')
        }
    }
    
}
