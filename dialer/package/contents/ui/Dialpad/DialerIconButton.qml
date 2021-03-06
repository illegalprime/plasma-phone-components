/*
 *   Copyright 2014 Aaron Seigo <aseigo@kde.org>
 *   Copyright 2014 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: buttonRoot

    Layout.fillWidth: true
    Layout.fillHeight: true

    property var callback
    property var pressedCallback
    property var releasedCallback
    property string sub
    property alias source: icon.source
    property alias text: label.text

    Rectangle {
        anchors.fill: parent
        z: -1
        color: PlasmaCore.ColorScope.highlightColor
        radius: units.smallSpacing
        opacity: mouse.pressed ? 0.4 : 0
        Behavior on opacity {
            OpacityAnimator {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    Row {
        anchors.centerIn: parent
        PlasmaCore.IconItem {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            width: height
            height: buttonRoot.height * 0.6
        }
        PlasmaComponents.Label {
            id: label
            height: buttonRoot.height
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 1024
            fontSizeMode: Text.VerticalFit
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (callback) {
                callback(parent.text);
            } else {
                addNumber(parent.text);
            }
        }

        onPressAndHold: {
            var text;
            if (longHold.visible) {
                text = longHold.text;
            } else {
                text = parent.text;
            }

            if (callback) {
                callback(text);
            } else if (pad.callback) {
                pad.callback(text);
            }
        }
    }
}
