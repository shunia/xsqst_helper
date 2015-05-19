/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
public class Bag extends BaseModule{
    public function Bag() {
    }

    override public function sync(cb:Function = null):void {
        Global.service.on("sync_bag", function (data:Object):void {
            init(data);

            _c(cb);
        });
    }

    protected function init(o:Object):void {

    }

    public var jy:Array = null;
    public var jb:Array = null;

    public var hz_mx:int = 0;
    public var hz_wk:int = 0;
    public var hz_wz:int = 0;
    public var ys_bx:int = 0;
    public var ys_my:int = 0;
    public var ys_ly:int = 0;
}
}
