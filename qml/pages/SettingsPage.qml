import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../components"

Page {
    anchors.fill: parent
    id: page

    function centimeterToImperial ( centimeter ) {
        var inches = Math.round(centimeter / 2.54)
        var feet = Math.floor(inches / 12)
        return i18n.tr("%1ft %2in").arg(feet).arg(inches%12)
    }

    function kilogramToImperial ( kilogram ) {
        var oz = Math.round(kilogram * 35.27396)
        var lb = Math.floor(oz / 16)
        return i18n.tr("%1lb %2oz").arg(lb).arg(oz%16)
    }

    header: PageHeader {
        title: i18n.tr('Settings')
    }


    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height - header.height
        anchors.top: header.bottom
        contentItem: Column {
            width: page.width

            Column {
                width: page.width - units.gu(4)
                anchors.left: parent.left
                anchors.leftMargin: units.gu(2)

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    height: units.gu(2)
                    text: i18n.tr("Weight: ") + ( settings.metricSystem ? i18n.tr("%1kg").arg(Math.round(weightInput.value)) : kilogramToImperial(weightInput.value) )
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ButtonSlider {
                    width: parent.width
                    id: weightInput
                    minimumValue: 20
                    maximumValue: 300
                    live: false
                    stepSize: 1
                    formatValueAlias: function ( v ) { return settings.metricSystem ? i18n.tr("%1kg").arg(Math.round( v )) : kilogramToImperial( v ) }
                    sliderElem.onValueChanged: settings.weight = Math.round(value)
                    initValue: settings.weight
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    height: units.gu(2)
                    text: i18n.tr("Height: ") + ( settings.metricSystem ? i18n.tr("%1m").arg(Math.round(heightInput.value )/100) : centimeterToImperial(Math.round(heightInput.value)))
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ButtonSlider {
                    width: parent.width
                    id: heightInput
                    minimumValue: 80
                    maximumValue: 247
                    live: false
                    stepSize: 1
                    formatValueAlias: function ( v ) { return settings.metricSystem ? i18n.tr("%1m").arg(Math.round( v )/100) : centimeterToImperial( v ) }
                    sliderElem.onValueChanged: settings.size = Math.round(value)
                    initValue: settings.size
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    height: units.gu(2)
                    text: i18n.tr("Age: ") + settings.age
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ButtonSlider {
                    width: parent.width
                    id: ageInput
                    minimumValue: 0
                    maximumValue: 122
                    live: false
                    stepSize: 1
                    sliderElem.onValueChanged: settings.age = Math.round(value)
                    initValue: settings.age
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    text: i18n.tr("Diet target:") + "\n " + (settings.metricSystem ? i18n.tr("%1 kg").arg(Math.round(caloriesInput.value / 10) / 100) : kilogramToImperial(Math.round(caloriesInput.value / 10) / 100)) + i18n.tr(" a week")
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ButtonSlider {
                    width: parent.width
                    id: caloriesInput
                    minimumValue: 0
                    maximumValue: metabolism - 500
                    live: false
                    stepSize: 1
                    formatValueAlias: function ( v ) { return i18n.tr("Save %1 kilocalories a day").arg(v)}
                    sliderElem.onValueChanged: settings.goal = Math.round(value)
                    initValue: settings.goal
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    id: sexLabel
                    height: units.gu(2)
                    text: ""
                    Component.onCompleted: update ()
                    function update () {
                        settings.sex = parseInt(settings.sex)
                        text = i18n.tr("Sex:") + " "
                        if ( settings.sex === gender.MALE ) text += i18n.tr("Male")
                        else if ( settings.sex === gender.FEMALE ) text += i18n.tr("Female")
                        else text += i18n.tr("Intersexual")
                    }
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ComboButton {
                    expandedHeight: -1
                    text: i18n.tr("Change")
                    id: combo
                    onClicked: expanded = !expanded
                    Column {
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Intersexual")
                            }
                            onClicked: {
                                settings.sex = gender.INTER
                                combo.expanded = false
                                sexLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Male")
                            }
                            onClicked: {
                                settings.sex = gender.MALE
                                combo.expanded = false
                                sexLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Female")
                            }
                            onClicked: {
                                settings.sex = gender.FEMALE
                                combo.expanded = false
                                sexLabel.update ()
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                Label {
                    id: activityLabel
                    text: ""
                    Component.onCompleted: update ()
                    function update () {
                        settings.activity = parseFloat(settings.activity)
                        text = i18n.tr("Daily activity:") + "\n"
                        if ( settings.activity === activity.NONE ) text += i18n.tr("No activity (*0.95)")
                        else if ( settings.activity === activity.VERY_LITTLE ) text += i18n.tr("Very little activity (*1.2)")
                        else if ( settings.activity === activity.LITTLE ) text += i18n.tr("Little activity (*1.5)")
                        else if ( settings.activity === activity.MEDIUM ) text += i18n.tr("Medium activity (*1.7)")
                        else if ( settings.activity === activity.MUCH ) text += i18n.tr("Much activity (*1.9)")
                        else if ( settings.activity === activity.VERY_MUCH ) text += i18n.tr("Very much activity (*2.2)")
                    }
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(2)
                }

                ComboButton {
                    expandedHeight: -1
                    text: i18n.tr("Change")
                    id: comboA
                    onClicked: expanded = !expanded
                    Column {
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("No activity")
                            }
                            onClicked: {
                                settings.activity = activity.NONE
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Very little activity")
                            }
                            onClicked: {
                                settings.activity = activity.VERY_LITTLE
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Little activity")
                            }
                            onClicked: {
                                settings.activity = activity.LITTLE
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Medium activity")
                            }
                            onClicked: {
                                settings.activity = activity.MEDIUM
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Much activity")
                            }
                            onClicked: {
                                settings.activity = activity.MUCH
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }
                        ListItem {
                            ListItemLayout {
                                title.text: i18n.tr("Very much activity")
                            }
                            onClicked: {
                                settings.activity = activity.VERY_MUCH
                                comboA.expanded = false
                                activityLabel.update ()
                            }
                        }

                    }
                }
            }

            SettingsListSwitch {
                name: i18n.tr("Use metric system")
                icon: "calculator-app-symbolic"
                Component.onCompleted: isChecked = settings.metricSystem
                onSwitching: function () { settings.metricSystem = isChecked }
            }

            SettingsListItem {
                name: i18n.tr("Calorie consumption:") + " <b>" +  Math.round(metabolism) + "</b> " + i18n.tr("kilocalories")
                icon: "torch-on"
            }

            SettingsListItem {
                name: i18n.tr("Body mass index:") + " <b>" + Math.round(settings.weight / (settings.size/100 * settings.size/100)) + "</b>"
                icon: "like"
                Component.onCompleted: {
                    name += " ("
                    var bmi = settings.weight / (settings.size/100 * settings.size/100)
                    if ( settings.sex === gender.FEMALE || settings.sex === gender.MALE ) {
                        if ( bmi < 19) name += i18n.tr("Underweight")
                        else if ( bmi < 24) name += i18n.tr("Normal weight")
                        else if ( bmi < 30) name += i18n.tr("Overweight")
                        else if ( bmi < 40) name += i18n.tr("Obesity")
                        else name += i18n.tr("Strong obesity")
                    }
                    else {
                        if ( bmi < 20) name += i18n.tr("Underweight")
                        else if ( bmi < 25) name += i18n.tr("Normal weight")
                        else if ( bmi < 30) name += i18n.tr("Overweight")
                        else if ( bmi < 40) name += i18n.tr("Obesity")
                        else name += i18n.tr("Strong obesity")
                    }
                    name += ")"
                }
            }

            SettingsListLink {
                name: i18n.tr("About Fatburners")
                icon: "info"
                page: "InfoPage"
            }

        }
    }

}
