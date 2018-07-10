/*
 *   Copyright 2015 Marco Martin <mart@kde.org>
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
import QtQuick.Controls 2.0 as Controls
import org.kde.kirigami 2.2 as Kirigami

Kirigami.Page {

    footer: Controls.TabBar {
        id: tabbar
        currentIndex: swipeView.currentIndex

        Controls.TabButton {
            text: i18n("History")
            icon.name: "view-history"
        }
        Controls.TabButton {
            text: i18n("Contacts")
            icon.name: "view-pim-contacts"
        }
        Controls.TabButton {
            text: i18n("Dialpad")
            icon.name: "input-keyboard"
        }
    }

    topPadding: 0
    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0

    Controls.SwipeView {
        id: swipeView
        anchors.fill: parent
        clip: true
        currentIndex: tabbar.currentIndex

        History {
            id: history
        }
        ContactsList {
            id: contacts
        }
        Dialer {
            id: dialer
        }
    }
}
