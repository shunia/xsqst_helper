package me.shunia.xsqst_helper.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import me.shunia.xsqst_helper.comps.Form;
	import me.shunia.xsqst_helper.Player;
	
	public class LoginPopup extends Sprite
	{
		
		protected var _u:String = null;
		protected var _p:String = null;
		
		// 半透明灰色遮罩
		protected var _m:Shape = null;
		protected var _form:Form = null;
		
		public function LoginPopup(args:Array)
		{
			super();
			args.length ? (_u = args[0]) : (_p = "");
			args.length > 1 ? (_p = args[1]) : (_p = "");
			
			// 遮罩
			_m = new Shape();
			addChild(_m);
			
			// form
			_form = new Form(onSubmit, onCancel, "登陆");
			_form.addField("userName", "用户名: ", "shunia@qq.com");
			_form.addField("password", "和密码: ", "7758258hqf", true);
			addChild(_form);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (_m.width != stage.stageWidth || _m.height != stage.stageHeight) {
				_m.graphics.clear();
				_m.graphics.beginFill(0, 0.7);
				_m.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_m.graphics.endFill();
			}
			_form.x = (width - _form.width) / 2;
			_form.y = (height - _form.height) / 2;
		}
		
		protected function onSubmit():void {
			var d:Object = _form.getValue();
			if (d) {
				new WangaLogin(d.userName, d.password, 
					function (error:Object = null, result:Object = null):void {
						if (result) {
							Player.current().update(result);
							hide();
						}
					});
			}
		}
		
		protected function onCancel():void {
			hide();
		}
		
		public function show():void {
			_("stage").addChild(this);
		}
		
		public function hide():void {
			if (parent) parent.removeChild(this);
		}
		
		protected static var _i:LoginPopup = null;
		public static function init(...args):LoginPopup {
			if (_i == null) _i = new LoginPopup(args);
			return _i;
		}
		
	}
}
import flash.net.URLRequestHeader;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import me.shunia.xsqst_helper.GeneralService;
import me.shunia.xsqst_helper.utils.P;
import me.shunia.xsqst_helper.utils.ReqParams;
import me.shunia.xsqst_helper.utils.WebCookie;

class WangaLogin {
	
	protected var R:Object = {
		"get_mbgc_cookie":
			ReqParams.g('{"_":"{time}"}')
			.url("http://wanga.me/comment/wanga/get-csrf.json")
			.res(true)
			.post(false),
		"get_csrf": 
			ReqParams.g('{"_":"{time}"}')
			.url("http://wanga.me/passport/login.json")
			.res(true)
			.post(false),
		"login":
			ReqParams.g('{"email":"{0}", "password":"{1}", "_csrf":"{2}"}')
			.url("http://wanga.me/passport/login.json")
			.res(true),
		"redirect":
			ReqParams.g('{"reqHeader":"{0}"}')
			.url("http://wanga.me/other/xsqst.php")
			.post(false),
		"get_sid":
			ReqParams.g()
			.res(true)
			.post(false),
		"load_game": 
			ReqParams.g('{"t":"{time}","sid":"{0}"}')
			.url("http://s1.wangamemxwk.u77.com/Scripts/LoadGame.ashx")
			.post(false)
	};
	
	protected var _userName:String = null;
	protected var _password:String = null;
	protected var _cb:Function = null;
	protected var _retry:int = 3;
	
	protected var _result:Object = null;
	
	public function WangaLogin(userName:String, password:String, cb:Function) {
		_userName = userName;
		_password = password;
		_cb = cb;
		start();
	}
	
	protected function start():void {
		new P()
			.then(getMbgcCookie)
			.then(getCsrf)
			.then(getLoginResult)
			.then(getPageRedirection)
			.then(getActualContent)
			.then(_cb)
			.error(function (error:*):void {
				if (_retry == 0) {
					trace("[WangaLogin]", "[Error]", error);
					return;
				}
				_retry --;
				var interval:uint = setInterval(function ():void {
					clearInterval(interval);
					start();
				}, 200);
			});
	}
	
	protected function getMbgcCookie(cb:Function, ...args):void {
		var fakeHeader:Array = [];
		fakeHeader.push(new URLRequestHeader("Host", "wanga.me"));
		GeneralService.on(
			R["get_mbgc_cookie"].header(fakeHeader), 
			function (result:Object, ...args):void {
				WebCookie.from("/").save(args[0]);
				cb.apply(null, [null]);
			});
	}
	
	protected function getCsrf(cb:Function, ...args):void {
		GeneralService.on(
			R["get_csrf"], 
			function (result:String, ...args):void {
				WebCookie.from("/").save(args[0]);
				cb.apply(null, [null, JSON.parse(result)]);
			});
	}
	
	protected function getLoginResult(cb:Function, ...args):void {
		GeneralService.on(
			R["login"].args([_userName, _password, args[0].csrf]).header(currentCookie), 
			function (result:String, ...args):void {
				_result = JSON.parse(result);
				WebCookie.from("/").save(args[0]).saveWithRaw("mbg_authcode", _result.authcode);
				cb.apply(null, [null]);
			});
	}
	
	protected function getPageRedirection(cb:Function, ...args):void {
		GeneralService.on(
			R["redirect"].header(currentCookie), 
			function (result:String, ...args):void {
				var reg:RegExp = new RegExp(/= '([^']*)'/g);
				// 相当于取了 $1
				var url:String = reg.exec(result)[1];
				cb.apply(null, [null, url]);
			});
	}
	
	protected function getActualContent(cb:Function, ...args):void {
		// set-cookie ASP.NET_SessionId=xxx
		GeneralService.on(
			R["get_sid"].url(args[0]), 
			function (result:String, ...args):void {
				WebCookie.from().save(args[0]);
				var sidReg:RegExp = new RegExp(/='([^']*)'/g);
				var uidReg:RegExp = new RegExp(/LoadGame\(([^\)]*)\)/g);
				// 相当于取了 $1
				var sid:String = sidReg.exec(result)[1];
				var uid:String = uidReg.exec(result)[1];
				uid = uid.split(",")[1];
				_result.sid = sid;
				_result.uid = uid;
				cb.apply(null, [null, _result]);
			});
	}
	
	protected function activeSession(cb:Function, ...args):void {
		GeneralService.on(
			R["load_game"].args(args[0].sid),
			function (result:String, ...args):void {
				cb.apply(null, [null]);
			});
	}
	
	protected function get currentCookie():URLRequestHeader {
		return WebCookie.from().toHeader();
	}
	
}