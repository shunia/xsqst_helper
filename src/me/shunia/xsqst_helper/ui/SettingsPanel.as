/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.ui {

import flash.net.URLLoaderDataFormat;
import flash.utils.describeType;

import me.shunia.xsqst_helper.User;

import me.shunia.xsqst_helper.comps.CheckBox;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.utils.Req;

public class SettingsPanel extends Panel {

    private var _settings:Object = null;
    private var _cbs:Object = null;
    private var _user:User = null;

    public function SettingsPanel(user:User) {
        super();

        layout.direction = "vertical";
        _user = user;

        new Req().download(
                "config/settings.json",
                URLLoaderDataFormat.TEXT,
                function (data:Object):void {
                    _settings = JSON.parse(data as String);

                    update();
                });

        _cbs = {};
        _cbs[PROPS.GIFT] = add(new CheckBox("自动送礼", function (selected:Boolean):void {
            _user.m_mine.itl_enabled = selected;
        }));
        _cbs[PROPS.MINE] = add(new CheckBox("自动挖矿", function (selected:Boolean):void {
            _user.m_mine.itl_enabled = selected;
        }));
        _cbs[PROPS.PVP] = add(new CheckBox("自动PVP", function (selected:Boolean):void {
            _user.m_pvp.itl_enabled = selected;
        }));
        _cbs[PROPS.MAZE] = add(new CheckBox("自动战斗", function (selected:Boolean):void {
            _user.m_maze.itl_enabled = selected;
        }));
        _cbs[PROPS.BAG] = add(new CheckBox("自动清包", function (selected:Boolean):void {
            _user.m_bag.itl_enabled = selected;
        }));
        _cbs[PROPS.SUMMON] = add(new CheckBox("自动召唤", function (selected:Boolean):void {
            _user.m_summon.itl_enabled = selected;
        }));
        _cbs[PROPS.FOOD] = add(new CheckBox("自动吃喝", function (selected:Boolean):void {
            _user.m_food.itl_enabled = selected;
        }));
    }

    protected function update():void {
        var x:XML = describeType(PROPS);
        trace(x..constant);
        for each (var i:XML in x..constant) {
            var k:String = i.@type == "String" ? PROPS[i.@name] : null;
            if (k && _cbs.hasOwnProperty(k))
                _cbs[k].selected = _settings.hasOwnProperty(k) && _settings[k];
        }
        _user.start();
    }

}
}

class PROPS {
    public static const PVP:String = "PVP";
    public static const MINE:String = "mine";
    public static const MAZE:String = "maze";
    public static const SUMMON:String = "summon";
    public static const BAG:String = "bag";
    public static const FOOD:String = "food";
    public static const GIFT:String = "gift";
}

