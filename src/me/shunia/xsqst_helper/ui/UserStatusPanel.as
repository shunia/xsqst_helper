/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.ui {
import me.shunia.xsqst_helper.User;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.utils.Timer;

public class UserStatusPanel extends Panel {

    private static const INTERVAL:int = 3;

    private var _user:User = null;

    public function UserStatusPanel(user:User) {
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

import me.shunia.xsqst_helper.User;
import me.shunia.xsqst_helper.comps.Label;
import me.shunia.xsqst_helper.comps.Panel;
import me.shunia.xsqst_helper.module.Mine;
import me.shunia.xsqst_helper.module.PVP;
import me.shunia.xsqst_helper.utils.Time;

class UserPanel extends Panel {

    public function UserPanel(d:User) {
        layout.direction = "vertical";

        add(label("名: " + d.name));
        add(label("金: " + d.jb));
        add(label("钻: " + d.xz));
        add(label("食: " + d.m_food.hunger));
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

        add(label("竞时: " + Time.secToFull(d.refresh_time)));
        add(label("竞数: " + d.f_num));
        add(label("竞剩: " + (d.oponentsNotFight ? String(d.oponentsNotFight.length) : String(0))));
    }

    protected function label(t:String):Label {
        var l:Label = new Label();
        l.text = t;
        return l;
    }
}
