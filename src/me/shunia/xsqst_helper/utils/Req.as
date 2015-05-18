/**
 * Created by Çì·å on 2015/5/18.
 */
package me.shunia.xsqst_helper.utils {
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Req {

        private var _requst:URLRequest = null;
        private var _loader:URLLoader = null;

        public function Req(url:String, isGet:Boolean, data:Object, cb:Function) {
            _loader = new URLLoader();
            _requst = new URLRequest();
            _requst.method = isGet ? "GET" : "POST";
            _requst.data = data;
            _requst.url = url;
            _loader.addEventListener(Event.COMPLETE, function (e:Event):void {
                if (cb != null) cb.apply(null, [e.target.data]);
            });
            _loader.load(_requst);
        }

    }
}
