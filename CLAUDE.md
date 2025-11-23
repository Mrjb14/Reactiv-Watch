# CLAUDE.md - AI Assistant Guide for Reactiv-Watch

## Project Overview

**Reactiv-Watch** is a Garmin Connect IQ watch application built with Monkey C, Garmin's proprietary programming language for wearable devices. This project is designed to run on a wide range of Garmin devices including Fenix, Forerunner, Epix, Venu, Instinct series, and Edge cycling computers.

### Application Concept

**Reactiv-Watch** is a reactive audio-visual experience that transforms your Garmin watch into a dynamic color display synchronized with music. The application uses the watch's built-in microphone to capture ambient sound and displays colors that react in real-time to the music's audio characteristics.

**Core Functionality:**
- Captures audio input through the watch's microphone
- Analyzes sound characteristics (amplitude, frequency, rhythm)
- Displays dynamic colors that react to the music in real-time
- Adapts to all music genres and intensity levels

### Use Cases

The application is designed for various musical environments:

**🎪 Festivals & Concerts**
- Synchronize your watch display with live music performances
- Create a visual light show on your wrist that follows the beat
- Perfect for electronic music festivals and outdoor concerts

**🎉 Parties & Events**
- Turn your watch into a wearable light accessory
- React to DJ sets and party music in real-time
- Add visual excitement to social gatherings

**🎵 Music Listening**
- Enhance your personal music experience with visual feedback
- Works with all music genres:
  - **Classical & Soft**: Gentle, flowing color transitions
  - **Pop & Rock**: Medium-intensity reactive patterns
  - **Electronic & Techno**: Fast, vibrant color changes
  - **Acid & Hard Techno**: Intense, rapid-fire visual responses
  - **Ambient & Jazz**: Smooth, subtle color variations

The reactive algorithm adapts automatically to the music's intensity, making it versatile across all styles from calm classical pieces to hard-hitting techno beats.

**Project Type:** Watch Application (`watch-app`)
**Entry Point:** `ReactivWatchApp`
**Minimum API Level:** 3.1.0
**Application ID:** `99e81d76-c9e8-4cff-8856-941f90410c15`

## Technology Stack

