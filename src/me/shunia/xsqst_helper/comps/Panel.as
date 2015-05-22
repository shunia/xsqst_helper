/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
import flash.display.DisplayObject;
import flash.display.Sprite;

public class Panel extends Sprite{
    private var _layout:Layout = new Layout();

    public function get layout():Layout {
        return _layout;
    }

    public function get elements():Array {
        return _layout.elms;
    }

    public function add(d:DisplayObject):DisplayObject {
        addChild(d);
        _layout.add(d);
        graphics.endFill();
        graphics.beginFill(0, 0);
        graphics.drawRect(0, 0, _layout.width, _layout.height);
        graphics.endFill();
        return d;
    }

    public function clear():void {
        while (numChildren) removeChildAt(0);
        _layout.addElms([]);
        graphics.clear();
    }

}
}
