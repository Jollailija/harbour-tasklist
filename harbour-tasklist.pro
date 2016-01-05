# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-tasklist

CONFIG += sailfishapp c++11
QT += dbus

SOURCES += src/harbour-tasklist.cpp \
    src/tasksexport.cpp

OTHER_FILES += qml/harbour-tasklist.qml \
    qml/pages/CoverPage.qml \
    rpm/harbour-tasklist.yaml \
    harbour-tasklist.desktop \
    qml/localdb.js \
    qml/pages/AboutPage.qml \
    qml/pages/EditPage.qml \
    qml/pages/TaskPage.qml \
    qml/pages/ListPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/TaskListItem.qml \
    qml/pages/ExportPage.qml \
    qml/pages/TagPage.qml \
    qml/pages/TagDialog.qml \
    qml/pages/HelpPage.qml

localization.files = localization
localization.path = /usr/share/$${TARGET}

INSTALLS += localization

CONFIG += sailfishapp_i18n_idbased

lupdate_only {
    SOURCES = qml/*.qml \
              qml/*.js \
              qml/pages/*.qml \
              qml/pages/sync/*.qml
    TRANSLATIONS = localization-sources/*.ts
}

HEADERS += \
    src/tasksexport.h
