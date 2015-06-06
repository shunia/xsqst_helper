package me.shunia.xsqst_helper.comps
{
	import flash.text.TextFieldType;

	public class Input extends Label
	{
		public function Input(w:int = 100, h:int = 35)
		{
			super(false);
			type = TextFieldType.INPUT;
			width = w;
			height = h;
		}
	}
}