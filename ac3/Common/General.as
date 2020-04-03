package ac3.Common
{
	//Flash
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import flash.display.DisplayObject;

	public final class General
	{
		public static function NumberToPercent(x:Number,floatCount:uint=0):String
		{
			if(floatCount>0)
			{
				var pow:uint=Math.pow(10,floatCount);
				var returnNum:Number=Math.floor(x*pow*100)/pow;
				return returnNum+"%";
			}
			return Math.round(x*100)+"%";
		}
		
		public static function NTP(x:Number,floatCount:uint=0):String
		{
			return NumberToPercent(x,floatCount);
		}
		
		//============Boolean Methods============//
		public static function randomBoolean(trueWeight:uint=1,falseWeight:uint=1):Boolean
		{
			return acMath.random(trueWeight+falseWeight,true)<=trueWeight;
		}
		
		public static function randomBoolean2(chance:Number=0.5):Boolean
		{
			return (Math.random()<=chance);
		}
		
		public static function binaryToBooleans(bin:uint,length:uint=0):Vector.<Boolean>
		{
			var l:uint=Math.max(bin.toString(2).length,length);
			var V:Vector.<Boolean>=new Vector.<Boolean>(l,true);
			for(var i:uint=0;i<l;i++)
			{
				V[i]=Boolean(bin>>i&1);
			}
			return V;
		}
		
		public static function booleansToBinary(...boo):uint
		{
			var args:Vector.<Boolean>=new Vector.<Boolean>
			for (var i:uint=0;i<boo.length;i++)
			{
				if(boo[i] is Boolean) args[i]=boo[i]
			}
			return booleansToBinary2(args);
		}
		
		public static function booleansToBinary2(boo:Vector.<Boolean>):uint
		{
			var l:uint=boo.length
			var uin:uint=0
			for (var i:int=l-1;i>=0;i--)
			{
				uin|=uint(boo[i])<<i
			}
			return uin;
		}
		
		//============String Methods============//
		public static function hasSpellInString(spell:String,string:String):Boolean
		{
			return (string.toLowerCase().indexOf(spell)>=0)
		}
		
		public static function splitStringByDelims(string:String,...delims):Array
		{
			return splitStringByDelims2(string,delims);
		}
		
		public static function splitStringByDelims2(string:String,delims:Array):Array
		{
			//Set Result
			var result:Array=new Array();
			//Init Variables
			var delimVec:Vector.<String>=new Vector.<String>;
			var splitedStrings:Array;
			var delim:String;
			var willSplitText:String;
			for each(var item:* in delims)
			{
				delimVec.push(String(item));
			}
			//Operate
			result.push(string);
			for(var i:uint=0;i<=delimVec.length;i++)
			{
				//Init
				delim=delimVec.shift();
				splitedStrings=result.concat();
				result=new Array();
				//Split
				for(var j:uint=0;j<splitedStrings.length;j++)
				{
					willSplitText=splitedStrings[j];
					result=result.concat(willSplitText.split(delim));
				}
			}
			//Return
			return result;
		}
		
		public static function isEmptyChar(char:String):Boolean
		{
			return char=="\n"||char=="\r"||char==""||char==" ";
		}
		
		//Return A New String,Not Change The Original One
		public static function clearCharsInString(string:String,...chars):String
		{
			return clearCharsInString2(string,chars);
		}
		
		public static function clearCharsInString2(string:String,chars:Array):String
		{
			//Set Result
			var result:String="";
			result=splitStringByDelims2(string,chars).join("");
			//Return
			return result;
		}
		
		public static function returnRandom(...Paras):*
		{
			return Paras[acMath.random(Paras.length)]
		}
		
		public static function returnRandom2(Paras:*):*
		{
			if(Paras is Array||Paras is Vector)
			{
				return Paras[acMath.random(Paras.length)]
			}
			else
			{
				return returnRandom3(Paras)
			}
		}
		
		public static function returnRandom3(Paras:*):*
		{
			var Arr:Array=new Array
			for each(var tempVar:* in Paras)
			{
				Arr.push(tempVar)
			}
			return
		}
		
		public static function getPropertyInObject(arr:Array,pro:String):Array
		{
			var ra:Array=new Array()
			for (var i:uint=0;i<arr.length;i++)
			{
				if(pro in arr[i])
				{
					ra.push(arr[i][pro]);
				}
			}
			return ra;
		}
		
		public static function copyObject(object:Object):Object
		{
			var tempObject:ByteArray=new ByteArray()
			tempObject.writeObject(object)
			tempObject.position=0
			return tempObject.readObject() as Object
		}
		
		public static function IsiA(Input:*,Arr:*):Boolean
		{
			if(Arr is Array||Arr is Vector)
			return (Arr.indexOf(Input)>=0)
			else return (Input in Arr)
		}
		
		public static function SinA(Input:*,Arr:Array,Count:uint=0):uint
		{
			if(isEmptyArray(Arr))
			{
				return 0
			}
			var tempCount:uint=Count
			for (var ts:int=Arr.length-1;ts>=0;ts--)
			{
				if(tempCount>0||Count==0)
				{
					if(Input is Array)
					{
						if(IsiA(Arr[ts],Input))
						{
							Arr.splice(ts,1)
							if(tempCount>0) tempCount--
						}
					}
					else if(Arr[ts]==Input)
					{
						Arr.splice(ts,1)
						if(tempCount>0) tempCount--
					}
				}
				else
				{
					break
				}
			}
			return Count-tempCount
		}

		public static function isEmptyArray(A:Array):Boolean
		{
			return (A==null||A.length<1)
		}

		public static function isEmptyString(S:String):Boolean
		{
			return (S==null||S.length<1)
		}

		public static function isEqualArray(A:Array,B:Array):Boolean
		{
			if(A.length!=B.length)
			{
				return false;
			}
			else
			{
				for (var i=0;i<A.length;i++)
				{
					if(A[i]!=B[i]&&A[i]!=null&&B[i]!=null)
					{
						return false;
					}
				}
				return true;
			}
		}
		
		public static function isEqualObject(A:Object,B:Object,
											 IgnoreUnique:Boolean=false,
											 IgnoreVariable:Boolean=false,
											 DontDetectB:Boolean=false):Boolean
		{
			for(var i in A)
			{
				var fa:*=A[i]
				if(B.hasOwnProperty(i)||IgnoreUnique)
				{
					var fb:*=B[i]
					if(!IgnoreVariable)
					{
						if(isPrimitive(fa)==isComplex(fb))
						{
							return false
						}
						else if(isPrimitive(fa))
						{
							if(fa!=fb)
							{
								return false
							}
						}
						else
						{
							if(!isEqualObject(fa,fb))
							{
								return false
							}
						}
					}
				}
				else
				{
					return false
				}
			}
			if(!DontDetectB)
			{
				if(!isEqualObject(B,A,IgnoreUnique,IgnoreVariable,true))
				{
					return false
				}
			}
			return true
		}
		
		public static function isPrimitive(Variable:*):Boolean
		{
			if(Variable==undefined||
			   Variable is Boolean||
			   Variable is int||
			   Variable is null||
			   Variable is Number||
			   Variable is String||
			   Variable is uint/*||
			   Variable is void*/)
			{
				return true
			}
			return false
		}
		
		public static function isComplex(Variable:*):Boolean
		{
			return !isPrimitive(Variable)
		}
	}
}