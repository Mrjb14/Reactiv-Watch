import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ReactivWatchApp extends Application.AppBase {

    private var _sensorManager as SensorManager?;

    function initialize() {
        AppBase.initialize();
        _sensorManager = new SensorManager();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        if (_sensorManager != null) {
            _sensorManager.start();
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        if (_sensorManager != null) {
            _sensorManager.stop();
        }
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new ReactivWatchView(), new ReactivWatchDelegate() ];
    }

    // Get the sensor manager instance
    function getSensorManager() as SensorManager? {
        return _sensorManager;
    }

}

function getApp() as ReactivWatchApp {
    return Application.getApp() as ReactivWatchApp;
}