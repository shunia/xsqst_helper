package {
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import me.shunia.context.ContextualStage;
	import me.shunia.xsqst_helper.player.Player;
	import me.shunia.xsqst_helper.player.PlayerManager;
	import me.shunia.xsqst_helper.view.S;
	
	public class Main extends ContextualStage {
		
		protected var _error:String = "";
		protected var _s:S = null;
		
        override protected function init():void {
			_s = new S();
			addChild(_s);
			
//			new Updater("app:/update_conf.xml");
			
			var pm:PlayerManager = new PlayerManager();
			_e(pm).on("playerAdded", onAddPlayer);
			pm.init();
			
//            new Req().download(
//                "http://res.mxwk.90tank.com/Res1017/BraveRistOfficial.swf?2.2.7",
//                function (data:Object):void {
//                    var ba:ByteArray = data as ByteArray;
//                    var loader:Loader = new Loader();
//                    var ctx:LoaderContext = new LoaderContext();
//                    ctx.allowCodeImport = true;
//                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Object):void {
//                        var a:DisplayObject = loader.contentLoaderInfo.content;
//                        addChild(a);
////                        trace(a.loaderInfo.applicationDomain.getQualifiedDefinitionNames());
//                    });
//                    loader.loadBytes(ba, ctx);
//                });
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);
			addEventListener(Event.ACTIVATE, onActivate);
			addEventListener(KeyboardEvent.KEY_UP, onKeyDown);
        }
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (event.altKey && event.ctrlKey && event.keyCode == Keyboard.NUMBER_1) {
				if (_error) 
					System.setClipboard(_error);
				_error = "";
			}
		}
		
		protected function onActivate(event:Event):void
		{
			if (!hasEventListener(KeyboardEvent.KEY_UP)) addEventListener(KeyboardEvent.KEY_UP, onKeyDown);
		}
		
		protected function onError(e:UncaughtErrorEvent):void {
			_error += e.toString() + "\n";
		}
		
		protected function onAddPlayer(p:Player):void {
			
		}

    }
}
