package ac3.Chess 
{
	import ac3.Common.*;
	
	public class ChessType 
	{
		//============Static Variables============//
		public static const TYPE_DELIM:String="/";
		public static const TYPE_NULL_NAME:String="Nu";
		
		//Types
		public static const NULL:ChessType=null;
		public static const Ra:ChessType=new ChessType("Ra");
		public static const S:ChessType=new ChessType("S");
		public static const D:ChessType=new ChessType("D");
		public static const Si:ChessType=new ChessType("Si");
		public static const Di:ChessType=new ChessType("Di");
		public static const X:ChessType=new ChessType("X");
		public static const H:ChessType=new ChessType("H");
		public static const Ki:ChessType=new ChessType("Ki");
		public static const Ci:ChessType=new ChessType("Ci");
		public static const Cu:ChessType=new ChessType("Cu");
		public static const Co:ChessType=new ChessType("Co");
		public static const F:ChessType=new ChessType("F");
		public static const Sp:ChessType=new ChessType("Sp");
		public static const Gl:ChessType=new ChessType("Gl");
		public static const Pw:ChessType=new ChessType("Pw");
		public static const Tr:ChessType=new ChessType("Tr");
		public static const Sd:ChessType=new ChessType("Sd");
		public static const V:ChessType=new ChessType("V");
		public static const Rk:ChessType=new ChessType("Rk");
		public static const Ca:ChessType=new ChessType("Ca");
		public static const Rc:ChessType=new ChessType("Rc");
		public static const Bs:ChessType=new ChessType("Bs");
		public static const Ic:ChessType=new ChessType("Ic");
		public static const Ir:ChessType=new ChessType("Ir");
		public static const Le:ChessType=new ChessType("Le");
		public static const Ce:ChessType=new ChessType("Ce");
		public static const Re:ChessType=new ChessType("Re");
		public static const Tp:ChessType=new ChessType("Tp");
		public static const Ts:ChessType=new ChessType("Ts");
		public static const Wt:ChessType=new ChessType("Wt");
		public static const Cw:ChessType=new ChessType("Cw");
		public static const Cv:ChessType=new ChessType("Cv");
		public static const Cl:ChessType=new ChessType("Cl");
		public static const Cj:ChessType=new ChessType("Cj");
		public static const Al:ChessType=new ChessType("Al");
		public static const Ia:ChessType=new ChessType("Ia");
		public static const Ae:ChessType=new ChessType("Ae");
		public static const Kc:ChessType=new ChessType("Kc");
		public static const Kx:ChessType=new ChessType("Kx");
		public static const Kl:ChessType=new ChessType("Kl");
		public static const So:ChessType=new ChessType("So");
		public static const St:ChessType=new ChessType("St");
		
		public static const ALL_TYPES:Vector.<ChessType>=new <ChessType>[
		NULL,Ra,S,D,Si,Di,X,H,Ki,Ci,Cu,Co,F,Sp,Gl,Pw,Tr,Sd,V,
		Rk,Ca,Rc,Bs,Ic,Ir,Le,Ce,Re,
		Tp,Ts,Wt,Cw,Cv,Cl,Cj,Al,Ia,Ae,Kc,Kx,Kl,
		So,St];
		
		public static const ENABLE_TYPES:Vector.<ChessType>=new <ChessType>[
		NULL,Ra,S,D,Si,Di,X,H,Ki,Ci,Cu,Co,F,Sp,Gl,Pw,Tr,Sd,V,
		Rk,Ca,Rc,Bs,Ic,Ir,Le,Ce,Re,Tp,Ts,Wt,Cw,Cv,Cj,Al,Ia,Ae,Kc,Kx,Kl];
		
		public static const SWAPABLE_TYPES:Vector.<ChessType>=ENABLE_TYPES.slice(2);
		
		public static const RANDOM_INITIAL_TYPES:Vector.<ChessType>=new <ChessType>[S,D,Si,Di,X,H];
		public static const SPAWNER_SPAWNABLE_TYPES:Vector.<ChessType>=new <ChessType>[Gl];
		public static const COPYFROM_INITIAL_TYPES:Vector.<ChessType>=new <ChessType>[S,D,Si,Di,X,H,Ki,Ci,Co,F,Gl,Pw,Tr,Sd,Rk,Ca,Bs,Ic,Le,Ce,Wt,Al,Ia,Ae,Kc,Kx,Kl];
		public static const COPYFORM_COPYABLE_TYPES:Vector.<ChessType>=new <ChessType>[S,D,Si,Di,X,H,Ki,Ci,Co,F,Gl,Pw,Tr,Sd,Rk,Ca,Rc,Bs,Ic,Ir,Le,Ce,Re,Wt,Cj,Al,Ia,Ae,Kc,Kx,Kl];
		public static const ADVANCE_BONUS_TYPES:Vector.<ChessType>=new <ChessType>[S,Gl,Pw,X,Co,Cw,Cv,Al,Kc,Kx,Kl];
		
		//============Static Getter And Setter============//
		public static function get randomInitial():ChessType
		{
			return RANDOM_INITIAL_TYPES[acMath.random(RANDOM_INITIAL_TYPES.length)];
		}
		
		public static function get randomEnable():ChessType
		{
			return getRandomInTypes(ENABLE_TYPES);
		}
		
		public static function get randomSwapable():ChessType
		{
			return getRandomInTypes(SWAPABLE_TYPES);
		}
		
		public static function get randomEnableWithoutNull():ChessType
		{
			return ENABLE_TYPES[acMath.random(ENABLE_TYPES.length-1)+1];
		}
		
		public static function get randomEnableWithoutUnknown():ChessType
		{
			return randomSwapable;
		}
		
		public static function get randomUnknown():ChessType
		{
			return ENABLE_TYPES[acMath.random(2)];
		}
		
		//============Static Functions============//
		public static function isAllowType(type:ChessType):Boolean
		{
			return ALL_TYPES.some(function(t:ChessType,i:uint,v:Vector.<ChessType>)
								  {
									  return t==type;
								  });
		}
		
		public static function getRandomInTypes(types:Vector.<ChessType>):ChessType
		{
			if(types==null||types.length<1) return null;
			return types[acMath.random(types.length)];
		}
		
		public static function getTypeName(type:ChessType):String
		{
			if(type==null) return "null";
			return type.name;
		}
		
		public static function getTypeByName(name:String):ChessType
		{
			for each(var type:ChessType in ALL_TYPES)
			{
				if(type==null) continue;
				if(type.name==name) return type;
			}
			return ChessType.NULL;
		}
		
		public static function getTypesByString(string:String,delim:String=TYPE_DELIM):Vector.<ChessType>
		{
			var result:Vector.<ChessType>=new Vector.<ChessType>;
			if(string==null||string.length<1) return result;
			var splitArray:Array=string.split(delim);
			for each(var tempString:String in splitArray)
			{
				result.push(ChessType.getTypeByName(tempString));
			}
			return result;
		}
		
		public static function getStringFromTypes(delim:String=TYPE_DELIM,...rest):String
		{
			var result:String="";
			var type:ChessType;
			for(var i:uint=0;i<rest.length;i++)
			{
				if(rest[i] is ChessType)
				{
					type=rest[i];
					result+=ChessType.getTypeName(type);
					if(i<rest.length-1) result+=delim;
				}
			}
			return result;
		}
		
		public static function getStringFromTypes2(types:Vector.<ChessType>,delim:String=TYPE_DELIM):String
		{
			var result:String="";
			var type:ChessType;
			for(var i:uint=0;i<types.length;i++)
			{
				type=types[i];
				result+=ChessType.getTypeName(type);
				if(i<types.length-1) result+=delim;
			}
			return result;
		}
		
		public static function getName(type:ChessType):String
		{
			if(type==null||type.name==null) return TYPE_NULL_NAME;
			return type.name;
		}
		
		public static function getScoreWeight(type:ChessType):uint
		{
			switch(type)
			{
				case ChessType.NULL:
				case ChessType.So:
				case ChessType.St:
					return 0;
				default:
				case ChessType.S:
				case ChessType.D:
				case ChessType.X:
				case ChessType.Gl:
					return 1;
				case ChessType.Pw:
				case ChessType.Si:
				case ChessType.Di:
				case ChessType.H:
				case ChessType.Ra:
					return 2;
				case ChessType.V:
				case ChessType.Ki:
				case ChessType.Cu:
				case ChessType.F:
				case ChessType.Sd:
				case ChessType.Cj:
				case ChessType.Kl:
					return 3;
				case ChessType.Rk:
				case ChessType.Ca:
				case ChessType.Rc:
				case ChessType.Bs:
				case ChessType.Ic:
				case ChessType.Ir:
				case ChessType.Al:
				case ChessType.Ia:
					return 4;
				case ChessType.Sp:
				case ChessType.Tp:
				case ChessType.Ts:
				case ChessType.Wt:
				case ChessType.Kc:
				case ChessType.Kx:
					return 5;
				case ChessType.Ci:
				case ChessType.Co:
				case ChessType.Tr:
				case ChessType.Cw:
				case ChessType.Cv:
					return 5;
				case ChessType.Le:
				case ChessType.Ce:
				case ChessType.Re:
				case ChessType.Ae:
					return 6;
				case ChessType.Cl:
					return 7;
			}
		}
		
		public static function getSuicideOnEat(type:ChessType):Boolean
		{
			return (type==ChessType.X);
		}
		
		public static function getCopyMoveWaysOnEat(type:ChessType):Boolean
		{
			return (type==ChessType.Co);
		}
		
		public static function getUseLevelOnTeleport(type:ChessType):Boolean
		{
			return (type==ChessType.Tp||type==ChessType.Pw);
		}
		
		public static function getNeedCopyMoveWays(type:ChessType):Boolean
		{
			return (type==ChessType.Cu);
		}
		
		public static function getImmuneActions(type:ChessType):Boolean
		{
			return (type==ChessType.So);
		}
		
		public static function getOnlyBeAttack(type:ChessType):Boolean
		{
			return (type==ChessType.St);
		}
		
		public static function getCanBeMindContol(type:ChessType):Boolean
		{
			switch(type)
			{
				case ChessType.NULL:
				case ChessType.Ra:
				case ChessType.So:
				case ChessType.St:
					return false;
			}
			return true;
		}
		
		public static function getCanBeCapture(type:ChessType):Boolean
		{
			switch(type)
			{
				case ChessType.NULL:
				case ChessType.So:
				case ChessType.St:
					return false;
			}
			return true;
		}
		
		public static function getCanBeCopyWay(type:ChessType):Boolean
		{
			switch(type)
			{
				case ChessType.NULL:
				case ChessType.Ra:
				case ChessType.Cw:
				case ChessType.Cv:
				case ChessType.Cl:
				case ChessType.So:
				case ChessType.St:
					return false;
			}
			return true;
		}
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function ChessType(name:String):void
		{
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		//============Instance Functions============//
	}
}