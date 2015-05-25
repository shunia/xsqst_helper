package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

public class Main extends Sprite {

        public function Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild(Ctx.getCtx().ui);

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
        }

    }
}
