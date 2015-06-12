/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Panel extends Sprite{
		
	    protected var _layout:Layout = new Layout(paint);
		protected var _debug:Boolean = false;
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		override public function set width(value:Number):void {
			if (value && value != _w) {
				_w = value;
				paint();
			}
		}
		override public function get width():Number {
			return _w ? _w : _layout.width;
		}
		
		override public function set height(value:Number):void {
			if (value && value != _h) {
				_h = value;
				paint();
			}
		}
		override public function get height():Number {
			return _h ? _h : _layout.height;
		}
		
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
	        return d;
	    }
		
		public function remove(d:DisplayObject):void {
			if (d && contains(d)) {
				removeChild(d);
				_layout.remove(d);
			}
		}
		
		public function removeAll():void {
			for (var d:DisplayObject in _layout.elms) {
				remove(d);
			}
		}
		
		protected function paint():void {
			graphics.clear();
			var c:int = _debug ? Math.random() * 0xFFFFFF : 0;
			var a:int = _debug ? 1 : 0;
			graphics.beginFill(c, a);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	
	    public function clear():void {
	        while (numChildren) removeChildAt(0);
	        _layout.addElms([]);
	        graphics.clear();
	    }
	
	}
}
