package org.flixel.aux
{
	import flash.events.KeyboardEvent;
	
	public class FlxInput
	{
		/**
		 * @private
		 */
		internal var _lookup:Object;
		/**
		 * @private
		 */
		internal var _map:Array;
		/**
		 * @private
		 */
		internal const _t:uint = 256;
		
		/**
		 * Constructor
		 */
		public function FlxInput()
		{
			_lookup = new Object();
			_map = new Array(_t);
		}
		
		/**
		 * Updates the key states (for tracking just pressed, just released, etc).
		 */
		public function update():void
		{
			var i:uint = 0;
			while(i < _t)
			{
				var o:Object = _map[i++];
				if(o == null) continue;
				if((o.last == -1) && (o.current == -1)) o.current = 0;
				else if((o.last == 2) && (o.current == 2)) o.current = 1;
				o.last = o.current;
			}
		}
		
		/**
		 * Resets all the keys.
		 */
		public function reset():void
		{
			var i:uint = 0;
			while(i < _t)
			{
				var o:Object = _map[i++];
				if(o == null) continue;
				this[o.name] = false;
				o.current = 0;
				o.last = 0;
			}
		}
		
		/**
		 * Check to see if this key is pressed.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key is pressed
		 */
		public function pressed(Key:String):Boolean { return this[Key]; }
		
		/**
		 * Check to see if this key was just pressed.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key was just pressed
		 */
		public function justPressed(Key:String):Boolean { return _map[_lookup[Key]].current == 2; }
		
		/**
		 * Check to see if this key is just released.
		 * 
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 * 
		 * @return	Whether the key is just released.
		 */
		public function justReleased(Key:String):Boolean { return _map[_lookup[Key]].current == -1; }
		
		/**
		 * Event handler so FlxGame can toggle keys.
		 * 
		 * @param	event	A <code>KeyboardEvent</code> object.
		 */
		public function handleKeyDown(event:KeyboardEvent):void
		{
			var o:Object = _map[event.keyCode];
			if(o == null) return;
			if(o.current > 0) o.current = 1;
			else o.current = 2;
			this[o.name] = true;
		}
		
		/**
		 * Event handler so FlxGame can toggle keys.
		 * 
		 * @param	event	A <code>KeyboardEvent</code> object.
		 */
		public function handleKeyUp(event:KeyboardEvent):void
		{
			var o:Object = _map[event.keyCode];
			if(o == null) return;
			if(o.current > 0) o.current = -1;
			else o.current = 0;
			this[o.name] = false;
		}
		
		/**
		 * If any keys are not "released" (0),
		 * this function will return an array indicating
		 * which keys are pressed and what state they are in.
		 * 
		 * @return	An array of key state data.  Null if there is no data.
		 */
		public function record():Array
		{
			var data:Array = null;
			var i:uint = 0;
			while(i < _t)
			{
				var o:Object = _map[i++];
				if((o == null) || (o.current == 0))
					continue;
				if(data == null)
					data = new Array();
				data.push({code:i-1,value:o.current});
			}
			return data;
		}
		
		/**
		 * Part of the keystroke recording system.
		 * Takes data about key presses and sets it into array.
		 * 
		 * @param	Record	Array of data about key states.
		 */
		public function playback(Record:Array):void
		{
			var i:uint = 0;
			var l:uint = Record.length;
			var o:Object;
			var o2:Object;
			while(i < l)
			{
				o = Record[i++];
				o2 = _map[o.code];
				o2.current = o.value;
				this[o2.name] = true;
			}
		}
		
		/**
		 * An internal helper function used to build the key array.
		 * 
		 * @param	KeyName		String name of the key (e.g. "LEFT" or "A")
		 * @param	KeyCode		The numeric Flash code for this key.
		 */
		protected function addKey(KeyName:String,KeyCode:uint):void
		{
			_lookup[KeyName] = KeyCode;
			_map[KeyCode] = { name: KeyName, current: 0, last: 0 };
		}
		
		public function destroy():void
		{
			_lookup = null;
			_map = null;
		}
	}
}
