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
import org.nemomobile.notifications 1.0
import "pages"
import "pages/sync"
import "localdb.js" as DB
import harbour.tasklist.tasks_export 1.0

ApplicationWindow {
    id: taskListWindow

    // set current list
    property int listid
    // save defaultlist in a global context
    property int defaultlist
    // helper variable to indicate the need to update list model data in TaskPage
    property bool needListModelReload: false
    // helper varable for adding directly through coveraction
    property bool coverAddTask: false
    // helper varable to lock task Page Orientation
    property bool lockTaskOrientation: false
    // indicator variable when app just started
    property bool justStarted: true
    // a variable to trigger the switch of tha start page
    property bool switchStartPage: true
    // variable to save the list of lists as a string
    property var listOfLists: []
    // variable to save the current cover list as a variable which overlives changing from Dovers screen to lock screen and back
    property int currentCoverList: -1
    // list of current time periods in seconds for the "recently added tasks" smart list
    property variant recentlyAddedPeriods: [10800, 21600, 43200, 86400, 172800, 604800]
    // deactivate smart lists at startup
    property int smartListType: -1
    // specify tag if the smart list of tagged tasks is selected
    property int tagId
    // define names of smart lists
    //: names of the automatic smart lists (lists which contain tasks with specific attributes, for example new, done and pending tasks)
    property variant smartListNames: [
        //% "Done"
        "Done",
        //% "Pending"
        "Pending",
        //% "New"
        "New",
        //% "Today"
        "Today",
        //% "Tomorrow"
        "Tomorrow",
        //% "Tags"
        "Tags"
    ]
    property bool coverActionMultiple: listOfLists.length > 1
    property bool coverActionSingle: !coverActionMultiple

    // initialize default settings properties
    property int coverListSelection
    property int coverListChoose
    property int coverListOrder
    property bool taskOpenAppearance
    property int remorseOnDelete
    property int remorseOnMark
    property int remorseOnMultiAdd
    property int startPage
    property int backFocusAddTask
    property bool smartListVisibility
    property int recentlyAddedOffset
    /* How closed task appears:
     * - 0: don't show
     * - 1: not selected text switch
     * - 2: striked through text switch
     */
    property int closedTaskAppearance

    initialPage: DB.schemaIsUpToDate() ? initialTaskPage : migrateConfirmation
    cover: Component { CoverPage {} }

    Component {
        id: initialTaskPage
        TaskPage { }
    }

    onClosedTaskAppearanceChanged: {
        needListModelReload = true
    }

    Component {
        id: migrateConfirmation
        Dialog {
            allowedOrientations: Orientation.All
            //: text of the button to migrate the old to the new database format
            //% "Upgrade"
            property string dbUpgradeText: "Upgrade"
            //: text of the button to delete the old database and start overleo
            //% "Delete"
            property string dbDeleteText: "Delete"

            SilicaFlickable {
                id: migrateFlickable
                anchors.fill: parent
                contentHeight: migrateColumn.height

                VerticalScrollDecorator { flickable: migrateFlickable }

                Column {
                    id: migrateColumn
                    width: parent.width

                    DialogHeader {
                        //: Stop database upgrade dialog
                        //% "Exit"
                        acceptText: "Exit"
                        //: get user's attention before starting database upgrade
                        //% "Action required"
                        title: "Action required"
                    }

                    SectionHeader {
                        //: headline for the informational upgrade dialog part
                        //% "Information"
                        text: "Information"
                    }

                    Label {
                        width: parent.width - 2 * Theme.horizontalPageMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        //: first part of the database upgrade description
                        //% "A database from a previous version of TaskList has been found. Old databases are not supported."
                        text: "A database from a previous version of TaskList has been found. Old databases are not supported." + "\n" +
                              //: second part of the database upgrade description; %1 and %2 are the placeholders for the 'Upgrade' and 'Delete' options of the upgrade Dialog
                              //% " Press '%1' to migrate the old database into the new format or '%2' to delete the old database and start with a clean new database."
                              " Press 'Upgrade' to migrate the old database into the new format or 'Delete' to delete the old database and start with a clean new database."
                        wrapMode: Text.WordWrap
                        color: Theme.highlightColor
                        font.bold: true
                    }

                    SectionHeader {
                        //: headline for the option section of the upgrade dialog
                        //% "Choose an option"
                        text: "Choose an option"
                    }

                    Label {
                        width: parent.width - 2 * Theme.horizontalPageMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        //: user has the possibility to choose the database upgrade or delete the old database
                        //% "Please select an action to proceed."
                        text: "Please select an action to proceed."
                        wrapMode: Text.WordWrap
                    }

                    Rectangle {
                        width: parent.width
                        height: Theme.paddingLarge
                        color: "transparent"
                    }

                    Row {
                        width: parent.width

                        Button {
                            width: parent.width * 0.75
                            //: hint which is the recommended upgrade option
                            //% "recommended"
                            text: dbUpgradeText + " (" + "recommended" + ")"
                            onClicked: {
                                if (DB.replaceOldDB(true))
                                    pageStack.replace(initialTaskPage)
                                else
                                    Qt.quit()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: Theme.paddingLarge
                        color: "transparent"
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: dbDeleteText
                            onClicked: {
                                if (DB.replaceOldDB())
                                    pageStack.replace(initialTaskPage)
                                else
                                    Qt.quit()
                            }
                        }
                    }
                }
            }

            onAccepted: Qt.quit()
        }
    }

    // a function to check which appearance should be used by open tasks
    function statusOpen(a) { return a === taskOpenAppearance }

    // a function to fill litoflists with data
    function fillListOfLists () {
        // load lists into variable for "switch" action on cover and task page
        listOfLists = DB.allLists()
    }

    // short human-readable representation of a due date
    function humanReadableDueDate(unixTime) {
        var date = new Date(unixTime);
        var today = new Date();
        var tomorrow = new Date(today.getTime() + DB.DAY_LENGTH);
        var yesterday = new Date(today.getTime() - DB.DAY_LENGTH);

        var dateString = date.toDateString();
        if (dateString === today.toDateString())
            //: due date string for today
            //% "Today"
            return "Today";
        if (dateString === tomorrow.toDateString())
            //: due date string for tomorrow
            //% "Tomorrow"
            return "Tomorrow";
        if (dateString === yesterday.toDateString())
            //: due date string for yesterday
            //% "Yesterday"
            return "Yesterday";

        return date.toLocaleDateString(Qt.locale(), Locale.ShortFormat);
    }

    TasksExport {
        id: exporter
    }
    function getLanguage() {
        return exporter.language
    }

    function setLanguage(lang) {
        exporter.language = lang
    }

    // notification function
    function pushNotification(notificationType, notificationSummary, notificationBody) {
        var notificationCategory
        switch(notificationType) {
        case "OK":
            notificationCategory = "x-jolla.store.sideloading-success"
            break
        case "INFO":
            notificationCategory = "x-jolla.lipstick.credentials.needUpdate.notification"
            break
        case "WARNING":
            notificationCategory = "x-jolla.store.error"
            break
        case "ERROR":
            notificationCategory = "x-jolla.store.error"
            break
        }

        notification.category = notificationCategory
        notification.previewSummary = notificationSummary
        notification.previewBody = notificationBody
        notification.publish()
    }

    function initializeApplication() {
        DB.initializeDB()
        listid = DB.getSettingAsNumber("defaultList")
        defaultlist = listid
        justStarted = false

        // initialize application settings
        coverListSelection = DB.getSettingAsNumber("coverListSelection")
        coverListChoose = DB.getSettingAsNumber("coverListChoose")
        coverListOrder = DB.getSettingAsNumber("coverListOrder")
        taskOpenAppearance = DB.getSettingAsNumber("taskOpenAppearance") === 1
        remorseOnDelete = DB.getSettingAsNumber("remorseOnDelete")
        remorseOnMark = DB.getSettingAsNumber("remorseOnMark")
        remorseOnMultiAdd = DB.getSettingAsNumber("remorseOnMultiAdd")
        startPage = DB.getSettingAsNumber("startPage")
        backFocusAddTask = DB.getSettingAsNumber("backFocusAddTask")
        smartListVisibility = DB.getSettingAsNumber("smartListVisibility") === 1
        recentlyAddedOffset = DB.getSettingAsNumber("recentlyAddedOffset")
        // default appearance: not shown
        closedTaskAppearance = DB.getSettingAsNumber("closedTaskAppearance", 0)
        // check range
        closedTaskAppearance = Math.min(Math.max(closedTaskAppearance, 0), 2)
    }

    Notification {
        id: notification
        category: "x-nemo.email.error"
        itemCount: 1
    }

    onApplicationActiveChanged: {
        if (applicationActive === true) {
            // reset currentCoverList to default (-1)
            currentCoverList = -1
        }
    }
}
