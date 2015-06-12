package me.shunia.xsqst_helper.comps
{
	import flash.text.TextFieldType;

	public class Input extends Label
	{
		public function Input(w:int = 100, h:int = 22)
		{
			super(false);
			type = TextFieldType.INPUT;
			width = w;
			height = h;
			border = true;
		}
	}
}