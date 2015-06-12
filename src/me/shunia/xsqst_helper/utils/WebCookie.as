package me.shunia.xsqst_helper.utils
{
	import flash.net.URLRequestHeader;
	import flash.utils.Dictionary;

	/**
	 * Web cookie管理类.
	 *  
	 * @author qingfenghuang
	 */	
	public class WebCookie
	{
		
//		protected static const DEFAULT_DOMAIN:String = "/";
		
		protected static var _all:Dictionary = null;
		protected var _cookies:Object = null;
		protected var _currentDomain:String = "/";
		
		public function WebCookie(domain:String = "/")
		{
			_currentDomain = domain;
		}
		
		public static function from(domain:String = "/"):WebCookie {
			if (!_all) _all = new Dictionary();
			if (!_all.hasOwnProperty(domain)) {
				// create an empty cookie
				_all[domain] = new WebCookie(domain);
			}
			return _all[domain];
		}
		
		public function save(params:Array):WebCookie {
			if (params) {
				if (!_cookies) _cookies = {};
				var split:Array = null;
				for each (var h:URLRequestHeader in params) {
					if (h.name.toLowerCase() == "set-cookie") {
						split = h.value.split("=");
						_cookies[split[0]] = split[1];
					}
				}
			}
			return this;
		}
		
		public function saveWithRaw(k:String, v:String):WebCookie {
			_cookies[k] = v;
			return this;
		}
		
		public function get currentDomain():String {
			return _currentDomain;
		}
		
		public function g(k:String):String {
			return (_cookies && _cookies.hasOwnProperty(k)) ? _cookies[k] : null;
		}
		
		public function toString(...args):String {
			var s:String = "";
			for (var k:String in _cookies) {
				if (args.indexOf(k) == -1) 
					s += k + "=" + _cookies[k].split("; ")[0] + ";"
			}
			s = s.substr(0, s.length - 1);
			return s;
		}
		
		public function toHeader(...args):URLRequestHeader {
			var h:URLRequestHeader = new URLRequestHeader("Cookie");
			h.value = toString.apply(null, args);
			return h;
		}
		
	}
}