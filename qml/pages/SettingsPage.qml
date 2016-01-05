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
import "../localdb.js" as DB

Dialog {
    id: settingsPage
    allowedOrientations: Orientation.All
    canAccept: true

    property string language: ""

    // function to compose the remorse action slider's text description
    function composeRemorseSliderText(time) {
        var result = ""
        switch (time) {
        case 0:
            //: text to be shown if the slider is set to
            //% "deactivated"
            result = "deactivated"
            break
        case 1:
            //: '%1' will be replaced by the amount of seconds of the slider, which is always 1 in this case
            //% "%1 second"
            result = "%1 second".arg(time)
            break
        default:
            //: '%1' will be replaced by the amount of seconds of the slider
            //% "%1 seconds"
            result = "%1 seconds".arg(time)
            break
        }

        return result
    }

    ListModel {
        id: languages
    }

    Component.onCompleted: {
        //: label for a settings "system default" option
        //% "System default"
        languages.append({ lang: "system_default",  name: "System default" })
        languages.append({ lang: "ca",              name: "Català" })
        languages.append({ lang: "cs_CZ",           name: "Čeština" })
        languages.append({ lang: "da_DK",           name: "Dansk" })
        languages.append({ lang: "de_DE",           name: "Deutsch" })
        languages.append({ lang: "en_US",           name: "English" })
        languages.append({ lang: "es_ES",           name: "Español" })
        languages.append({ lang: "fi_FI",           name: "Suomi" })
        languages.append({ lang: "fr_FR",           name: "Français" })
        languages.append({ lang: "hu",              name: "Magyar" })
        languages.append({ lang: "it_IT",           name: "Italiano" })
        languages.append({ lang: "ku_IQ",           name: "Kurdî" })
        languages.append({ lang: "lt",              name: "Lietuvių" })
        languages.append({ lang: "nl_NL",           name: "Nederlands" })
        languages.append({ lang: "pl_PL",           name: "Polskie" })
        languages.append({ lang: "ru_RU",           name: "Русский" })
        languages.append({ lang: "sv_SE",           name: "Svenska" })
        languages.append({ lang: "tr_TR",           name: "Türkçe"})
        languages.append({ lang: "zh_CN",           name: "中文"})

        language = taskListWindow.getLanguage()
        var found = false
        for (var i = 0; i < languages.count; ++i) {
            var item = languages.get(i)
            if (item.lang === language) {
                languageBox.currentIndex = i
                languageBox.currentItem = languageBox.menu.children[languageBox.currentIndex]
                found = true
                break
            }
        }
        if (!found) {
            //% "Other"
            languages.append({ lang: language, name: "Other" })
            languageBox.currentIndex = languages.count - 1
            languageBox.currentItem = languageBox.menu.children[languageBox.currentIndex]
        }
    }

    onAccepted: {
        // update settings in database
        DB.updateSetting("coverListSelection", coverListSelection.currentIndex)
        DB.updateSetting("coverListOrder", coverListOrder.currentIndex)
        DB.updateSetting("taskOpenAppearance", taskOpenAppearance.checked === true ? 1 : 0)
        DB.updateSetting("backFocusAddTask", backFocusAddTask.checked === true ? 1 : 0)
        DB.updateSetting("remorseOnDelete", remorseOnDelete.value)
        DB.updateSetting("remorseOnMark", remorseOnMark.value)
        DB.updateSetting("remorseOnMultiAdd", remorseOnMultiAdd.value)
        DB.updateSetting("startPage", startPage.currentIndex)
        DB.updateSetting("smartListVisibility", smartListVisibility.checked === true ? 1 : 0)
        DB.updateSetting("recentlyAddedOffset", recentlyAddedOffset.currentIndex)
        DB.updateSetting("closedTaskAppearance", closedTasksAppearance.currentIndex)

        // push new settings to runtime variables
        taskListWindow.coverListSelection = coverListSelection.currentIndex
        taskListWindow.coverListOrder = coverListOrder.currentIndex
        taskListWindow.taskOpenAppearance = taskOpenAppearance.checked === true ? 1 : 0
        taskListWindow.backFocusAddTask = backFocusAddTask.checked === true? 1 : 0
        taskListWindow.remorseOnDelete = remorseOnDelete.value
        taskListWindow.remorseOnMark = remorseOnMark.value
        taskListWindow.remorseOnMultiAdd = remorseOnMultiAdd.value
        taskListWindow.smartListVisibility = smartListVisibility.checked === true ? 1 : 0
        taskListWindow.recentlyAddedOffset = recentlyAddedOffset.currentIndex
        taskListWindow.closedTaskAppearance = closedTasksAppearance.currentIndex

        var langId = languageBox.currentIndex
        if (0 <= langId && langId < languages.count) {
            var lang = languages.get(langId).lang
            if (lang !== language)
                taskListWindow.setLanguage(lang)
        }
    }

    SilicaFlickable {
        id: settingsList
        anchors.fill: parent
        contentHeight: settingsColumn.height

        VerticalScrollDecorator { flickable: settingsList }

        Column {
            id: settingsColumn
            width: parent.width

            DialogHeader {
                //: headline for all user options
                //% "Settings"
                title: "Settings" + " - TaskList"
                //: saves the current made changes to user options
                //% "Save"
                acceptText: "Save"
            }

            SectionHeader {
                //: headline for cover (application state when app is in background mode) options
                //% "Cover options"
                text: "Cover options"
            }

            ComboBox {
                id: coverListSelection
                width: parent.width
                //: user option to choose which list should be shown on the cover
                //% "Cover list"
                label: "Cover list" + ":"
                currentIndex: taskListWindow.coverListSelection

                menu: ContextMenu {
                    //% "Default list"
                    MenuItem { text: "Default list" }
                    //% "Selected list"
                    MenuItem { text: "Selected list" }
                    //% "Choose in list management"
                    MenuItem { text: "Choose in list management" }
                }
            }

            ComboBox {
                id: coverListOrder
                width: parent.width
                //: user option to choose how the tasks should be ordered on the cover
                //% "Cover task order"
                label: "Cover task order" + ":"
                currentIndex: taskListWindow.coverListOrder

                menu: ContextMenu {
                    //% "Last updated first"
                    MenuItem { text: "Last updated first" }
                    //% "Sort by name ascending"
                    MenuItem { text: "Sort by name ascending" }
                    //% "Sort by name descending"
                    MenuItem { text: "Sort by name descending" }
                }
            }

            SectionHeader {
                //: headline for general options
                //% "General options"
                text: "General options"
            }

            ComboBox {
                id: languageBox
                width: parent.width
                //% "Language"
                label: "Language" + ":"

                menu: ContextMenu {
                    Repeater {
                        model: languages
                        MenuItem {
                            text: model.name
                        }
                    }
                }

                onCurrentIndexChanged: {
                    languageTip.visible = language !== languages.get(currentIndex).lang
                }
            }

            Label {
                id: languageTip
                width: parent.width
                x: Theme.paddingLarge
                //% "Language will be changed after app restart."
                text: "Languages don't work in this fork ATM. I'll fix those soon. -jollailija"
                wrapMode: Text.WordWrap
                visible: false
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.highlightColor
            }

            ComboBox {
                id: startPage
                width: parent.width
                //: user option to choose what should be shown at application start
                //% "Start page"
                label: "Start page" + ":"
                currentIndex: taskListWindow.startPage

                menu: ContextMenu {
                    //% "Default list"
                    MenuItem { text: "Default list" }
                    //% "List overview"
                    MenuItem { text: "List overview" }
                    //% "Minimize to cover"
                    MenuItem { text: "Minimize to cover" }
                }
            }

            SectionHeader {
                //: headline for task options
                //% "Task options"
                text: "Task options"
            }

            TextSwitch {
                id: taskOpenAppearance
                width: parent.width
                //: user option to choose whether pending tasks should be marked with a checked or not checked bullet
                //% "Open task appearance"
                text: "Open task appearance"
                checked: taskListWindow.taskOpenAppearance
            }

            TextSwitch {
                id: backFocusAddTask
                width: parent.width
                //: user option to directly jump back to the input field after a new task has been added by the user
                //% "Refocus task add field"
                text: "Refocus task add field"
                checked: taskListWindow.backFocusAddTask
            }


            ComboBox {
                id: closedTasksAppearance
                width: parent.width
                //: user option to select closed tasks appearance
                //% "Done tasks"
                label: "Done tasks" + ":"
                currentIndex: taskListWindow.closedTaskAppearance

                menu: ContextMenu {
                    //: option to not show done tasks
                    //% "Hidden"
                    MenuItem { text: "Hidden" }
                    //: option to how done tasks unselected
                    //% "Status change"
                    MenuItem { text: "Status change" }
                    //: option to show done tasks as striked through items
                    //% "Striked through"
                    MenuItem { text: "Striked through" }
                }
            }

            SectionHeader {
                //: headline for list options
                //% "List options"
                text: "List options"
            }

            TextSwitch {
                id: smartListVisibility
                width: parent.width
                //: user option to decide whether the smart lists (lists which contain tasks with specific attributes, for example new, done and pending tasks)
                //% "Show smart lists"
                text: "Show smart lists"
                checked: taskListWindow.smartListVisibility
            }

            // time periods in seconds are defined in harbour-takslist.qml
            ComboBox {
                id: recentlyAddedOffset
                width: parent.width
                //: user option to select the time period how long tasks are recognized as new
                //% "New task period"
                label: "New task period" + ":"
                currentIndex: taskListWindow.recentlyAddedOffset

                menu: ContextMenu {
                    //: use %1 as a placeholder for the number of hours
                    //% "%1 hours"
                    MenuItem { text: "%1 hours".arg(3) }
                    //% "%1 hours"
                    MenuItem { text: "%1 hours".arg(6) }
                    //% "%1 hours"
                    MenuItem { text: "%1 hours".arg(12) }
                    //: use %1 as a placeholder for the number of the day, which is currently static "1"
                    //% "%1 day"
                    MenuItem { text: "%1 day".arg(1) }
                    //: use %1 as a placeholder for the number of days
                    //% "%1 days"
                    MenuItem { text: "%1 days".arg(2) }
                    //: use %1 as a placeholder for the number of the week, which is currently static "1"
                    //% "%1 week"
                    MenuItem { text: "%1 week".arg(1) }
                }
            }

            SectionHeader {
                //: headline for remorse (a Sailfish specific interaction element to stop a former started process) options
                //% "Remorse options"
                text: "Remorse options"
            }

            Slider {
                id: remorseOnDelete
                width: parent.width
                //% "on Delete"
                label: "on Delete"
                minimumValue: 0
                maximumValue: 10
                stepSize: 1
                value: taskListWindow.remorseOnDelete
                valueText: composeRemorseSliderText(value)
            }

            Slider {
                id: remorseOnMark
                width: parent.width
                //% "on Mark task"
                label: "on Mark task"
                minimumValue: 0
                maximumValue: 10
                stepSize: 1
                value: taskListWindow.remorseOnMark
                valueText: composeRemorseSliderText(value)
            }

            Slider {
                id: remorseOnMultiAdd
                width: parent.width
                //% "on Adding multiple tasks"
                label: "on Adding multiple tasks"
                minimumValue: 0
                maximumValue: 10
                stepSize: 1
                value: taskListWindow.remorseOnMultiAdd
                valueText: composeRemorseSliderText(value)
            }
            Rectangle {
                width: parent.width
                height: Theme.paddingLarge
                color: "transparent"
            }
        }
    }
}
