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
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../code/fanspeed-utils.js" as FanspeedUtils

Item {
    id: fanspeedItem

    width: itemWidth
    height: itemHeight

    //
    // all fanspeeds default to rpm
    //
    property bool isOff: fanspeed === 0

    Item {
        id: labels
        anchors.fill: parent

        PlasmaComponents.Label {
            id: aliasText

            font.pixelSize: aliasFontSize
            font.pointSize: -1
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter

            text: alias
        }

        PlasmaComponents.Label {
            id: fanspeedText

            anchors.bottom: aliasText.text === '' ? undefined : parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: fanspeedRightMargin
            anchors.verticalCenter: aliasText.text === '' ? parent.verticalCenter : undefined

            font.pixelSize: fanspeedFontSize * (isOff ? 0.7 : 1)
            font.pointSize: -1
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter

            opacity: isOff ? 0.7 : 1

            text: isOff ? i18n('OFF') : FanspeedUtils.getFanspeedStr(fanspeed)
        }
    }

    DropShadow {
        anchors.fill: labels
        radius: enableLabelDropShadow ? 3 : 0
        spread: 0.8
        fast: true
        color: theme.backgroundColor
        source: labels
        visible: enableLabelDropShadow
    }

}
