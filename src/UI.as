/**
 * Created by qingfenghuang on 2015/5/19.
 */
package {
import flash.display.NativeWindow;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.utils.getTimer;

import mx.controls.TextArea;

public class UI extends Sprite {

        private var _log:TextField = null;
        private var _map:Map = null;

        public function UI() {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        protected function init(e:Object = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            _log = new TextField();
            _log.wordWrap = true;
            _log.width = 300;
            _log.height = stage.stageHeight;
            addChild(_log);
        }

        public function log(...args):void {
            _log.appendText(formatTime());
            _log.appendText(args.join(" "));
            _log.appendText("\n");
        }

        private function formatTime():String {
            var d:Date = new Date(), s:String = "";
            s = d.getSeconds() + ":" + s;
            s = d.getMinutes() + ":" + s;
            s = d.getHours() + ":" + s;
            return "[" + s + "] ";
        }

        public function drawMap(map:Array):void {
            if (!map || map.length == 0 || _map != null) return;

            _map = new Map(map);
        }

    }
}

import flash.display.Graphics;
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindowSystemChrome;
import flash.display.Shape;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

class Map extends NativeWindow {

    private static const W:int = 10;
    private static const H:int = 10;
    private static const C:Array = [0x000000, 0xCCCCCC, 0x83c963, 0xa963c9, 0xe4eb6c, 0xe3541b, 0x8a6354, 0x6dadc7];

    private static var s:Shape = null;

    public function Map(data:Array) {
        var opt:NativeWindowInitOptions = new NativeWindowInitOptions();
        opt.systemChrome = NativeWindowSystemChrome.STANDARD;
        super(opt);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP;
        this.bounds = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        this.addEventListener(Event.ACTIVATE, function (e:Event):void {
            s = new Shape();
            stage.addChild(s);
            init(data);
        });
        this.activate();
    }

    protected function init(data:Array):void {
        var g:Graphics = s.graphics,
            o:Object = null,
            l = data.length;
        g.clear();
        for (var i:int = 0; i < l; i ++) {
            o = data[i];
            g.beginFill(C[o.type]);
            g.drawRect(o.x * W + 1, o.y * H + 1, W, H);
            g.endFill();
        }
    }

}
