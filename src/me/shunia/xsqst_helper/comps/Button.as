package me.shunia.xsqst_helper.comps
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class Button extends Sprite
	{
		
		protected var _props:Dictionary = null;
		protected var _keySequence:Array = [];
		protected var _labelDisplay:Label = null;
		
		public function Button()
		{
			super();
			_props = new Dictionary();
			_keySequence = [];
		}
		
		public function setProp(k:int, value:*):Button {
			_props[k] = value;
			_keySequence.push(k);
			return this;
		}
		
		public function update():void {
			_keySequence.sort(Array.NUMERIC);
			var k:int = 0, v:* = null;
			while (_keySequence.length) {
				k = _keySequence.shift();
				v = _props[k];
				delete _props[k];
				updateProp(k, v);
			}
		}
		
		protected function updateProp(k:int, value:*):void {
			switch (k) {
				case P_WIDTH : 
					break;
				case P_HEIGHT : 
					break;
			}
		}
		
		public static const P_LABEL:int = 8;
		public static const P_LABEL_COLOR:int = 7;
		public static const P_FRAME_1:int = 6;
		public static const P_FRAME_2:int = 5;
		public static const P_FRAME_3:int = 4;
		public static const P_FRAMES:int = 3;
		public static const P_WIDTH:int = 2;
		public static const P_HEIGHT:int = 1;
		
		
		
	}
}