import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Math;

// Visualization modes
enum VisualizationMode {
    MODE_ACCELEROMETER = 0,
    MODE_HEARTRATE = 1,
    MODE_COMBINED = 2
}

class SensorManager {
    private var _currentMode as VisualizationMode;
    private var _accelData as AccelerometerData?;
    private var _heartRateData as Number;
    private var _isActive as Boolean;

    // Accelerometer data storage
    private var _accelX as Array<Number>;
    private var _accelY as Array<Number>;
    private var _accelZ as Array<Number>;

    // Computed values for visualization
    private var _intensity as Float;
    private var _colorHue as Number;

    function initialize() {
        _currentMode = MODE_ACCELEROMETER;
        _accelData = null;
        _heartRateData = 0;
        _isActive = false;

        _accelX = [0];
        _accelY = [0];
        _accelZ = [0];

        _intensity = 0.0;
        _colorHue = 0;
    }

    // Start sensor monitoring
    function start() as Void {
        if (_isActive) {
            return;
        }

        try {
            // Register for sensor data based on current mode
            var options = {
                :period => 1  // 1 second sample period
            } as SensorOptions;

            if (_currentMode == MODE_ACCELEROMETER || _currentMode == MODE_COMBINED) {
                options.put(:accelerometer, {
                    :enabled => true,
                    :sampleRate => 25  // 25 samples per second
                });
            }

            if (_currentMode == MODE_HEARTRATE || _currentMode == MODE_COMBINED) {
                // Enable heart rate sensor
                Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_HEARTRATE] as Array<SensorType>);
                Sensor.enableSensorEvents(method(:onHeartRate));
            }

            // Register accelerometer callback if needed
            if (_currentMode == MODE_ACCELEROMETER || _currentMode == MODE_COMBINED) {
                Sensor.registerSensorDataListener(method(:onSensorData), options);
            }

            _isActive = true;
        } catch (e) {
            System.println("Error starting sensors: " + e.getErrorMessage());
        }
    }

    // Stop sensor monitoring
    function stop() as Void {
        if (!_isActive) {
            return;
        }

        try {
            Sensor.unregisterSensorDataListener();
            Sensor.setEnabledSensors([] as Array<SensorType>);
            _isActive = false;
        } catch (e) {
            System.println("Error stopping sensors: " + e.getErrorMessage());
        }
    }

    // Callback for accelerometer data
    function onSensorData(sensorData as SensorData) as Void {
        _accelData = sensorData.accelerometerData;

        if (_accelData != null) {
            _accelX = _accelData.x;
            _accelY = _accelData.y;
            _accelZ = _accelData.z;

            // Calculate intensity from acceleration magnitude
            calculateIntensity();
        }
    }

    // Callback for heart rate data
    function onHeartRate(sensorInfo as SensorInfo) as Void {
        var hr = sensorInfo.heartRate;
        if (hr != null && hr > 0) {
            _heartRateData = hr;

            if (_currentMode == MODE_HEARTRATE) {
                calculateIntensityFromHeartRate();
            }
        }
    }

    // Calculate intensity from accelerometer data
    private function calculateIntensity() as Void {
        if (_accelX.size() == 0) {
            return;
        }

        // Calculate average magnitude of acceleration
        var sumMagnitude = 0.0;
        var count = _accelX.size();

        for (var i = 0; i < count; i++) {
            var x = _accelX[i] / 1000.0;  // Convert from milli-G to G
            var y = _accelY[i] / 1000.0;
            var z = _accelZ[i] / 1000.0;

            // Calculate magnitude: sqrt(x^2 + y^2 + z^2)
            var magnitude = Math.sqrt(x*x + y*y + z*z);
            sumMagnitude += magnitude;
        }

        var avgMagnitude = sumMagnitude / count;

        // Subtract gravity (1G) and normalize to 0-1 range
        // High intensity music/movement can cause 0.5-2G of additional acceleration
        _intensity = ((avgMagnitude - 1.0) * 2.0).abs();
        if (_intensity > 1.0) {
            _intensity = 1.0;
        }

        // Update color hue based on intensity variations
        updateColorHue();
    }

    // Calculate intensity from heart rate
    private function calculateIntensityFromHeartRate() as Void {
        // Map heart rate to intensity
        // Resting: 60 bpm -> 0.0
        // Active: 120 bpm -> 0.5
        // Intense: 180+ bpm -> 1.0

        var normalizedHR = (_heartRateData - 60) / 120.0;
        if (normalizedHR < 0.0) {
            normalizedHR = 0.0;
        } else if (normalizedHR > 1.0) {
            normalizedHR = 1.0;
        }

        _intensity = normalizedHR;
        updateColorHue();
    }

    // Update color hue based on current data
    private function updateColorHue() as Void {
        if (_currentMode == MODE_ACCELEROMETER || _currentMode == MODE_COMBINED) {
            // Map acceleration intensity to color spectrum
            // Low movement = cool colors (blue/purple)
            // High movement = warm colors (red/orange)
            _colorHue = (_intensity * 240).toNumber();  // 0-240 degrees (blue to red)
        } else {
            // Heart rate mode: map HR to colors
            _colorHue = ((_heartRateData - 60) * 2).toNumber();
            if (_colorHue < 0) {
                _colorHue = 0;
            } else if (_colorHue > 360) {
                _colorHue = 360;
            }
        }
    }

    // Get current visualization color
    function getVisualizationColor() as Number {
        // Convert HSV to RGB for display
        return hsvToRgb(_colorHue, 1.0, _intensity);
    }

    // Get current intensity value
    function getIntensity() as Float {
        return _intensity;
    }

    // Set visualization mode
    function setMode(mode as VisualizationMode) as Void {
        if (mode == _currentMode) {
            return;
        }

        var wasActive = _isActive;

        if (wasActive) {
            stop();
        }

        _currentMode = mode;

        if (wasActive) {
            start();
        }
    }

    // Get current mode
    function getMode() as VisualizationMode {
        return _currentMode;
    }

    // Convert HSV to RGB color
    private function hsvToRgb(h as Number, s as Float, v as Float) as Number {
        var hue = h % 360;
        var c = v * s;
        var x = c * (1 - ((hue / 60.0) % 2 - 1).abs());
        var m = v - c;

        var r = 0.0;
        var g = 0.0;
        var b = 0.0;

        if (hue < 60) {
            r = c; g = x; b = 0;
        } else if (hue < 120) {
            r = x; g = c; b = 0;
        } else if (hue < 180) {
            r = 0; g = c; b = x;
        } else if (hue < 240) {
            r = 0; g = x; b = c;
        } else if (hue < 300) {
            r = x; g = 0; b = c;
        } else {
            r = c; g = 0; b = x;
        }

        var red = ((r + m) * 255).toNumber();
        var green = ((g + m) * 255).toNumber();
        var blue = ((b + m) * 255).toNumber();

        // Combine RGB into single number (0xRRGGBB)
        return (red << 16) | (green << 8) | blue;
    }
}
