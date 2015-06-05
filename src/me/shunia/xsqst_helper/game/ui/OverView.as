/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.ui {
import flash.display.Sprite;
import flash.events.Event;

import me.shunia.xsqst_helper.game.Avatar;
import me.shunia.xsqst_helper.game.Ctx;
import me.shunia.xsqst_helper.game.ICtxCls;

public class OverView extends Sprite implements ICtxCls {

    private var _log:LogPanel = null;
    private var _settings:SettingsPanel = null;
    private var _user:UserStatusPanel = null;

    private var _map:Map = null;

    public function OverView() {
		_log = new LogPanel();
		addChild(_log);
    }

    protected function layout():void {
		if (!stage) return;
		
        _user.x = 0;
        _user.y = 0;

        _settings.y = 0;
        _settings.x = stage.stageWidth - _settings.width;

        _log.x = 0;
        _log.y = _user.height;
        _log.width = stage.stageWidth - _settings.width;
        _log.height = stage.stageHeight - _user.height;
    }

    public function log(...args):void {
        if (_log) _log.log(args);
    }

    public function drawMap(map:Array):void {
        if (!map || map.length == 0 || _map != null) return;

        _map = new Map(map);
    }
	
	protected var _ctx:Ctx = null;
	public function set ctx(value:Ctx):void {
		_ctx = value;
		
		onCtxInited();
	}
	public function get ctx():Ctx {
		return _ctx;
	}
	
	public function onCtxInited():void {
		_e(_ctx).on("userSynced", function (t:String, user:Avatar):void {
			if (!_user) {
				_user = new UserStatusPanel(user);
				_settings = new SettingsPanel(user);
				addChild(_user);
				addChild(_settings);
			}
			
			layout();
		});
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
            l:int = data.length;
        g.clear();
        for (var i:int = 0; i < l; i ++) {
            o = data[i];
            g.beginFill(C[o.type]);
            g.drawRect(o.x * W + 1, o.y * H + 1, W, H);
            g.endFill();
        }
    }

}
