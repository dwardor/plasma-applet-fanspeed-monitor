import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import "../../code/config-utils.js" as ConfigUtils
import "../../code/model-utils.js" as ModelUtils

Item {
    id: resourcesConfigPage
    
    property double tableWidth: parent.width

    property string cfg_resources
    
    property var preparedSystemMonitorSources: []
    
    ListModel {
        id: resourcesModel
    }
    
    ListModel {
        id: comboboxModel
    }
    
    Component.onCompleted: {
        
        systemmonitorDS.sources.forEach(function (source) {
            
            if ((source.indexOf('lmsensors/') === 0 ) && source.match(/\/fan[0-9]*$/) ) {
                
                comboboxModel.append({
                    text: source,
                    val: source
                })
                
                print('source to combo: ' + source)
            }
        })
        
        var resources = ConfigUtils.getResourcesObjectArray()
        resources.forEach(function (resourceObj) {
            resourcesModel.append(resourceObj)
        })
    }
    
    function reloadComboboxModel(fanspeedObj) {
        
        fanspeedObj = fanspeedObj || {}
        
        sourceCombo.currentIndex = 0
        
        print('sourceName to select: ' + fanspeedObj.sourceName)
        
        for (var i = 0; i < comboboxModel.count; i++) {
            var source = comboboxModel.get(i).val
            
            if (source === fanspeedObj.sourceName) {
                sourceCombo.currentIndex = i
            }
            
        }
        
    }
    
    function resourcesModelChanged() {
        var newResourcesArray = []
        for (var i = 0; i < resourcesModel.count; i++) {
            var obj = resourcesModel.get(i)
            newResourcesArray.push({
                sourceName: obj.sourceName,
                alias: obj.alias,
            })
        }
        cfg_resources = JSON.stringify(newResourcesArray)
        print('resources: ' + cfg_resources)
    }
    
    
    function fillAddResourceDialogAndOpen(fanspeedObj, editResourceIndex) {
        
        // set dialog title
        addResourceDialog.addResource = fanspeedObj === null
        addResourceDialog.editResourceIndex = editResourceIndex
        
        fanspeedObj = fanspeedObj || {
            alias: '',
        }
        
        // set combobox
        reloadComboboxModel(fanspeedObj)
        
        // alias
        aliasTextfield.text = fanspeedObj.alias
        showAlias.checked = !!fanspeedObj.alias
        
        // open dialog
        addResourceDialog.open()
        
    }
    
    
    Dialog {
        id: addResourceDialog
        
        property bool addResource: true
        property int editResourceIndex: -1
        
        title: addResource ? i18n('Add Resource') : i18n('Edit Resource')
        
        width: tableWidth
        
        property int tableIndex: 0
        property double fieldHeight: addResourceDialog.height / 5 - 3
        
        property bool virtualSelected: true
        
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        
        ExclusiveGroup {
            id: sourceTypeGroup
        }
        
        onAccepted: {
            if (!showAlias.checked) {
                aliasTextfield.text = ''
            } else if (!aliasTextfield.text) {
                aliasTextfield.text = '<UNKNOWN>'
            }
            
            var newObject = {
                sourceName: comboboxModel.get(sourceCombo.currentIndex).val,
                alias: aliasTextfield.text,
            }
            
            if (addResourceDialog.addResource) {
                resourcesModel.append(newObject)
            } else {
                resourcesModel.set(addResourceDialog.editResourceIndex, newObject)
            }
            
            
            resourcesModelChanged()
            addResourceDialog.close()
        }
        
        GridLayout {
            columns: 2
            
            ComboBox {
                id: sourceCombo
                Layout.preferredWidth: tableWidth/2
                model: comboboxModel
            }
            
            Item {
                Layout.columnSpan: 2
                width: 2
                height: 10
            }
            
            CheckBox {
                id: showAlias
                text: i18n("Show alias:")
                checked: true
                Layout.alignment: Qt.AlignRight
            }
            TextField {
                id: aliasTextfield
                Layout.preferredWidth: tableWidth/2
                enabled: showAlias.checked
            }
            
        }
    }
    
    GridLayout {
        columns: 2
        
        Label {
            text: i18n('Plasmoid version: ') + '1.1.2'
            Layout.alignment: Qt.AlignRight
            Layout.columnSpan: 2
        }
        
        Label {
            text: i18n('Resources')
            font.bold: true
            Layout.alignment: Qt.AlignLeft
        }
        
        Item {
            width: 2
            height: 2
        }
        
        TableView {
            
            headerVisible: true
            
            Label {
                text: i18n('Add resources by clicking "+" button.')
                anchors.centerIn: parent
                visible: resourcesModel.count === 0
            }
            
            TableViewColumn {
                role: 'sourceName'
                title: i18n('Source')
                width: tableWidth * 0.6
                delegate: MouseArea {
                    anchors.fill: parent
                    Label {
                        text: styleData.value
                        elide: Text.ElideRight
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                    }
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        fillAddResourceDialogAndOpen(resourcesModel.get(styleData.row), styleData.row)
                    }
                }
            }
            
            TableViewColumn {
                role: 'alias'
                title: i18n('Alias')
                width: tableWidth * 0.15
                delegate: MouseArea {
                    anchors.fill: parent
                    Label {
                        text: styleData.value
                        elide: Text.ElideRight
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                    }
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        fillAddResourceDialogAndOpen(resourcesModel.get(styleData.row), styleData.row)
                    }
                }
            }
            
            TableViewColumn {
                title: i18n('Action')
                width: tableWidth * 0.25 - 4
                
                delegate: Item {
                    
                    GridLayout {
                        height: parent.height
                        columns: 3
                        rowSpacing: 0
                        
                        Button {
                            iconName: 'go-up'
                            Layout.fillHeight: true
                            onClicked: {
                                resourcesModel.move(styleData.row, styleData.row - 1, 1)
                                resourcesModelChanged()
                            }
                            enabled: styleData.row > 0
                        }
                        
                        Button {
                            iconName: 'go-down'
                            Layout.fillHeight: true
                            onClicked: {
                                resourcesModel.move(styleData.row, styleData.row + 1, 1)
                                resourcesModelChanged()
                            }
                            enabled: styleData.row < resourcesModel.count - 1
                        }
                        
                        Button {
                            iconName: 'list-remove'
                            Layout.fillHeight: true
                            onClicked: {
                                resourcesModel.remove(styleData.row)
                                resourcesModelChanged()
                            }
                        }
                    }
                }
            }
            
            model: resourcesModel
            
            Layout.preferredHeight: 150
            Layout.preferredWidth: tableWidth
            Layout.columnSpan: 2
        }
        Button {
            id: buttonAddResource
            iconName: 'list-add'
            Layout.preferredWidth: 100
            Layout.columnSpan: 2
            onClicked: {
                fillAddResourceDialogAndOpen(null, -1)
            }
        }
        
        Item {
            width: 2
            height: 20
            Layout.columnSpan: 2
        }
        
    }
    
    PlasmaCore.DataSource {
        id: systemmonitorDS
        engine: 'systemmonitor'
        interval: 500
    }
    
    PlasmaCore.DataSource {
        id: nvidiaDS
        engine: 'executable'
        
        connectedSources: [ 'nvidia-smi --query-gpu=fan.speed --format=csv,noheader' ]
        
        property bool prepared: false
        onNewData: {
            if (!prepared)
            {
                //nvidiaDS.connectedSources.length = 0
                if (data['exit code'] > 0) {
                    prepared = true
                    return
                }
                
                comboboxModel.append({
                    text: 'nvidia-smi',
                    val: 'nvidia-smi'
                })
                prepared = true
            }
        }
        //interval: 500
    }

    PlasmaCore.DataSource {
        id: atiDS
        engine: 'executable'
        
        connectedSources: [ 'aticonfig --pplib-cmd "get fanspeed 0"' ]
        
        property bool prepared: false
        onNewData: {
            if (!prepared)
            {
                //atiDS.connectedSources.length = 0
                if (data['exit code'] > 0) {
                    prepared = true
                    return
                }
                
                comboboxModel.append({
                    text: 'aticonfig',
                    val: 'aticonfig'
                })
                prepared = true
            }
        }
        //interval: 500
    }
}
