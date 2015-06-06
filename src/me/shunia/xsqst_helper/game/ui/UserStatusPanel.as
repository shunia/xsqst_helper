/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.game.ui {
import me.shunia.xsqst_helper.game.Avatar;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.utils.Timer;

public class UserStatusPanel extends Panel {

    private static const INTERVAL:int = 3;

    private var _user:Avatar = null;

    public function UserStatusPanel(user:Avatar) {
        _user = user;
        super();

        new Timer(INTERVAL, 0, function ():void {
            update();
        });
    }

    protected function update():void {
        clear();
        add(new UserPanel(_user));
        add(new MinePanel(_user.m_mine));
        add(new PVPPanel(_user.m_pvp));
    }
}
}

import me.shunia.xsqst_helper.game.Avatar;
import me.shunia.xsqst_helper.comps.Label;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.game.module.Mine;
import me.shunia.xsqst_helper.game.module.PVP;
import me.shunia.xsqst_helper.utils.Time;

class UserPanel extends Panel {

    public function UserPanel(d:Avatar) {
        layout.direction = "vertical";

        add(label("名字: " + d.name));
		add(label("战力: " + d.m_hero.totalPower));
        add(label("金币: " + d.jb));
        add(label("血钻: " + d.xz));
        add(label("饱食: " + d.m_food.hunger));
    }

    protected function label(t:String):Label {
        var l:Label = new Label();
        l.text = t;
        return l;
    }
}

class MinePanel extends Panel {
    public function MinePanel(d:Mine) {
        layout.direction = "vertical";

        add(label("镐时: " + Time.secToFull(d.refreshTime)));
        add(label("镐数: " + d.digTime));
		add(label("黄人: " + d.monsterNum));
        for (var i:int = 0; i < d.house.queue.length; i ++) {
            add(label("坊时: " + Time.secToFull(d.house.queue[i].time)));
        }
    }

    protected function label(t:String):Label {
        var l:Label = new Label();
        l.text = t;
        return l;
    }
}

class PVPPanel extends Panel {
    public function PVPPanel(d:PVP) {
        layout.direction = "vertical";

        add(label("竞时: " + Time.secToFull(d.refreshTime)));
        add(label("竞数: " + d.fNum));
        add(label("竞胜: " + d.win));
    }

    protected function label(t:String):Label {
        var l:Label = new Label();
        l.text = t;
        return l;
    }
}