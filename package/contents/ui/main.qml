/*
 * Copyright 2019 Benjamin Réveillé <benjamin.reveille@gmail.com>
 *
 * 99% Reuse of Thermal Monitor by Martin Kotelnik <clearmartin@seznam.cz> 
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../code/model-utils.js" as ModelUtils
import "../code/config-utils.js" as ConfigUtils

Item {
    id: main

    anchors.fill: parent

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property bool planar: (plasmoid.formFactor == PlasmaCore.Types.Planar)

    property bool initialized: false

    // configuration
    property string configuredResources: plasmoid.configuration.resources
    property int updateInterval: 1000 * plasmoid.configuration.updateInterval

    property int itemMargin: 5
    property double itemWidth:  0
    property double itemHeight: 0

    property var textFontFamily: theme.defaultFont.family

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property double aliasFontSize: itemHeight * plasmoid.configuration.aliasFontSize * 0.01
    property double fanspeedFontSize: itemHeight * plasmoid.configuration.fanspeedFontSize * 0.01
    property double fanspeedRightMargin: itemHeight * plasmoid.configuration.fanspeedRightMargin * 0.01
    property bool enableLabelDropShadow: plasmoid.configuration.enableLabelDropShadow

    property var systemmonitorAvailableSources: []
    property var systemmonitorSourcesToAdd: []

    property int numberOfParts: fanspeedModel.count

    property double parentWidth: parent !== null ? parent.width : 0
    property double parentHeight: parent !== null ? parent.height : 0

    property double widgetWidth: 0
    property double widgetHeight: 0

    Layout.preferredWidth: widgetWidth
    Layout.preferredHeight: widgetHeight

    property bool debugLogging: false

    function dbgprint(msg) {
        if (!debugLogging) {
            return
        }
        print('[fanspeedMonitor] ' + msg)
    }

    onParentWidthChanged: setWidgetSize()
    onParentHeightChanged: setWidgetSize()
    onNumberOfPartsChanged: setWidgetSize()

    function setWidgetSize() {
        if (!parentHeight) {
            return
        }
        var orientationVertical = false
        if (planar) {
            var contentItemWidth = parentHeight
            var contentWidth = numberOfParts * contentItemWidth + (numberOfParts-1) * itemMargin
            var restrictToWidth = contentWidth / parentWidth > 1
            itemWidth = restrictToWidth ? (parentWidth + itemMargin) / numberOfParts - itemMargin : contentItemWidth
        } else if (vertical) {
            orientationVertical = true
            itemWidth = parentWidth
        } else {
            itemWidth = parentHeight
        }
        itemHeight = itemWidth
        itemWidth = itemHeight*1.6
        widgetWidth = orientationVertical ? itemWidth : numberOfParts * itemWidth + (numberOfParts-1) * itemMargin
        widgetHeight = orientationVertical ? numberOfParts * itemHeight + (numberOfParts-1) * itemMargin : itemHeight
    }

    FontLoader {
        source: '../fonts/fontawesome-webfont-4.3.0.ttf'
    }

    Image {
        id: noResourceIcon;

        anchors.centerIn: parent

        visible: fanspeedModel.count === 0

        height: itemHeight
        width: height

        source: '../images/fan-Icon-made-by-Freepik-from-www.flaticon.com.svg'
    }

    ListView {
        id: listView

        anchors.centerIn: parent
        width: widgetWidth
        height: widgetHeight

        orientation: !planar && vertical ? ListView.Vertical : ListView.Horizontal
        spacing: itemMargin

        model: fanspeedModel

        delegate: FanspeedItem {}
    }

    /*
     * 
     * One object has these properties: fanspeed, alias and other
     * 
     */
    ListModel {
        id: fanspeedModel
    }

    Component.onCompleted: {
        plasmoid.setAction('reloadSources', i18n('Reload Fan Speed Sources'), 'system-reboot');
        reloadAllSources()
        setWidgetSize()
    }

    onConfiguredResourcesChanged: {
        dbgprint('configured resources changed')
        tryReloadSources()
    }

    function tryReloadSources() {
        if (!initialized) {
            dbgprint('applet not initialized -> no reloading sources')
            return
        }
        reloadAllSources()
    }

    function getSystemmonitorAvailableSources() {
        if (!systemmonitorAvailableSources.length === 0) {
	    // then it has not been filled in by "systemmonitorDS onSourceAdded" actions yet so just set to systemmonitorDS.sources
            systemmonitorAvailableSources = systemmonitorDS.sources
        }
        return systemmonitorAvailableSources
    }

    function action_reloadSources() {
        reloadAllSources()
    }

    function reloadAllSources() {

        dbgprint('reloading all sources...')

        var resources = ConfigUtils.getResourcesObjectArray()

        fanspeedModel.clear()

        if (systemmonitorDS.connectedSources === undefined) {
            systemmonitorDS.connectedSources = []
        }

        if (nvidiaDS.connectedSources === undefined) {
            nvidiaDS.connectedSources = []
        }

        if (atiDS.connectedSources === undefined) {
            atiDS.connectedSources = []
        }

        systemmonitorSourcesToAdd.length = 0
        systemmonitorDS.connectedSources.length = 0
        nvidiaDS.connectedSources.length = 0
        atiDS.connectedSources.length = 0

        ModelUtils.initModels(resources, fanspeedModel)

        for (var i = 0; i < fanspeedModel.count; i++) {
            var tempObj = fanspeedModel.get(i)
            var source = tempObj.sourceName

            addSourceToDs(source)

        }

        ModelUtils.rebuildModelIndexByKey(fanspeedModel)

        initialized = true

        dbgprint('reloadAllSources() DONE')
    }

    function addSourceToDs(source) {

        if (source.indexOf('nvidia-') === 0 && nvidiaDS.connectedSources.length === 0) {

            dbgprint('adding source to nvidiaDS')

            addToSourcesOfDatasource(nvidiaDS, nvidiaDS.nvidiaSource)

        } else if (source.indexOf('aticonfig') === 0 && atiDS.connectedSources.length === 0) {

            dbgprint('adding source to atiDS')

            addToSourcesOfDatasource(atiDS, atiDS.atiSource)

        } else {

            dbgprint('adding source to systemmonitorDS: ' + source)

            if (getSystemmonitorAvailableSources().indexOf(source) > -1) {
                dbgprint('adding to connected')
                addToSourcesOfDatasource(systemmonitorDS, source)
            } else {
                dbgprint('adding to sta')
                systemmonitorSourcesToAdd.push(source)
            }

        }

    }

    function addToSourcesOfDatasource(datasource, sourceName) {
        if (datasource.connectedSources.indexOf(sourceName) > -1) {
            // already added
            dbgprint('source already added: ' + sourceName)
            return
        }
        datasource.connectedSources.push(sourceName)
    }

    PlasmaCore.DataSource {
        id: systemmonitorDS
        engine: 'systemmonitor'

        property string lmSensorsStart: 'lmsensors/'

        onSourceAdded: {

            if (source.indexOf(lmSensorsStart) === 0) {

                systemmonitorAvailableSources.push(source)
                var staIndex = systemmonitorSourcesToAdd.indexOf(source)
                if (staIndex > -1) {
                    addToSourcesOfDatasource(systemmonitorDS, source)
                    systemmonitorSourcesToAdd.splice(staIndex, 1)
                }

            }

        }

        onNewData: {
            var fanspeed = 0
            if (data.value === undefined) {
                dbgprint('data for source ' + sourceName + ' not yet available')
            } else {
                fanspeed = parseFloat(data.value)
            }
            ModelUtils.updateFanspeedModel(fanspeedModel, sourceName, fanspeed)
        }
        interval: updateInterval
    }

    PlasmaCore.DataSource {
        id: nvidiaDS
        engine: 'executable'

        property string nvidiaSource: 'nvidia-smi --query-gpu=fan.speed --format=csv,noheader'

        onNewData: {
            var fanspeed = 0
            if (data['exit code'] > 0) {
                dbgprint('new data error: ' + data.stderr)
            } else {
                fanspeed = parseFloat(data.stdout) * maxspeed/100
            }

            ModelUtils.updateFanspeedModel(fanspeedModel, 'nvidia-smi', fanspeed)
        }
        interval: updateInterval
    }

    PlasmaCore.DataSource {
        id: atiDS
        engine: 'executable'

        property string atiSource: 'aticonfig --pplib-cmd "get fanspeed 0" | grep Result | sed -e "s/.*: *//" -e "s/%//"'

        onNewData: {
            var fanspeed = 0
            if (data['exit code'] > 0) {
                dbgprint('new data error: ' + data.stderr)
            } else {
                fanspeed = parseFloat(data.stdout)
            }

            ModelUtils.updateFanspeedModel(fanspeedModel, 'aticonfig', fanspeed)
        }
        interval: updateInterval
    }

    Timer {
        interval: updateInterval
        repeat: true
        running: true
    }

}
