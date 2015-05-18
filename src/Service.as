/**
 * Created by Çì·å on 2015/5/18.
 */
package {
import me.shunia.xsqst_helper.utils.Req;

public class Service {

        public function on(s:String, c:Function):void {
            var b:BS = new R[s](),
                r:Req = new Req(b.url, b.isGet, b.data, function (data:String):void {
                    var d:Object = JSON.parse(data);
                    if (d && d.ret == 0)
                        c.apply(null, [d.data]);
                });
        }

        public var R:Object = {
            "sync_mine_dig_num": sync_mine_dig_num
        };
    }
}

import flash.net.URLVariables;

class BS {

    public var url:String = "http://s1.wangamemxwk.u77.com/service/main.ashx";
    public var isGet:Boolean = false;
    public var data:Object = null;

}

class sync_mine_dig_num extends BS {
    public function sync_mine_dig_num() {
        var v:URLVariables = new URLVariables();
        v["sid"] = "4kynptpzlpjy3cgaqzkznxqy";
        v["t"] = 2003;
        v["userid"] = 9201;
        data = v;
    }
}
