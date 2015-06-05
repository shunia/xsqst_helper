/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Panel extends Sprite{
		
	    protected var _layout:Layout = new Layout();
		protected var _debug:Boolean = false;
		
		public function set debug(value:Boolean):void {
			_debug = value;
			paint();
		}
	    public function get layout():Layout {
	        return _layout;
	    }
	    public function get elements():Array {
	        return _layout.elms;
	    }
		
	    public function add(d:DisplayObject):DisplayObject {
	        addChild(d);
	        _layout.add(d);
			paint();
	        return d;
	    }
		
		protected function paint():void {
			graphics.clear();
			var c:int = _debug ? Math.random() * 0xFFFFFF : 0;
			var a:int = _debug ? 1 : 0;
			graphics.beginFill(c, a);
			graphics.drawRect(0, 0, _layout.width, _layout.height);
			graphics.endFill();
		}
	
	    public function clear():void {
	        while (numChildren) removeChildAt(0);
	        _layout.addElms([]);
	        graphics.clear();
	    }
	
	}
}
