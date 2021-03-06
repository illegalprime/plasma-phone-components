/*
 *   Copyright 2014 Aaron Seigo <aseigo@kde.org>
 *   Copyright 2012 Marco Martin <notmart@gmail.com>
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

import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.shell 2.0 as Shell
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.workspace.components 2.0 as PlasmaWorkspace
import org.kde.kquickcontrolsaddons 2.0
import org.kde.activities 0.1 as Activities
import "../components"

Item {
    id: root
    width: 0
    height: 0

    property Item containment;
    property Item containmentNextActivityPreview;
    property Item wallpaper;
    property int notificationId: 0;
    property int buttonHeight: width/4
    property bool loadCompleted: false

    XAnimator {
        id: switchAnim
        target: activitiesLayout
        duration: units.longDuration
        easing.type: Easing.InOutQuad
    }
    MouseArea {
        id: activitiesView
        z: 99
        visible: root.containment
        anchors.fill: parent
        drag.filterChildren: true
        drag.target: activitiesLayout
        drag.axis: Drag.XAxis
        drag.minimumX: -activitiesLayout.width + width
        drag.maximumX: 0
        property int currentIndex: -1
        property Item nextContainment: root.containment

        function adjustPosition() {
            if (!activitiesLayout.loadCompleted) {
                activitiesLayout.x = - currentIndex * width;
                return;
            }
            switchAnim.from = activitiesLayout.x;
            switchAnim.to = - currentIndex * width;
            switchAnim.running = true;
        }
        onCurrentIndexChanged: adjustPosition();
        
        //don't animate
        onWidthChanged: contentX = currentIndex * width;

        onPositionChanged: {
            var tempIndex = Math.round(-activitiesLayout.x / width);
            nextContainment = activitiesLayout.children[tempIndex].containment;
        }
        onReleased: {
            currentIndex = Math.round(-activitiesLayout.x / width);
            //unconditionally run the slide anim
            adjustPosition();
        }
        Row {
            id: activitiesLayout
            height: activitiesView.height
            spacing: 0
            //don't try to do anything until we are well setted up
            property bool loadCompleted: root.loadCompleted && width == activitiesView.width * (activitiesLayout.children.length - 1) && activitiesLayout.children.length == activityRepeater.count + 1
            onLoadCompletedChanged: activitiesView.currentIndexChanged();

            Repeater {
                id: activityRepeater
                model: Activities.ActivityModel {
                    id: activityModel
                }

                delegate: Item {
                    id: mainDelegate
                    width: activitiesView.width
                    height: activitiesView.height
                    property Item containment
                    //inViewport should be only the current, and the other adjacent two
                    readonly property bool inViewport: activitiesLayout.loadCompleted && root.containment &&
                            ((x >= -activitiesLayout.x &&
                            x <= -activitiesLayout.x + activitiesView.width) ||
                            (x + width >= -activitiesLayout.x &&
                            x + width < -activitiesLayout.x + activitiesView.width))
                    readonly property bool currentActivity: root.containment && model.current

                    
                    Connections {
                        target: activitiesView
                        onCurrentIndexChanged: {
                            if (activitiesView.currentIndex == index) {
                                activityModel.setCurrentActivity(model.id, function(){
                                    mainDelegate.containment.parent = mainDelegate;
                                });
                            }
                        }
                        onFlickEnded: activitiesView.movementEnded()
                    }
                    onInViewportChanged: {
                        if (inViewport && !mainDelegate.containment) {
                            mainDelegate.containment = desktop.candidateContainments[model.id];
                            //desktop.containmentItemForActivity(model.id);
                            containmentNextActivityPreview = containment;
                            mainDelegate.containment.parent = mainDelegate;
                            mainDelegate.containment.anchors.fill = mainDelegate;
                        }
                    }
                    onCurrentActivityChanged: {
                        if (currentActivity) {
                            activitiesView.currentIndex = index;
                        }
                        mainDelegate.containment.visible = true;
                    }
                }
            }
        }
    }

    //TODO: adjust its Y to current containment availablescreenrect
    PageIndicator {
        z: 100
        anchors {
            bottom: parent.bottom
            bottomMargin: root.containment.availableScreenRect.y + root.containment.availableScreenRect.height
            horizontalCenter: parent.horizontalCenter
        }
        count: activitiesView.count
        currentIndex: activitiesView.currentIndex
    }
    PlasmaCore.FrameSvgItem {
        z: 100
        opacity: activitiesView.drag.active ? 1 : 0
        anchors.centerIn: parent
        imagePath: "widgets/background"
        width: childrenRect.width + units.gridUnit*2
        height: childrenRect.height + units.gridUnit*2
        PlasmaComponents.Label {
            anchors.centerIn: parent
            text: activitiesView.nextContainment.activityName
        }
        Behavior on opacity {
            OpacityAnimator {
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    function toggleWidgetExplorer(containment) {
        console.log("Widget Explorer toggled");
        if (widgetExplorerStack.source != "") {
            widgetExplorerStack.source = "";
        } else {
            widgetExplorerStack.setSource(Qt.resolvedUrl("../explorer/WidgetExplorer.qml"), {"containment": containment})
        }
    }

    Loader {
        id: widgetExplorerStack
        z: 99
        asynchronous: true
        y: containment ? containment.availableScreenRect.y : 0
        height: containment ? containment.availableScreenRect.height : parent.height
        width: parent.width
        
        onLoaded: {
            if (widgetExplorerStack.item) {
                item.closed.connect(function() {
                    widgetExplorerStack.source = ""
                });
            }
        }
    }

    Binding {
        target: containment
        property: "width"
        value: root.width
    }
    //some properties that shouldn't be accessible from elsewhere
    QtObject {
        id: internal;

        property Item oldContainment: null;
        property Item newContainment: null;
    }

    //pass the focus to the containment, so it can react to homescreen activate/inactivate
    Connections {
        target: desktop
        onActiveChanged: {
            containment.focus = desktop.active;
        }
    }

    Loader {
        id: pinOverlay
        anchors {
            fill: parent
            topMargin: containment.availableScreenRect.y
            bottomMargin: parent.height - containment.availableScreenRect.height - containment.availableScreenRect.y
        }
        z: 222
        source: Qt.resolvedUrl("Pin.qml")
    }

    onWidthChanged: {
        //There will be a resize at the very start which we can't avoid, don't do anything until then
        //configure the view behavior
        if (desktop && root.width > 0) {
            desktop.width = width;
            desktop.height = height;
            root.loadCompleted = true;
        }
    }
    Component.onCompleted: {
        //configure the view behavior
        if (desktop && root.width > 0) {
            desktop.width = width;
            desktop.height = height;
            root.loadCompleted = true;
        }
    }
}
