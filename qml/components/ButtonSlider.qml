import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Row {
    width: parent.width
    height: slider.height

    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property alias live: slider.live
    property alias stepSize: slider.stepSize
    property var formatValueAlias: function (v) { return v }
    property var initValue
    property alias value: slider.value
    property alias sliderElem: slider

    Button {
        text: "-"
        width: units.gu(4)
        height: slider.height
        onClicked: slider.value--
        color: UbuntuColors.red
    }

    Slider {
        width: parent.width - units.gu(8)
        id: slider
        function formatValue ( v ) { return formatValueAlias ( v ) }
        Component.onCompleted: value = initValue
    }

    Button {
        text: "+"
        width: units.gu(4)
        height: slider.height
        onClicked: slider.value++
        color: UbuntuColors.green
    }

}
