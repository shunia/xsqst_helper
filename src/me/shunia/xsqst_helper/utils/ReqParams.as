package me.shunia.xsqst_helper.utils
{
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;

	public class ReqParams
	{
		/**
		 * 链接地址 
		 */	
		public var u:String = null;
		/**
		 * 是否get,默认为post 
		 */	
		public var g:Boolean = false;
		/**
		 * 数据 
		 */	
		public var d:Object = null;
		/**
		 * http请求附加的头信息 
		 */	
		public var reqHeader:Array = null;
		/**
		 * 是否从http请求中获取返回的头信息 
		 */	
		public var resHeader:Boolean = false;
		
		protected var _json:String = null;
		protected var _base:Object = null;
		protected var _args:Array = null;
		protected var _oed:Boolean = false;
		
		public function ReqParams(jsonConf:String = null)
		{
			_oed = false;
			_json = jsonConf;
		}
		
		public static function g(jsonConf:String = null):ReqParams {
			return new ReqParams(jsonConf);
		}
		
		public function url(s:String):ReqParams {
			_oed = false;
			u = s;
			return this;
		}
		
		public function post(b:Boolean):ReqParams {
			g = !b;
			return this;
		}
		
		/**
		 * 是否从http请求中获取返回的头信息 
		 */	
		public function res(b:Boolean):ReqParams {
			resHeader = b;
			return this;
		}
		
		public function header(v:*):ReqParams {
			if (v is URLRequestHeader) {
				if (!reqHeader) reqHeader = [];
				reqHeader.push(v);
			} else if (v is Array) {
				reqHeader = reqHeader ? (v as Array).concat(reqHeader) : v;
			}
			return this;
		}
		
		public function args(args:Array):ReqParams {
			_oed = false;
			_args = args;
			return this;
		}
		
		public function o():ReqParams {
			if (!_oed) _oed = true;
			if (_json) {
				_json = rpl(_json, "{time}", String(int(Math.random() * 1000000) + Math.random()));
				if (_args && _args.length) {
					for (var i:int = 0; i < _args.length; i ++) {
						_json = rpl(_json, "{" + i + "}", _args[i]);
					}
				}
				var json:Object = JSON.parse(_json);
				var v:URLVariables = new URLVariables();
				for (var k:String in json) {
					v[k] = json[k];
				}
				d = v;
			}
			return this;
		}
		
		protected function rpl(s:String, tag:String, to:String):String {
			if (s.indexOf(tag) != -1) return s.replace(tag, to);
			return s;
		}
	}
}