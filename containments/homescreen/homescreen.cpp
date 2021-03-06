/***************************************************************************
 *   Copyright (C) 2015 Marco Martin <mart@kde.org>                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "homescreen.h"
#include "applicationlistmodel.h"

#include <QtQml>
#include <QDebug>

HomeScreen::HomeScreen(QObject *parent, const QVariantList &args)
    : Plasma::Containment(parent, args)
{
    qmlRegisterType<ApplicationListModel>();
    m_applicationListModel = new ApplicationListModel(this);
    setHasConfigurationInterface(true);
}

HomeScreen::~HomeScreen()
{
}

ApplicationListModel *HomeScreen::applicationListModel()
{
    return m_applicationListModel;
}

K_EXPORT_PLASMA_APPLET_WITH_JSON(homescreen, HomeScreen, "metadata.json")

#include "homescreen.moc"
