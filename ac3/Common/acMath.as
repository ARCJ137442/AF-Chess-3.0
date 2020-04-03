package ac3.Common
{
	public final class acMath
	{
		//==============Static Variables==============//
		protected static var PrimeList:Vector.<uint>=new <uint>[2];
		
		//==============Static Functions==============//
		public static function $(x:Number):Number
		{
			return x>0?x:1/(-x);
		}
		
		public static function $i(x:Number,y:Number=NaN):Number
		{
			if(isNaN(y)) y=x<1?-1:1;
			return y<0?-1/(x):x;
		}
		
		public static function sgn(x:Number):int
		{
			return x==0?0:(x>0?1:-1);
		}
		
		public static function random(x:Number,allowFloat:Boolean=false):Number
		{
			if(allowFloat)
			{
				return Math.random()*x;
			}
			return Math.floor(Math.random()*x);
		}
		
		public static function random1():int
		{
			return random(2)*2-1;
		}
		
		public static function randomBetween(x:Number,y:Number,
											allowFloat:Boolean=false):Number
		{
			var h:Number=Math.max(x,y);
			var l:Number=Math.min(x,y);
			if(allowFloat)
			{
				return l+Math.random()*Math.abs(h-l);
			}
			return Math.floor(l+Math.random()*(h-l));
		}
		
		public static function NumTo1(x:Number):int
		{
			return x==0?0:(x>0?1:-1);
		}
		
		public static function isBetween(x:Number,n1:Number,n2:Number,
										 WithL:Boolean=false,
										 WithM:Boolean=false):Boolean
		{
			var m:Number=Math.max(n1,n2);
			var l:Number=Math.min(n1,n2);
			if(WithL&&WithM)
			{
				return x>=l&&x<=m;
			}
			else if(WithL)
			{
				return x>=l&&x<m;
			}
			else if(WithM)
			{
				return x>l&&x<=m;
			}
			return x>l&&x<m;
		}

		public static function RandomByWeight(A:Array):uint
		{
			if(A.length>=1)
			{
				var All=0;
				var i;
				for(i in A)
				{
					if(!isNaN(Number(A[i])))
					{
						All+=Number(A[i]);
					}
				}
				if(A.length==1)
				{
					return 1;
				}
				else
				{
					var R=Math.random()*All;
					for(i=0;i<A.length;i++)
					{
						var N=Number(A[i]);
						var rs=0;
						for(var l=0;l<i;l++)
						{
							rs+=Number(A[l]);
						}
						//trace(R+"|"+(rs+N)+">R>="+rs+","+(i+1))
						if(R>=rs&&R<rs+N)
						{
							return i+1;
						}
					}
				}
			}
			return random(A.length)+1;
		}
		
		public static function RandomByWeight2(...A):uint
		{
			return RandomByWeight(A);
		}

		public static function getSum(A:Array):Number
		{
			var sum:Number=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum3(...numbers):Number
		{
			var sum:Number=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getAverage(A:Array):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage3(...numbers):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++;
				}
			}
			return sum/count;
		}
		
		public static function removeEmptyInArray(A:Array):void
		{
			for(var i:uint=Math.max(A.length-1,0);i>=0;i--)
			{
				if(A[i]==null||
				   isNaN(A[i]))
				{
					A.splice(i,1);
				}
			}
		}
		
		public static function removeEmptyInNumberVector(V:Vector.<Number>):void
		{
			for(var i:uint=Math.max(V.length-1,0);i>=0;i--)
			{
				if(isNaN(V[i]))
				{
					V.splice(i,1);
				}
			}
		}
		
		public static function removeEmptyIn(...List):void
		{
			for each(var i in List)
			{
				if(i is Array)
				{
					removeEmptyInArray(i);
				}
				if(i is Vector.<Number>)
				{
					removeEmptyInNumberVector(i);
				}
			}
		}
		
		public static function getDistance(x1:Number,y1:Number,
										   x2:Number,y2:Number):Number
		{
			return getDistance2(x1-x2,y1-y2);
		}
		
		public static function getDistance2(x:Number,y:Number):Number
		{
			return Math.sqrt(x*x+y*y);
		}
		
		public static function NumberBetween(x:Number,
											num1:Number=Number.NEGATIVE_INFINITY,
											num2:Number=Number.POSITIVE_INFINITY):Number
		{
			//Math.min(num1,num2)<=x<=Math.max(num1,num2)
			return Math.min(Math.max(num1,num2),Math.max(Math.min(num1,num2),x));
		}

		public static function getPrimes(X:Number):Vector.<uint>
		{
			if(X>acMath.LastPrime)
			{
				acMath.LastPrime=X;
				return acMath.PrimeList;
			}
			else
			{
				for(var i:uint=0;i<acMath.PrimeList.length;i++)
				{
					if(acMath.PrimeList[i]>X)
					{
						return acMath.PrimeList.slice(0,i);
					}
				}
				return new Vector.<uint>();
			}
		}

		public static function getPrimeAt(X:Number):uint
		{
			var Vec:Vector.<uint>=new Vector.<uint>();
			var t;
			for(var i:uint=acMath.LastPrime;Vec.length<X;i+=10)
			{
				Vec=getPrimes(i);
			}
			if(Vec.length>=X)
			{
				return Vec[X-1];
			}
			return 2
		}

		public static function isPrime(X:Number):Boolean
		{
			if(Math.abs(X)<2)
			{
				return false;
			}
			if(X>acMath.LastPrime)
			{
				acMath.LastPrime=X
			}
			return acMath.PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										  {
											  return X%p!=0&&X!=p
										  })
		}
		
		protected static function get LastPrime():uint
		{
			return uint(acMath.PrimeList[acMath.PrimeList.length-1])
		}
		
		protected static function set LastPrime(Num:uint):void
		{
			for(var n:uint=acMath.LastPrime;n<=Num;n++)
			{
				if(acMath.PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										   {
											   return (n%p!=0&&n!=p)
										   }))
				{
					acMath.PrimeList.push(n);
				}
			}
		}
	}

}