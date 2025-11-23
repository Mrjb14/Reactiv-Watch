import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.System;

class ReactivWatchView extends WatchUi.View {

    private var _updateTimer as Timer.Timer?;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // Don't use layout - we'll draw everything manually for full-screen reactive display
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        // Start update timer for smooth animations (30 FPS)
        _updateTimer = new Timer.Timer();
        _updateTimer.start(method(:onTimer), 33, true);  // ~30 FPS
    }

    // Timer callback to trigger redraws
    function onTimer() as Void {
        WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var app = getApp();
        var sensorManager = app.getSensorManager();

        if (sensorManager == null) {
            drawError(dc, "Sensor Manager not initialized");
            return;
        }

        // Get screen dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // Get current visualization color and intensity
        var color = sensorManager.getVisualizationColor();
        var intensity = sensorManager.getIntensity();

        // Clear screen with black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw reactive circle that pulses with intensity
        var maxRadius = (width < height ? width : height) / 2;
        var radius = (maxRadius * (0.3 + intensity * 0.7)).toNumber();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, radius);

        // Draw outer ring with lower opacity (simulated by drawing thinner ring)
        var outerRadius = (maxRadius * 0.9).toNumber();
        dc.setPenWidth(3);
        dc.drawCircle(centerX, centerY, outerRadius);

        // Draw mode indicator text at bottom
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height - 30,
            Graphics.FONT_TINY,
            getModeString(sensorManager.getMode()),
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw intensity value for debugging
        var intensityText = "Intensity: " + (intensity * 100).toNumber() + "%";
        dc.drawText(
            centerX,
            20,
            Graphics.FONT_TINY,
            intensityText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    // Get mode display string
    private function getModeString(mode as VisualizationMode) as String {
        if (mode == MODE_ACCELEROMETER) {
            return "Accelerometer Mode";
        } else if (mode == MODE_HEARTRATE) {
            return "Heart Rate Mode";
        } else {
            return "Combined Mode";
        }
    }

    // Draw error message
    private function drawError(dc as Dc, message as String) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_SMALL,
            message,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        // Stop update timer
        if (_updateTimer != null) {
            _updateTimer.stop();
            _updateTimer = null;
        }
    }

}
