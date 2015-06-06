package me.shunia.xsqst_helper.comps
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class Button extends Sprite
	{
		
		protected var _label:String = null;
		protected var _labelDisplay:DisplayObject = null;
		protected var _states:Dictionary = null;
		protected var _content:* = null;
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		public function Button(content:*)
		{
			super();
			this.content = content;
		}
		
		public function set content(value:*):void {
			if (!value) return;
			_content = value;
			clear();
			create();
		}
		
		protected function clear():void {
			
		}
		
		protected function create():void {
			var t:String = typeof _content;
			if (t == "object") {
				if (t is Class) {
					
				} else if (t is MovieClip) {
					
				} else if (t is DisplayObject) {
					
				}
			} else {
				switch (t) {
					case "string" : 
						// 文字按钮,使用底色按钮形式
						break;
					case "class" : 
						break;
					case "displayObject" : 
						break;
				}
			}
		}
		
		protected function updateDisplay():void {
			
		}
		
		override public function set width(value:Number):void {
			_w = value;
			updateDisplay();
		}
		override public function get width():Number {
			return _w;
		}
		
		override public function set height(value:Number):void {
			_h = value;
			updateDisplay();
		}
		override public function get height():Number {
			return _h;
		}
		
	}
}