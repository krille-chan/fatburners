import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

ListItem {
    height: layout.height

    onClicked: {
        descriptionInput.text = name
        caloriesInput.value = Math.abs(calories)
    }

    ListItemLayout {
        id: layout
        title.text: "<b>" + name + "</b>"
        subtitle.text: calories + " " + i18n.tr("kilocalories")
        Icon {
            source: calories > 0 ? "../../assets/meal.svg" : "../../assets/sports.svg"
            width: units.gu(4)
            height: units.gu(4)
            SlotsLayout.position: SlotsLayout.Leading
        }
    }
}
