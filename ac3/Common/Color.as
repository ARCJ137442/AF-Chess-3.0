package ac3.Common
{
	/* The Class called Color is use for transform color between RGB,HSV,HEX
	 * 0<=R<=256,0<=G<=256,0<=B<=256
	 * 0<=H<=360,0<=S<=100,0<=V<=100
	 * 0x000000<=HEX<=0xffffff
	 * */
	public class Color
	{
		//========================Static Variables========================//
		public static const defaultHEX:uint=0x000000
		public static const defaultRGB:Vector.<Number>=HEXtoRGB(defaultHEX)
		public static const defaultHSV:Vector.<Number>=RGBtoHSV2(defaultRGB)
		
		//========================Static Functions========================//
		//====RGB >> HEX====//
		public static function RGBtoHEX(R:Number,G:Number,B:Number):uint
		{
			if(isNaN(R+G+B))
			{
				return defaultHEX;
			}
			return snapRGBtoUint(R)<<16|snapRGBtoUint(G)<<8|snapRGBtoUint(B);
		}
		
		public static function RGBtoHEX2(RGB:Vector.<Number>):uint
		{
			if(RGB==null||
			   RGB.length!=3)
			{
				return defaultHEX
			}
			return RGBtoHEX(RGB[0] as Number,
							RGB[1] as Number,
							RGB[2] as Number)
		}

		//====HEX >> RGB====//
		public static function HEXtoRGB(I:uint):Vector.<Number>
		{
			var returnVec:Vector.<Number>=new Vector.<Number>(3,true)
			var Re:Number=snapRGB((I>>16))
			var Gr:Number=snapRGB((I-(Re<<16))>>8)
			var Bl:Number=snapRGB(I-(Re<<16)-(Gr<<8))
			returnVec[0]=Re;
			returnVec[1]=Gr;
			returnVec[2]=Bl;
			return returnVec;
		}
		
		//====RGB >> HSV====//
		public static function RGBtoHSV(R:Number,G:Number,B:Number):Vector.<Number>
		{
			//Define Variables
			//Lash Color To 0~100
			var Re:Number=snapRGB(R)/2.55
			var Gr:Number=snapRGB(G)/2.55
			var Bl:Number=snapRGB(B)/2.55
			//Get Report
			var Max:Number=Math.max(Re,Gr,Bl)
			var Min:Number=Math.min(Re,Gr,Bl)
			var Maxin:Number=Max-Min
			var H:Number=0,S:Number=0,V:Number=0
			var returnVec:Vector.<Number>=new Vector.<Number>(3,true)
			//Set Hue
			if(Maxin==0)
			{
				H=NaN
			}
			//Set Saturation
			if(isNaN(H))
			{
				S=0
			}
			else if(Max==Re&&Gr>=Bl)
			{
				H=60*(Gr-Bl)/Maxin+0
			}
			else if(Max==Re&&Gr<Bl)
			{
				H=60*(Gr-Bl)/Maxin+360
			}
			else if(Max==Gr)
			{
				H=60*(Bl-Re)/Maxin+120
			}
			else if(Max==Bl)
			{
				H=60*(Re-Gr)/Maxin+240
			}
			S=Maxin/Max*100
			//Reset Hue
			if(S==0)
			{
				H=NaN
			}
			//Set Brightness
			V=Max
			//Set Return
			returnVec[0]=snapH(H)
			returnVec[1]=snapS(S)
			returnVec[2]=snapV(V)
			return returnVec
		}
		
		public static function RGBtoHSV2(RGB:Vector.<Number>):Vector.<Number>
		{
			if(RGB==null||
				RGB.length!=3)
			{
				return defaultHSV;
			}
			var R:Number=RGB[0]
			var G:Number=RGB[1]
			var B:Number=RGB[2]
			return RGBtoHSV(R,G,B)
		}
		
		//====HSV >> RGB====//
		public static function HSVtoRGB(H:Number,S:Number,V:Number):Vector.<Number>
		{
			//Define Variables
			var R:Number,G:Number,B:Number
			var returnVec:Vector.<Number>=new Vector.<Number>(3,true)
			//Get Report
			var Hu:Number=snapH(H)
			var Sa:Number=snapS(S)
			var Va:Number=snapV(V)
			if(isNaN(Hu))
			{
				R=G=B=Va/100
			}
			else
			{
				var i:uint=Math.floor(Hu/60)
				var f:Number=Hu/60-i
				var h:Number=Va/100
				var p:Number=h*(1-Sa/100)
				var q:Number=h*(1-f*Sa/100)
				var t:Number=h*(1-(1-f)*Sa/100)
				switch(i)
				{
					case 0:
					R=h
					G=t
					B=p
					break
					case 1:
					R=q
					G=h
					B=p
					break
					case 2:
					R=p
					G=h
					B=t
					break
					case 3:
					R=p
					G=q
					B=h
					break
					case 4:
					R=t
					G=p
					B=h
					break
					case 5:
					R=h
					G=p
					B=q
					break
				}
			}
			R*=255
			G*=255
			B*=255
			//Set Return
			returnVec[0]=snapRGB(R)
			returnVec[1]=snapRGB(G)
			returnVec[2]=snapRGB(B)
			return returnVec
		}		

		public static function HSVtoRGB2(HSV:Vector.<Number>):Vector.<Number>
		{
			if(HSV==null||
			   HSV.length!=3)
			{
				return defaultRGB
			}
			var H:Number=HSV[0]
			var S:Number=HSV[1]
			var V:Number=HSV[2]
			return HSVtoRGB(H,S,V)
		}
		
		//====HEX >> HSV====//
		public static function HEXtoHSV(I:uint):Vector.<Number>
		{
			return RGBtoHSV2(HEXtoRGB(I))
		}
		
		//====HSV >> HEX====//
		public static function HSVtoHEX(H:Number,S:Number,V:Number):uint
		{
			return RGBtoHEX2(HSVtoRGB(H,S,V))
		}
		
		public static function HSVtoHEX2(HSV:Vector.<Number>):uint
		{
			return RGBtoHEX2(HSVtoRGB2(HSV))
		}
		
		//====Some Internal Other Function====//
		//======RGB======//
		protected static function snapRGB(value:Number):Number
		{
			if(isNaN(value))
			{
				return 0
			}
			return Math.min(Math.max(0,value),255)
		}
		
		protected static function snapRGBtoUint(value:Number):uint
		{
			if(isNaN(value))
			{
				return 0
			}
			return Math.min(Math.max(0,Math.round(value)),255)
		}
		
		//======HSV======//
		protected static function snapH(value:Number):Number
		{
			if(isNaN(value))
			{
				return NaN
			}
			return Math.min(Math.max(0,value%360),360)
		}
		
		protected static function snapS(value:Number):Number
		{
			if(isNaN(value))
			{
				return 0
			}
			return Math.min(Math.max(0,value),100)
		}
		
		protected static function snapV(value:Number):Number
		{
			return snapS(value)
		}
	}
}