/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.game.ui {
import me.shunia.xsqst_helper.comps.Label;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.utils.Time;

public class LogPanel extends Panel {

    private var _log:Label = null;

    public function LogPanel() {
        super();

        _log = new Label(false);
        _log.width = 300;
        _log.height = 300;
        addChild(_log);
    }

    public function log(args:Array):void {
        _log.appendText("[" + Time.getLocal() + "]");
        _log.appendText(args.join(" "));
        _log.appendText("\n");
        _log.scrollV = _log.maxScrollV;
    }

    override public function set width(value:Number):void {
        _log.width = value;
        layout.updateDisplay();
    }

    override public function set height(value:Number):void {
        _log.height = value;
        layout.updateDisplay();
    }

}
}
