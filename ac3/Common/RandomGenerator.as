package batr.Common
{
	public class RandomGenerator extends Object
	{
		//============Static Variables============//
		public static const DEFAULT_BUFFER:Vector.<Number>=new <Number>[2,1,0]
		
		//============Static Functions============//
		/*
		====Get Buff====
		buffer is Vector.<Number>
		[0] is Zero Index
		Before Zero Index is x^i
		After Zero Index is 1/x^i
		*/
		public static function getBuff(value:Number,buffer:Vector.<Number>):Number
		{
			if(isNaN(value)||buffer==null||buffer.length<2) return NaN
			var zeroIndex:uint=uint(buffer[0])
			var resultNumber:Number=0
			for(var index:uint=1;index<buffer.length;index++)
			{
				var powerNum:Number=zeroIndex-index
				var baseNum:Number=powerNum==0?1:(powerNum==1?value:(powerNum==-1?1/value:(powerNum>0?Math.pow(value,powerNum):1/Math.pow(value,-powerNum))))
				var buffNum:Number=buffer[index]
				resultNumber+=baseNum*buffNum
			}
			return resultNumber
		}
		
		public static function lashToFloat(value:Number,mode:Number):Number
		{
			return (value%mode)/mode
		}
		
		protected static function isEqualNumVec(v1:Vector.<Number>,v2:Vector.<Number>):Boolean
		{
			if(v1.length!=v2.length) return false
			return v1.every(function(n:Number,i:uint,v:Vector.<Number>):Boolean
									 {
										 return v1[i]==v2[i]
									 })
		}
		
		//============Instance Variables============//
		protected var _mode:Number
		protected var _buffer:Vector.<Number>
		protected var _randomList:Vector.<Number>=new Vector.<Number>
		
		//============Init RandomGenerator============//
		public function RandomGenerator(seed:Number=0,mode:Number=0,
										buffer:Vector.<Number>=null,
										length:uint=1):void
		{
			this._mode=mode
			this._buffer=buffer!=null?buffer:RandomGenerator.DEFAULT_BUFFER
			this._randomList[0]=seed
			this.generateNaxt(length)
		}
		
		//============Instance Functions============//
		//======Getters And Setters======//
		public function get seed():Number
		{
			return this._randomList[0]
		}
		
		public function set seed(value:Number):void 
		{
			var reGenerate:Boolean=(value!=this.seed)
			this._randomList[0]=value
			if(reGenerate) dealReset()
		}
		
		public function get mode():Number 
		{
			return this._mode
		}
		
		public function set mode(value:Number):void 
		{
			var reGenerate:Boolean=(value!=this.mode)
			this._mode=value
			if(reGenerate) dealReset()
		}
		
		public function get buffer():Vector.<Number> 
		{
			return this._buffer
		}
		
		public function set buffer(value:Vector.<Number>):void 
		{
			var reGenerate:Boolean=(!isEqualNumVec(this.buffer,value))
			this._buffer=value
			if(reGenerate) dealReset()
		}
		
		public function get numList():Vector.<Number>
		{
			//Include Seed
			return this._randomList
		}
		
		public function get numCount():uint
		{
			//Include Seed
			return this._randomList.length
		}
		
		public function get lastNum():Number
		{
			return this._randomList[this._randomList.length-1]
		}
		
		public function get cycle():uint
		{
			for(var i:uint=0;i<this._randomList.length;i++)
			{
				var li:int=this._randomList.lastIndexOf(this._randomList[i],i)
				if(li>i)
				{
					return li-i
				}
			}
			return uint.MAX_VALUE
		}
		
		//======Public Functions======//
		public function clone():RandomGenerator
		{
			return new RandomGenerator(this.seed,this.mode,this.buffer,this.numCount)
		}
		
		public function equals(other:RandomGenerator,strictMode:Boolean=false):Boolean
		{
			if(this.mode!=other.mode||this.seed!=other.seed) return false
			var i:uint
			for(i=0;i<this.buffer.length;i++)
			{
				if(this.buffer[i]!=other.buffer[i]) return false
			}
			if(strictMode)
			{
				if(this.numCount!=other.numCount) return false
				for(i=1;i<this.numList.length;i++)
				{
					if(this.numList[i]!=other.numList[i]) return false
				}
			}
			return true
		}
		
		public function generateNaxt(count:uint=1):void
		{
			if(count==0) return
			if(count==1)
			{
				this._randomList.push(getBuff(this.lastNum,this.buffer)%this.mode)
				return
			}
			for(var i:uint=0;i<count;i++)
			{
				this._randomList.push(getBuff(this.lastNum,this.buffer)%this.mode)
			}
		}
		
		public function getRandom(index:uint=0):Number
		{
			//index Start At 1
			if(index==0)
			{
				generateNaxt()
				return this.lastNum
			}
			else if(index<this.numCount)
			{
				return this._randomList[index]
			}
			else
			{
				generateNaxt(index-(this.numCount-1))
				return this.lastNum
			}
		}
		
		public function random(buff:Number=1,next:Boolean=true):Number
		{
			//index Start At 1
			return this.getRandom(next?0:this.numCount-1)/this._mode*buff
		}
		
		public function reset():void
		{
			this._randomList.length=1
		}
		
		//======Protected Functions======//
		protected function dealReset()
		{
			var tempCount:uint=this.numCount-1
			this.reset()
			this.generateNaxt(tempCount)
		}
	}
}