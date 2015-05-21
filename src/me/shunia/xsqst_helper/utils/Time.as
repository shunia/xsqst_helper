/**
 * Created by qingfenghuang on 2015/5/20.
 */
package me.shunia.xsqst_helper.utils {
public class Time {
    public function Time() {
    }

    public static function secToFull(sec:int):String {
        var s:String = "";
        s +=  fillFront(String(Math.floor(sec / 60 / 60)));         // 小时
        s += ":" + fillFront(String(Math.floor(sec / 60 % 60)));       // 分钟
        s += ":" + fillFront(String(sec % 60));            // 秒
        return s;
    }

    public static function getLocal():String {
        var d:Date = new Date(), s:String = "";
        s = fillFront(String(d.getSeconds())) + "";
        s = fillFront(String(d.getMinutes())) + ":" + s;
        s = fillFront(String(d.getHours())) + ":" + s;
        return s;
    }

    protected static function fillFront(s:String, l:int = 2, p:String = "0"):String {
        if (s.length < l) {
            var n:int = l - s.length;
            for (var i:int = 0; i < n; i ++) {
                s = p + s;
            }
        }
        return s;
    }

}
}
