/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	import me.shunia.xsqst_helper.Service;

public class Hero extends BaseModule{

    public var total_power:int = 0;
    public var fight_num:int = 0;
    public var fight_num_max:int = 0;
    public var total_num:int = 0;

    public function Hero() {
    }

    override public function sync(cb:Function = null):void {
        Service.on("sync_hero", function (data:Object):void {
            total_power = data.battlevalue;
            fight_num = data.playingcount;
            fight_num_max = data.playingcountmax;
            total_num = data.list.length;
            _c(cb);
        });
    }

    public function init(o:Array):void {

    }
}
}
