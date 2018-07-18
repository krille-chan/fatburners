import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../components"

Page {
    anchors.fill: parent
    id: page

    function save () {
        if ( descriptionInput.displayText === "" ) return
        var now = new Date().getTime()
        db.transaction(
            function(tx) {
                tx.executeSql( 'INSERT INTO Items VALUES( "' + descriptionIn + '", "' + Math.round( -caloriesIn ) + '", ' + now + ' )' )
                if ( tabletMode ) {
                    sideStack.pop()
                    sideStack.push( Qt.resolvedUrl("./DashPage.qml") )
                }
                else {
                    mainStack.pop()
                    mainStack.pop()
                    mainStack.push( Qt.resolvedUrl("./DashPage.qml") )
                }
            })
        }

        property alias descriptionIn: descriptionInput.displayText
        property alias caloriesIn: caloriesInput.value

        header: PageHeader {
            id: header
            title: i18n.tr('Add sports activity')
            trailingActionBar {
                actions: [
                Action {
                    iconName: "ok"
                    onTriggered: save ()
                }
                ]
            }
        }

        Column {
            width: parent.width
            anchors.top: header.bottom

            Rectangle {
                width: parent.width
                height: topSide.height
                color: theme.palette.normal.background
                z: 10

                Column {
                    id: topSide
                    width: parent.width - units.gu(4)
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(2)

                    Rectangle {
                        width: parent.width
                        height: units.gu(2)
                    }

                    Label {
                        height: units.gu(2)
                        text: i18n.tr("What did you practice?")
                        font.bold: true
                    }

                    Rectangle {
                        width: parent.width
                        height: units.gu(2)
                    }

                    TextField {
                        id: descriptionInput
                        width: caloriesInput.width
                        placeholderText: i18n.tr("Sports activity")
                        Keys.onReturnPressed: save ()
                    }

                    Rectangle {
                        width: parent.width
                        height: units.gu(2)
                    }

                    Label {
                        height: units.gu(2)
                        text: i18n.tr("Spent calories: ") + Math.round(caloriesInput.value)
                        font.bold: true
                    }

                    Rectangle {
                        width: parent.width
                        height: units.gu(2)
                    }

                    ButtonSlider {
                        formatValueAlias: function ( v ) { return Math.round(v) }
                        id: caloriesInput
                        minimumValue: 1
                        maximumValue: 2000
                        value: 100
                        live: true
                        stepSize: 1
                    }

                    Rectangle {
                        width: parent.width
                        height: units.gu(2)
                    }

                    Label {
                        height: units.gu(2)
                        text: i18n.tr("Recent activities:")
                        font.bold: true
                    }

                }
            }

            ListView {
                id: itemList
                width: parent.width
                height: page.height - topSide.height - header.height
                delegate: RecentListItem {}
                model: ListModel { id: model }
                Component.onCompleted: {
                    db.transaction(
                        function(tx) {
                            var rs = tx.executeSql('SELECT * FROM Items WHERE Calories < 0 GROUP BY Description ORDER BY Timestamp DESC')
                            for ( var i = 0; i < rs.rows.length; i++ ) {
                                var item = rs.rows[ i ]
                                model.append({
                                    name: item.Description,
                                    calories: item.Calories,
                                    timestamp: item.Timestamp
                                })
                            }
                        }
                    )
                }
            }
        }



    }
