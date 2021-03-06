import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kio 1.0 as Kio
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    id: root
    width: applications.cellWidth
    height: width
    onClicked: {
        console.log("Clicked: " + model.ApplicationStorageIdRole)
        appListModel.runApplication(model.ApplicationStorageIdRole)
    }

    PlasmaCore.IconItem {
        id: icon
        anchors.centerIn: parent
        width: units.iconSizes.large
        height: width
        source: model.ApplicationIconRole
    }

    PlasmaComponents.Label {
        visible: text.length > 0

        anchors {
            top: icon.bottom
            left: icon.left
            right: icon.right
        }

        wrapMode: Text.WordWrap
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        text: model.ApplicationNameRole
        font.pixelSize: theme.smallestFont.pixelSize
        color: PlasmaCore.ColorScope.textColor
    }
}
