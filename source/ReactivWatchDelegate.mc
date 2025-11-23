import Toybox.Lang;
import Toybox.WatchUi;

class ReactivWatchDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ReactivWatchMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}