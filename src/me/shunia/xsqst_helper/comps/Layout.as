/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
import flash.display.DisplayObject;

public class Layout {
    public var hGap:int = 2;
    public var vGap:int = 2;
    public var direction:String = "horizontal";

    public var elms:Array = null;
    private var _w:int = 0;
    private var _h:int = 0;

    public function get width():int {
        return _w;
    }
    public function get height():int {
        return _h;
    }

    public function Layout() {
        elms = [];
    }

    public function addElms(value:Array):void {
        elms = value ? value : elms;
        updateDisplay();
    }

    public function add(elm:DisplayObject):void {
        var i:int = elms.indexOf(elm);
        if (i != -1)
            elms.slice(i, 1);
        elms.push(elm);
        updateDisplay();
    }

    public function updateDisplay():void {
        if (elms.length == 0) {
            _w = 0;
            _h = 0;
            return;
        }

        var elm:DisplayObject = null, tx:int = 0, ty:int = 0;
        for (var i:int = 0; i < elms.length; i ++) {
            elm = elms[i];
            if (direction == "horizontal") {
                elm.x = tx + hGap;
                elm.y = vGap;
                tx = elm.x + elm.width;
            } else {
                elm.x = hGap;
                elm.y = ty + vGap;
                ty = elm.y + elm.height;
            }
        }
        _w = elm.x + elm.width + hGap;
        _h = elm.y + elm.height + vGap;
    }
}
}
