package me.shunia.xsqst_helper.comps
{
	import flash.utils.Dictionary;
	
	public class Form extends Panel
	{
		
		protected var _f:FormFields = null;
		protected var _onSubmit:Function = null;
		protected var _onCancel:Function = null;
		
		public function Form(onSubmit:Function = null, onCancel:Function = null)
		{
			super();
			_onSubmit = onSubmit;
			_onCancel = onCancel;
			_layout.direction = "vertical";
		}
		
		public function addField(k:String, label:String = null, pwd:Boolean = false):FormField {
			if (!_f) {
				_f = new FormFields();
				add(_f);
			}
			return _f.addField(k, label, pwd);
		}
		
	}
}

import flash.utils.Dictionary;

import me.shunia.xsqst_helper.comps.Input;
import me.shunia.xsqst_helper.comps.Label;
import me.shunia.xsqst_helper.comps.Panel;

class FormFields extends Panel {
	
	protected var _items:Dictionary = null;
	
	public function FormFields() {
		super();
		_items = new Dictionary();
		_layout.direction = "vertical";
	}
	
	public function addField(k:String, label:String = null, pwd:Boolean = false):FormField {
		var f:FormField = null;
		if (_items.hasOwnProperty(k) && _items[k]) f = _items[k];
		else {
			f = new FormField(label, pwd);
			_items[k] = f;
			add(f);
		}
		return _items[k];
	}
	
	public function getValue():Object {
		var o:Object = {};
		for (var k:String in _items) {
			o[k] = _items[k].getValue();
		}
		return o;
	}
	
}

class FormField extends Panel {
	
	protected var _l:Label = null;
	protected var _i:Input = null;
	
	public function FormField(label:String = null, pwd:Boolean = false) {
		super();
		if (label) {
			_l = new Label();
			_l.text = label;
			add(_l);
		}
		_i = new Input();
		add(_i);
	}
	
	public function getValue():String {
		return _i.text;
	}
	
}