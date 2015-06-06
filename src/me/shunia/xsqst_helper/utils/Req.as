/**
 * Created by 庆峰 on 2015/5/18.
 */
package me.shunia.xsqst_helper.utils {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class Req {

        private var _requst:URLRequest = null;
        private var _loader:URLLoader = null;

        public function Req() {
            _loader = new URLLoader();
            _requst = new URLRequest();
        }

        public function load(url:String, isGet:Boolean, data:Object, cb:Function):void {
            _requst.method = isGet ? "GET" : "POST";
            if (!isGet)
                _requst.data = data;
            else
                url += "?" + data.toString();
            _requst.url = url;
			trace("[REQ]", "-->", isGet ? "GET" : "POST", url, data["t"], isGet ? "" : data.toString());
			var f:Function = function (e:Event):void {
				trace("[REQ]", "<--", isGet ? "GET" : "POST", url, data["t"], _loader.data);
				if (cb != null) cb.apply(null, [e.target.data]);
				_loader.removeEventListener(Event.COMPLETE, f);
			};
            _loader.addEventListener(Event.COMPLETE, f);
            _loader.load(_requst);
        }

        public function download(url:String, format:String, cb:Function):void {
            _requst.url = url;
            _loader.dataFormat = format;
			var f:Function = function (e:Event):void {
				if (cb != null) cb.apply(null, [e.target.data]);
				_loader.removeEventListener(Event.COMPLETE, f);
			};
            _loader.addEventListener(Event.COMPLETE, f);
            _loader.load(_requst);
        }

    }
}
