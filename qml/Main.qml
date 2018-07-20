import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import "components"
import "controller"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'fatburners.christianpauly'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    readonly property var version: "1.2"
    readonly property var gender: { "INTER":1, "MALE":2, "FEMALE":3 }
    readonly property var activity: { "NONE":0.95, "VERY_LITTLE":1.2, "LITTLE":1.5, "MEDIUM":1.7, "MUCH":1.9, "VERY_MUCH":2.2 }
    property var metabolism: 1500
    property var tabletMode: width > units.gu(90)
    property var prevMode: false

    onTabletModeChanged: {
        if ( prevMode !== tabletMode ) {
            mainStack.clear ()
            if ( tabletMode ) mainStack.push( Qt.resolvedUrl("./pages/BlankPage.qml") )
            else mainStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )
            prevMode = tabletMode
        }
    }

    property var db: LocalStorage.openDatabaseSync("FatburnersDB", "1.0", "The database of the app Fatburners", 1000000)

    SettingsController { id: settings }

    PageStack {
        id: sideStack
        visible: tabletMode
        anchors.fill: undefined
        anchors.left: parent.left
        anchors.top: parent.top
        width: tabletMode ? units.gu(45) : parent.width
        height: parent.height
    }

    Rectangle {
        height: parent.height
        visible: tabletMode
        width: units.gu(0.1)
        color: UbuntuColors.slate
        anchors.top: parent.top
        anchors.left: sideStack.right
        z: 11
    }

    PageStack {
        id: mainStack
        anchors.fill: undefined
        anchors.right: parent.right
        anchors.top: parent.top
        width: tabletMode ? parent.width - units.gu(45) : parent.width
        height: parent.height
    }


    Component.onCompleted: {
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Items( Description STRING, Calories INTEGER, Timestamp INTEGER )')
            })
            sideStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )
            if ( tabletMode ) mainStack.push( Qt.resolvedUrl("./pages/BlankPage.qml") )
            else mainStack.push( Qt.resolvedUrl("./pages/DashPage.qml") )

        }
    }
