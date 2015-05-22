/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	import me.shunia.xsqst_helper.Service;

public class Bag extends BaseModule{

    public var itl_enabled:Boolean = false;

    public function Bag() {
    }

    override public function sync(cb:Function = null):void {
        Service.on("sync_bag", function (data:Object):void {
            init(data);

            _c(cb);
        });
    }

    protected function init(o:Object):void {
        if (!itl_enabled) return;

        oneKeyMoney();
        oneKeyExp();
    }

    protected function oneKeyMoney():void {
        Service.on("sell_bag_gold", function (data:Object):void {
            if (data.ret == 1) return;
            report(REPORT_TYPE_ONE_KEY_GOLD);
        });
    }

    protected function oneKeyExp():void {
        Service.on("sell_bag_exp", function (data:Object):void {
            if (data.ret == 1) return;
            report(REPORT_TYPE_ONE_KEY_EXP);
        })
    }

    public var jy:Array = null;
    public var jb:Array = null;

    public var hz_mx:int = 0;
    public var hz_wk:int = 0;
    public var hz_wz:int = 0;
    public var ys_bx:int = 0;
    public var ys_my:int = 0;
    public var ys_ly:int = 0;

    protected static const REPORT_TYPE_SYNC:int = 0;
    protected static const REPORT_TYPE_ONE_KEY_GOLD:int = 1;
    protected static const REPORT_TYPE_ONE_KEY_EXP:int = 2;

    protected function report(type:int, ...args):void {
        var s:String = "[包裹]", c:String = "";
        switch (type) {
            case REPORT_TYPE_SYNC :
                break;
            case REPORT_TYPE_ONE_KEY_GOLD :
                    c += "一键金币";
                break;
            case REPORT_TYPE_ONE_KEY_EXP :
                    c += "一键经验";
                break;
        }
        Global.ui.log(s, c);
    }
}
}
