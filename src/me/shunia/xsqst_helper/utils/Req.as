/**
 * Created by 庆峰 on 2015/5/18.
 */
package me.shunia.xsqst_helper.utils {
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class Req {

        private var _requst:URLRequest = null;
        private var _loader:URLLoader = null;

        public function Req() {
            _loader = new URLLoader();
            _requst = new URLRequest();
        }

        public function load(url:String, isGet:Boolean, data:Object, cb:Function, reqHeader:Array = null, rspHeader:Boolean = false):void {
			var h:Object = null, isDesktop:Boolean = Capabilities.playerType == "Desktop";
			// init request header and response header
			rspHeader = rspHeader && isDesktop;
			reqHeader = isDesktop && reqHeader ? reqHeader : null;
			// setup request header
			_requst.requestHeaders = reqHeader;
			// request method
            _requst.method = isGet ? "GET" : "POST";
			// setup request parameters
            if (!isGet)
                if (data) _requst.data = data;
            else
                if (data) url += "?" + data.toString();
			// setup url
            _requst.url = url;
			// trace log
			trace("[REQ]", "-->", isGet ? "GET" : "POST", url, data && data["t"] ? data["t"] : "", isGet ? "" : data ? data.toString() : "");
			// define call back function for loading complete
			var f:Function = function (e:Event):void {
				trace("[REQ]", "<--", isGet ? "GET" : "POST", url, data && data["t"] ? data["t"] : "", _loader.data);
				var result:Array = [e.target.data];
				if (h) result.push(h);
				if (cb != null) cb.apply(null, result);
				_loader.removeEventListener(Event.COMPLETE, f);
			};
			// start listening
            _loader.addEventListener(Event.COMPLETE, f);
			// setup response header
			if (rspHeader) {
				// if possible, listen for response headere event
				_loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function (e:HTTPStatusEvent):void {
					h = e.responseHeaders;
				});
			}
			// start load
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