- **Language:** Monkey C (Garmin's proprietary language)
- **Framework:** Garmin Connect IQ SDK
- **Build System:** Monkey Barrel / Connect IQ build tools
- **Supported Devices:** 100+ Garmin devices (watches, bike computers, diving computers)

### Key APIs Required

To implement the reactive audio-visual functionality, the following Connect IQ APIs will be needed:

- **Toybox.Sensor** - For accessing microphone/audio input
- **Toybox.Graphics** - For rendering dynamic colors and visual effects
- **Toybox.Timer** - For high-frequency screen updates and smooth animations
- **Toybox.Math** - For audio signal processing and color calculations
- **Toybox.Attention** - (Optional) For haptic feedback synchronized with beats

### Required Permissions

The application will need to request the following permissions in `manifest.xml`:
- **Microphone/Sensor access** - To capture audio input from the environment
- **Background execution** - (Optional) To continue monitoring audio when app is in background

**Note:** Not all Garmin devices have microphone capabilities. The app should gracefully handle devices without microphone support by displaying a message or using alternative input methods.

## Directory Structure

```
Reactiv-Watch/
├── manifest.xml              # Application manifest (auto-generated, do not edit manually)
├── monkey.jungle            # Build configuration (references manifest.xml)
├── .gitignore              # Git ignore patterns for Garmin CIQ projects
│
├── source/                 # Monkey C source code
│   ├── ReactivWatchApp.mc          # Main application class
│   ├── ReactivWatchView.mc         # Main view/UI rendering
│   ├── ReactivWatchDelegate.mc     # Input handling delegate
│   └── ReactivWatchMenuDelegate.mc # Menu interaction handler
│
└── resources/              # Application resources
    ├── drawables/          # Images and icons
    │   ├── drawables.xml   # Drawable resource definitions
    │   ├── launcher_icon.svg  # App launcher icon (SVG format)
    │   └── monkey.png      # Example image asset
    ├── layouts/
    │   └── layout.xml      # UI layout definitions
    ├── menus/
    │   └── menu.xml        # Menu structure definitions
    └── strings/
        └── strings.xml     # Localized strings
```

## Key Files and Components

### Source Code (`source/`)

#### `ReactivWatchApp.mc`
Main application entry point that extends `Application.AppBase`.
- **Key Methods:**
  - `initialize()` - App initialization
  - `onStart(state)` - Called on app startup
  - `onStop(state)` - Called on app exit
  - `getInitialView()` - Returns the initial view and delegate
- **Helper Function:** `getApp()` - Global accessor for the app instance

#### `ReactivWatchView.mc`
Main view class extending `WatchUi.View`, responsible for UI rendering.
- **Key Methods:**
  - `onLayout(dc)` - Loads and sets the layout from resources
  - `onShow()` - Prepare view when shown (resource loading)
  - `onUpdate(dc)` - Redraws the view (called on refresh)
  - `onHide()` - Cleanup when view is hidden (free resources)

#### `ReactivWatchDelegate.mc`
Input handling delegate extending `WatchUi.BehaviorDelegate`.
- **Key Methods:**
  - `onMenu()` - Handles menu button press, pushes menu view

#### `ReactivWatchMenuDelegate.mc`
Menu interaction handler extending `WatchUi.MenuInputDelegate`.
- **Key Methods:**
  - `onMenuItem(item)` - Handles menu item selection
- **Current Menu Items:** `:item_1`, `:item_2` (placeholders)

### Resources (`resources/`)

#### `manifest.xml`
Auto-generated file that should NOT be edited manually. Use Visual Studio Code commands:
- "Monkey C: Edit Application" - Update app attributes
- "Monkey C: Set Products by Product Category" - Add device categories
- "Monkey C: Edit Products" - Add/remove specific devices
- "Monkey C: Edit Permissions" - Manage app permissions
- "Monkey C: Edit Languages" - Configure supported languages
- "Monkey C: Configure Monkey Barrel" - Manage barrel dependencies

#### Resource XML Files
All resource files use Garmin's XML schema: `https://developer.garmin.com/downloads/connect-iq/resources.xsd`

- **strings.xml** - String resources for localization
- **layout.xml** - UI layout with labels and bitmaps
- **menu.xml** - Menu structure definitions
- **drawables.xml** - Drawable resource references

## Code Conventions

### Naming Conventions
- **Classes:** PascalCase (e.g., `ReactivWatchApp`, `ReactivWatchView`)
- **Functions:** camelCase (e.g., `initialize`, `onUpdate`)
- **Constants:** Use symbols for IDs (e.g., `:item_1`, `:id_monkey`)
- **Resource References:** Use `@Strings`, `@Drawables`, `Rez` namespace

### Import Pattern
```monkeyc
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
```

### Common Patterns

#### View Lifecycle
```monkeyc
onLayout(dc) → onShow() → onUpdate(dc) → onHide()
```

#### Resource Access
```monkeyc
// Strings: @Strings.AppName
// Layouts: Rez.Layouts.MainLayout(dc)
// Menus: Rez.Menus.MainMenu()
// Drawables: @Drawables.LauncherIcon
```

#### Type Annotations
Monkey C uses explicit type annotations:
```monkeyc
function onStart(state as Dictionary?) as Void
function onMenuItem(item as Symbol) as Void
```

### View/Delegate Pattern
Connect IQ uses a View/Delegate architecture:
- **View** - Handles rendering (`onUpdate`, `onLayout`)
- **Delegate** - Handles input (`onMenu`, `onSelect`, `onBack`)

## Development Workflow

### Setting Up
1. Install Garmin Connect IQ SDK
2. Install Visual Studio Code with Connect IQ extension
3. Configure target devices in `manifest.xml`

### Building
```bash
# Build is typically done through VS Code Connect IQ extension
# Or using command line tools from the SDK
```

### Testing
- Use Connect IQ Simulator for testing on virtual devices
- Side-load `.prg` files to physical devices for real-world testing
- Test on multiple device sizes/resolutions

### Common Tasks

#### Adding a New Device Target
Use VS Code command: "Monkey C: Edit Products" (do not edit manifest.xml directly)

#### Adding Permissions
Use VS Code command: "Monkey C: Edit Permissions"

#### Adding Resources
1. Add files to appropriate `resources/` subdirectory
2. Define resource in corresponding XML file
3. Reference via `@ResourceType.ResourceId` or `Rez.ResourceType.ResourceId`

## Build Artifacts (Git Ignored)

The following are generated during build and should not be committed:
- `bin/` - Compiled binaries
- `*.prg` - Packaged app files
- `*.debug.xml` - Debug symbol files
- `gen/` - Generated code
- `*.mcgen`, `*.mir`, `*.mbc` - Intermediate build files

## Memory Management

Garmin devices have limited memory. Best practices:
- Free resources in `onHide()` when views are removed
- Avoid keeping large objects in memory
- Use lazy loading for resources
- Test memory usage on low-memory devices

## Multi-Device Considerations

This app supports 100+ devices with varying:
- **Screen sizes** - From 208x208 to 416x416 pixels
- **Memory** - Different RAM/storage constraints
- **Features** - Not all devices support same sensors/APIs

### Best Practices:
- Use percentage-based positioning (`x="center"`)
- Check API availability before use
- Test on representative devices from each category
- Consider using device-specific resources for optimization

## Current State (As of Last Commit)

**Commit:** `bb4bd60` - "Add comprehensive CLAUDE.md documentation"

The application is in its initial scaffold state with:
- Basic app structure with View/Delegate pattern
- Placeholder UI (label + monkey image)
- Two-item menu with placeholder handlers
- **Core audio-reactive functionality not yet implemented**

### Implementation Roadmap

To achieve the audio-reactive color display functionality, the following features need to be developed:

**Phase 1: Audio Input**
- [ ] Add microphone permission to manifest.xml
- [ ] Implement audio sampling from device microphone
- [ ] Create audio buffer management system
- [ ] Handle devices without microphone support

**Phase 2: Audio Analysis**
- [ ] Implement amplitude detection (volume level)
- [ ] Implement frequency analysis (bass, mid, treble)
- [ ] Create beat detection algorithm
- [ ] Develop dynamic sensitivity adjustment for different music genres

**Phase 3: Visual Rendering**
- [ ] Design color mapping algorithm (audio → colors)
- [ ] Implement smooth color transitions
- [ ] Create different visualization modes
- [ ] Optimize rendering for various screen sizes and shapes
- [ ] Add intensity-based color palettes

**Phase 4: User Experience**
- [ ] Add sensitivity adjustment controls
- [ ] Create visualization mode selector
- [ ] Implement color scheme presets
- [ ] Add battery-saving modes
- [ ] Create settings menu for customization

**Phase 5: Optimization**
- [ ] Optimize for memory-constrained devices
- [ ] Reduce CPU usage for longer battery life
- [ ] Test across all supported device models
- [ ] Fine-tune responsiveness for different music genres

## AI Assistant Guidelines

### When Making Changes:

1. **NEVER manually edit `manifest.xml`** - Use VS Code commands or ask user to edit
2. **Always read files before modifying** - Understand existing code structure
3. **Maintain Monkey C conventions** - Use proper type annotations
4. **Consider memory constraints** - Garmin devices have limited resources
5. **Test multi-device compatibility** - Changes should work across device types
6. **Follow View/Delegate pattern** - Don't mix UI and input handling
7. **Use resource references** - Don't hardcode strings, use `@Strings.*`

### Audio-Reactive Implementation Considerations:

When implementing the audio-reactive functionality, keep in mind:

1. **Microphone Access**
   - Check device capabilities before accessing microphone
   - Handle gracefully on devices without microphone support
   - Respect user privacy and only sample when app is active

2. **Performance Optimization**
   - Audio sampling and analysis are CPU-intensive operations
   - Use efficient algorithms to minimize battery drain
   - Consider lower sampling rates for older/less powerful devices
   - Implement frame-skipping if rendering falls behind

3. **Color Mapping Strategy**
   - Map amplitude (volume) to color brightness/intensity
   - Map frequency ranges to color hues (bass = red/warm, treble = blue/cool)
   - Use smooth interpolation for fluid color transitions
   - Avoid jarring color changes that could be uncomfortable

4. **Genre Adaptation**
   - Classical/Soft: Longer averaging windows, smoother transitions
   - Techno/Hard: Short response times, high sensitivity to beats
   - Implement auto-calibration based on ambient sound levels

5. **Memory Management**
   - Keep audio buffers as small as possible
   - Reuse buffer memory instead of allocating new arrays
   - Clear buffers in `onHide()` to free memory when app closes

### Common Modification Patterns:

#### Adding a View Element:
1. Add string to `resources/strings/strings.xml`
2. Add element to `resources/layouts/layout.xml`
3. (Optional) Update `onUpdate()` in View if dynamic content needed

#### Adding a Menu Item:
1. Add string to `strings.xml`
2. Add menu item to `menu.xml`
3. Add handler in `ReactivWatchMenuDelegate.mc` `onMenuItem()`

#### Adding Custom Drawing:
Override `onUpdate()` in View and use Graphics API:
```monkeyc
function onUpdate(dc as Dc) as Void {
    View.onUpdate(dc);
    // Custom drawing code using dc
}
```

### File References:
When referencing code locations, use the format: `file:line`
Example: `source/ReactivWatchApp.mc:21`

## Resources

- [Connect IQ Developer Site](https://developer.garmin.com/connect-iq/)
- [Monkey C API Documentation](https://developer.garmin.com/connect-iq/api-docs/)
- [Connect IQ Programmer's Guide](https://developer.garmin.com/connect-iq/programmers-guide/)

## Questions?

For Connect IQ specific questions, consult:
1. Official Garmin Connect IQ documentation
2. Connect IQ Forums
3. API documentation for specific Toybox modules

---

**Last Updated:** 2025-11-23
**Application Version:** Initial Release (Audio-reactive functionality in development)
