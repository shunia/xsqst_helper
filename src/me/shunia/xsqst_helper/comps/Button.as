package me.shunia.xsqst_helper.comps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class Button extends Sprite
	{
		
		protected static const STATE_UP:int = 0;
		protected static const STATE_OVER:int = 1;
		protected static const STATE_DOWN:int = 2;
		
		protected static const DEFAULT_LABEL_SIZE:int = 24;
		protected static const DEFAULT_LABEL_COLOR:uint = 0;
		protected static const DEFAULT_V_GAP:int = 5;
		protected static const DEFAULT_H_GAP:int = 10;
		protected static const DEFAULT_SIZE_WIDTH:int = 26;
		protected static const DEFAULT_SIZE_HEIGHT:int = 15;
		
		protected var _props:Dictionary = null;
		protected var _states:Array = null;
		protected var _currentState:int = -1;
		protected var _currentFrame:DisplayObject = null;
		protected var _labelDisplay:Label = null;
		protected var _vgap:int = DEFAULT_V_GAP;
		protected var _hgap:int = DEFAULT_H_GAP;
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		public function Button()
		{
			super();
			_props = new Dictionary();
			buttonMode = true;
			useHandCursor = true;
		}
		
		public function setProp(k:String, value:*):Button {
			_props[k] = value;
			return this;
		}
		
		public function update():Button {
			clear();
			// 先更新label和设置的三态来确认可能的最大高宽,用以后续进行正确的布局
			updateFrame();
			updateLabel();
			updateSize();
			confirmFrame();
			layout();
			ready();
			return this;
		}
		
		protected function safeProp(prop:String, def:*):* {
			var r:* = def;
			if (_props.hasOwnProperty(prop)) {
				r = _props[prop];
				delete _props[prop];
			}
			return r;
		}
		
		public static const P_LABEL:String = "label";
		public static const P_LABEL_COLOR:String = "labelColor";
		public static const P_LABEL_SIZE:String = "labelSize";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_UP:String = "frameUp";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_OVER:String = "frameOver";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_DOWN:String = "frameDown";
		/**
		 * 垂直边距 
		 */		
		public static const P_V_GAP:String = "vGap";
		/**
		 * 水平边距 
		 */		
		public static const P_H_GAP:String = "hGap";
		/**
		 * 如果宽度没有设置,则使用文字或者素材的宽度+hgap*2作为宽度. 
		 */		
		public static const P_WIDTH:String = "width";
		/**
		 * 如果高度没有设置,则使用文字或者素材的高度+vgap*2作为宽度. 
		 */		
		public static const P_HEIGHT:String = "height";
		
		protected function clear():void {
			
		}
		
		/**
		 * 获取设置的三态,用以计算高宽. 
		 */		
		protected function updateFrame():void {
			var up:DisplayObject = safeProp(P_FRAME_UP, null), 
				over:DisplayObject = safeProp(P_FRAME_OVER, null),
				down:DisplayObject = safeProp(P_FRAME_DOWN, null);
			// 三个相互复用
			if (!up && (over || down)) up = over ? over : down;
			if (!over && (up || down)) over = up ? up : down;
			if (!down && (up || over)) down = up ? up : over;
			// 不管怎样先把三态的管理数组初始化,用以后续进行操作和判断
			if (!_states) _states = [null, null, null];
			// 假如三个都没设置,在_states存在的情况下,不做处理,以免把画出来的背景覆盖了
			// 而只要有一个存在,说明要用设置的皮肤
			if (up || over || down) {
				_states[STATE_UP] = up;
				_states[STATE_OVER] = over;
				_states[STATE_DOWN] = down;
			}
		}
		
		/**
		 * 默认当作文字始终存在. 
		 * 当文字实际不存在时,文字显示对象不会对按钮布局产生影响.
		 */		
		protected function updateLabel():void {
			var l:String = safeProp(P_LABEL, ""), 
				s:int = safeProp(P_LABEL_SIZE, _labelDisplay ? _labelDisplay.getTextFormat().size : DEFAULT_LABEL_SIZE), 
				c:uint = safeProp(P_LABEL_COLOR, _labelDisplay ? _labelDisplay.getTextFormat().color : DEFAULT_LABEL_COLOR);
			// init label
			if (!_labelDisplay) {
				_labelDisplay = new Label();
				_labelDisplay.selectable = false;
				_labelDisplay.mouseEnabled = false;
			}
			// update label style
			_labelDisplay.text = l;
			var fmt:TextFormat = _labelDisplay.getTextFormat();
			fmt.size = s;
			fmt.color = c;
			_labelDisplay.defaultTextFormat = fmt;
			// add to displaylist
			if (!contains(_labelDisplay)) 
				addChild(_labelDisplay);
			trace(_labelDisplay.width, _labelDisplay.textWidth);
		}
		
		/**
		 * 收集并整合尺寸信息.在不设置高宽的情况下,将使用按钮现实对象的实际高宽和两侧边距进行计算.
		 * 纯文字按钮也使用同样逻辑.
		 * 可以通过设置P_H_HAP/P_V_GAP来调整按钮实际大小(使用按钮素材或者graphic填充). 
		 */		
		protected function updateSize():void {
			// 获取设置值和当前值当中优先存在的那个
			_hgap = safeProp(P_H_GAP, _hgap);
			_vgap = safeProp(P_V_GAP, _vgap);
			// 需要和当前的文字和三态比较来确认最终的高宽
			var tw:int = safeProp(P_WIDTH, 0),
				th:int = safeProp(P_HEIGHT, 0),
				cw:int, 
				ch:int;
			// 先计算三态的最大高宽
			for each (var s:DisplayObject in _states) {
				if (s && s.width > cw) cw = s.width;
				if (s && s.height > ch) ch = s.height;
			}
			// 再同文字的高宽比较更新最大高宽
			if (hasText) {
				if (cw < _labelDisplay.width) cw = _labelDisplay.width;
				if (ch < _labelDisplay.height) ch = _labelDisplay.height;
			}
			// 优先取设置的高宽,其次取计算的最大高宽,否则使用默认高宽
			if (tw) _w = tw;
			else if (cw) _w = cw;
			else _w = DEFAULT_SIZE_WIDTH;
			if (th) _h = th;
			else if (ch) _h = ch;
			else _h = DEFAULT_SIZE_HEIGHT;
			// plus hgap/vgap
			_w = _w + _hgap * 2;
			_h = _h + _vgap * 2;
		}
		
		/**
		 * 假如有按钮素材,一一对应并使用. 
		 * 如果是文字按钮,画一个空背景.
		 */		
		protected function confirmFrame():void {
			if (!hasFrame) {
				_states[STATE_UP] = getDefaultFrame(STATE_UP);
				_states[STATE_OVER] = getDefaultFrame(STATE_OVER);
				_states[STATE_DOWN] = getDefaultFrame(STATE_DOWN);
			}
		}
		
		protected function getDefaultFrame(index:int):DisplayObject {
			var original:DisplayObject = _states && _states[index] ? _states[index] : null;
			if (!original) {
				switch (index) {
					case STATE_UP : 
						original = drawUp(_w, _h);
						break;
					case STATE_OVER : 
						original = drawOver(_w, _h);
						break;
					case STATE_DOWN : 
						original = drawDown(_w, _h);
						break;
				}
			} else {
				if (original is Frame) {
					Frame(original).resize(_w, _h);
				}
			}
			return original;
		}
		
		protected function drawUp(w:int, h:int):DisplayObject {
			return new Frame(0.99997, w, h);
		}
		
		protected function drawOver(w:int, h:int):DisplayObject {
			var d:DisplayObject = new Frame(0.99998, w, h);
			return d;
		}
		
		protected function drawDown(w:int, h:int):DisplayObject {
			var d:DisplayObject = new Frame(0.99999, w, h);
			d.filters = [
				new DropShadowFilter(1, 45, 0, 0.5, 1, 1, 1, 1, true),
				new DropShadowFilter(1, 225, 0, 0.5, 1, 1, 1, 1, true)
			];
//			d.filters = [new DropShadowFilter(2, 45, 0, 0.7, 2, 2, 1, 1, true)];
			return d;
		}
		
		/**
		 * 因为此时三个状态都已知所以可以计算出按钮最大需要的高宽,然后再以此来计算label的位置.
		 * 假如中间有某个部分不存在,则相应部分无需计算.
		 */		
		protected function layout():void {
			// 居中每个按钮的状态
			var f:DisplayObject = null;
			for (var i:int = 0; i < _states.length; i ++) {
				f = _states[i];
				if (f) {
					f.x = (_w - f.width) / 2;
					f.y = (_h - f.height) / 2;
				}
			}
			// 居中文字
			if (_labelDisplay) {
				_labelDisplay.x = (_w - _labelDisplay.width) / 2;
				_labelDisplay.y = (_h - _labelDisplay.height) / 2;
			}
		}
		
		protected function ready():void {
			state = STATE_UP;
			addEventListener(MouseEvent.ROLL_OVER, onMouseInteraction);
			addEventListener(MouseEvent.ROLL_OUT, onMouseInteraction);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseInteraction);
			addEventListener(MouseEvent.MOUSE_UP, onMouseInteraction);
		}
		
		protected function onMouseInteraction(e:MouseEvent):void {
			switch (e.type) {
				case MouseEvent.ROLL_OUT : 
				case MouseEvent.MOUSE_UP : 
					state = STATE_UP;
					break;
				case MouseEvent.ROLL_OVER : 
					state = STATE_OVER;
					break;
				case MouseEvent.MOUSE_DOWN : 
					state = STATE_DOWN;
					break;
			}
		}
		
		public function set state(value:int):void {
			if (_currentState != value) {
				if (_currentFrame && contains(_currentFrame)) 
					removeChild(_currentFrame);
				_currentState = value;
				_currentFrame = _states[_currentState];
				addChildAt(_currentFrame, 0);
			}
		}
		
		public function get state():int {
			return _currentState;
		}
		
		protected function get hasText():Boolean {
			return _labelDisplay && _labelDisplay.text && _labelDisplay.text.length;
		}
		
		protected function get hasFrame():Boolean {
			return _states && _states[STATE_UP] && !(_states[STATE_UP] is Frame);
		}
		
		override public function set width(value:Number):void {
			setProp(P_WIDTH, value).update();
		}
		override public function get width():Number {
			return _w;
		}
		
		override public function set height(value:Number):void {
			setProp(P_HEIGHT, value).update();
		}
		override public function get height():Number {
			return _h;
		}
		
	}
}
import flash.display.Shape;

class Frame extends Shape {
	
	protected var _mulitple:Number = 1;
	protected var _w:int = 0;
	protected var _h:int = 0;
	protected var _alpha:Number = 1;
	protected var _color:uint = 0x428bca;
	
	public function Frame(multiple:Number, w:int, h:int, alpha:Number = 1, color:uint = 0x428bca) {
		_mulitple = multiple;
		_alpha = alpha;
		_color = color;
		resize(w, h);
	}
	
	public function resize(w:int, h:int):void {
		graphics.clear();
		graphics.beginFill(_color * _mulitple, _alpha);
		graphics.drawRoundRect(0, 0, w, h, 7);
		graphics.endFill();
	}
}