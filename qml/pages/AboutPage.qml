/*
    TaskList - A small but mighty program to manage your daily tasks.
    Copyright (C) 2015 Thomas Amler
    Contact: Thomas Amler <takslist@penguinfriends.org>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.1
import Sailfish.Silica 1.0

Dialog {
    id: aboutPage
    allowedOrientations: Orientation.All
    canAccept: true

    SilicaFlickable {
        id: aboutTaskList
        anchors.fill: parent
        contentHeight: aboutRectangle.height

        VerticalScrollDecorator { flickable: aboutTaskList }

        ListModel {
            id: contributorsList

            ListElement { name: "Manuel Soriano (manu007)" }
            ListElement { name: "Ilja Balonov" }
            ListElement { name: "Léonard Meyer" }
            ListElement { name: "Anatoly Shipitsin" }
            ListElement { name: "fri" }
            ListElement { name: "Jiri Grönroos" }
            ListElement { name: "İsmail Adnan Sarıer" }
            ListElement { name: "Åke Engelbrektson" }
            ListElement { name: "Heimen Stoffels" }
            ListElement { name: "Agustí Clara" }
            ListElement { name: "lorenzo facca" }
            ListElement { name: "TylerTemp" }
            ListElement { name: "Peter Jespersen" }
            ListElement { name: "Moo" }
            ListElement { name: "Murat Khairulin" }
        }

        Column {
            id: aboutRectangle
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            DialogHeader {
                //: headline of application information page
                //% "About"
                title: "About" + " - TaskList"
                //: switch from About back to application
                //% "Back"
                acceptText: "Back"
            }

            Image {
                source: "../images/harbour-tasklist.png"
                width: parent.width
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }

            Label {
                text: "TaskList " + version
                horizontalAlignment: Text.Center
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                //: headline for application description
                //% "Description"
                text: "Description"
            }

            Label {
                //: TaskList description
                //% "A small but mighty program to manage your daily tasks."
                text: "This is a no-DropBox-fork made by jollailija. Contact me at jollailija@gmail.com"
                +  "A small but mighty program to manage your daily tasks."
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            SectionHeader {
                //: headline for application licensing information
                //% "Licensing"
                text: "Licensing"
            }

            Label {
                //: Copyright and license information
                //% "Copyright © by"
                text: "Copyright © by" + " Thomas Amler\n" +
                      //% "License"
                      "License" + ": GPL v3"
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
            }

            SectionHeader {
                //: headline for application project information
                //% "Project information"
                text: "Project information"
                font.pixelSize: Theme.fontSizeSmall
            }

            Label {
                textFormat: Text.RichText;
                text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><a href=\"https://github.com/Armadill0/harbour-tasklist\">TaskList @ Github.com</a>"
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeTiny

                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }

            SectionHeader {
                //: headline for application contributors
                //% "Contributors"
                text: "Contributors"
            }

            Repeater {
                model: contributorsList

                delegate: Label {
                    text: "- " + name
                    width: parent.width - Theme.horizontalPageMargin * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeSmall
                }
            }

            Rectangle {
                width: parent.width
                height: Theme.paddingLarge
                color: "transparent"
            }
        }
    }
}
