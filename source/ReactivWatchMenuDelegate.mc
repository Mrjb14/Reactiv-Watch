import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ReactivWatchMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        var app = getApp();
        var sensorManager = app.getSensorManager();

        if (sensorManager == null) {
            System.println("Error: SensorManager not available");
            return;
        }

        if (item == :mode_accel) {
            System.println("Switching to Accelerometer mode");
            sensorManager.setMode(MODE_ACCELEROMETER);
        } else if (item == :mode_hr) {
            System.println("Switching to Heart Rate mode");
            sensorManager.setMode(MODE_HEARTRATE);
        } else if (item == :mode_combined) {
            System.println("Switching to Combined mode");
            sensorManager.setMode(MODE_COMBINED);
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}