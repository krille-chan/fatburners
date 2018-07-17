import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0

Settings {

    // The gender of the user. We use "male", "female" and "inter" for other
    // genders and the default. We assume that inter has a default calorie consumption
    property var sex: gender.INTER

    // The size in centimeter because the metric system rocks :-P
    property var size: 170

    // The weight in kilogram
    property var weight: 70

    // Obviously the birthday of the user in timestamp
    property var age: 20

    // With the harris-benedict-formel we use an activity index to calculate the
    // calorie consumption between 0,95 and 2,4
    property var activity: 1.5

    // The number of calories, which the user wants to kill every day
    property var goal: 500

}
