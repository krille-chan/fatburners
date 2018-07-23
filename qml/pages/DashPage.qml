import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../components"

Page {
    anchors.fill: parent
    id: dashPage

    function calculate () {
        // Calculating the calories
        if ( settings.sex === gender.FEMALE || settings.sex === gender.INTER ) {
            metabolism = ( 655.1 + (9.6 * settings.weight) + (1.8 * settings.size) - (4.7 * settings.age) ) * settings.activity
        }
        else metabolism = ( 66.47 + (13.7 * settings.weight) + (5 * settings.size) - (6.8 * settings.age) ) * settings.activity

        progressBar.maximumValue = progressBar.value = Math.round(metabolism) - settings.goal
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT * FROM Items')
                model.clear ()
                for ( var i = rs.rows.length-1; i >= 0; i-- ) {
                    var item = rs.rows[ i ]
                    model.append({
                        name: item.Description,
                        calories: item.Calories,
                        timestamp: item.Timestamp
                    })
                    var now = new Date()
                    if ( new Date(item.Timestamp).toLocaleDateString(Qt.locale(), Locale.ShortFormat) == now.toLocaleDateString(Qt.locale(), Locale.ShortFormat) ) {
                        progressBar.value -= item.Calories
                    }
                }
            }
        )
    }

    Connections {
        target: settings
        onSexChanged: calculate ()
        onActivityChanged: calculate ()
        onAgeChanged: calculate ()
        onSizeChanged: calculate ()
        onWeightChanged: calculate ()
        onGoalChanged: calculate ()
    }

    header: PageHeader {
        id: header
        title: i18n.tr('Calories account')
        trailingActionBar {
            actions: [
            Action {
                iconName: "settings"
                onTriggered: mainStack.push(Qt.resolvedUrl("./SettingsPage.qml"))
            }
            ]
        }
    }

    Column {
        width: dashPage.width
        anchors.top: header.bottom

        Rectangle {
            width: parent.width
            height: topSide.height
            color: theme.palette.normal.background
            z: 10

            Column {
                id: topSide
                width: parent.width

                Rectangle {
                    width: parent.width
                    height: caloriesLabel.height * 3

                    Label {
                        id: caloriesLabel
                        anchors.centerIn: parent
                        textSize: Label.XLarge
                        text: i18n.tr("%1 kilocalories left").arg( Math.round(progressBar.value) )
                    }
                }

                ProgressBar {
                    id: progressBar
                    width: parent.width
                    maximumValue: 1500
                    value: 1500
                }

                SettingsListLink {
                    name: i18n.tr("Add meal")
                    icon: "gtk-add"
                    page: "AddMealPage"
                    iconColor: UbuntuColors.blue
                }

                SettingsListLink {
                    name: i18n.tr("Add sports activity")
                    icon: "unlike"
                    page: "AddSportsActivityPage"
                    iconColor: UbuntuColors.red
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    id: userInfo
                    height: units.gu(2)
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(2)
                    text: i18n.tr("History:")
                    font.bold: true
                }
            }
        }

        ListView {
            id: itemList
            width: parent.width
            height: dashPage.height - topSide.height - header.height
            delegate: ItemListItem {}
            model: ListModel { id: model }
            Component.onCompleted: calculate ()
        }

    }

}
