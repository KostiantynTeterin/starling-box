package flashjack
{
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Niveau1data
	{
		static private var _instance:Niveau1data;
		private var _datas:XML;
		private var _arr:Array;
		
		public function Niveau1data(lock:SingletonLock)
		{
			_datas =  <niveau niveau="1" blocsize="32" width="640" height="640">
					<bloc x="96" y="448" type="blocBordGauche" name="instance2">1</bloc>
					<bloc x="128" y="448" type="bloc" name="instance4">1</bloc>
					<bloc x="160" y="448" type="blocBordDroite" name="instance6">1</bloc>
					<bloc x="416" y="512" type="bloc" name="instance8">1</bloc>
					<bloc x="384" y="512" type="blocBordGauche" name="instance10">1</bloc>
					<bloc x="448" y="512" type="bloc" name="instance12">1</bloc>
					<bloc x="480" y="512" type="bloc" name="instance14">1</bloc>
					<bloc x="384" y="352" type="blocBordDroite" name="instance16">1</bloc>
					<bloc x="352" y="352" type="bloc" name="instance18">1</bloc>
					<bloc x="512" y="512" type="blocBordDroite" name="instance20">1</bloc>
					<bloc x="416" y="128" type="bloc" name="instance22">1</bloc>
					<bloc x="448" y="128" type="bloc" name="instance24">1</bloc>
					<bloc x="480" y="128" type="blocBordDroite" name="instance26">1</bloc>
					<bloc x="320" y="352" type="bloc" name="instance28">1</bloc>
					<bloc x="288" y="352" type="blocBordGauche" name="instance30">1</bloc>
					<bloc x="384" y="128" type="bloc" name="instance32">1</bloc>
					<bloc x="224" y="192" type="blocBordDroite" name="instance34">1</bloc>
					<bloc x="192" y="192" type="bloc" name="instance36">1</bloc>
					<bloc x="160" y="192" type="bloc" name="instance38">1</bloc>
					<bloc x="128" y="192" type="blocBordGauche" name="instance40">1</bloc>
					<bloc x="352" y="128" type="blocBordGauche" name="instance42">1</bloc>
					<bloc x="416" y="576" type="bloc" name="instance44">1</bloc>
					<bloc x="384" y="576" type="blocBordGauche" name="instance46">1</bloc>
					<bloc x="448" y="576" type="bloc" name="instance48">1</bloc>
					<bloc x="480" y="576" type="bloc" name="instance50">1</bloc>
					<bloc x="512" y="576" type="blocBordDroite" name="instance52">1</bloc>
					<bloc x="416" y="608" type="bloc" name="instance54">1</bloc>
					<bloc x="384" y="608" type="blocBordGauche" name="instance56">1</bloc>
					<bloc x="448" y="608" type="bloc" name="instance58">1</bloc>
					<bloc x="480" y="608" type="bloc" name="instance60">1</bloc>
					<bloc x="512" y="608" type="blocBordDroite" name="instance62">1</bloc>
					<bloc x="32" y="32" type="bonus" name="bonus_1">1</bloc>
					<bloc x="64" y="32" type="bonus" name="bonus_2">1</bloc>
					<bloc x="96" y="32" type="bonus" name="bonus_3">1</bloc>
					<bloc x="480" y="480" type="bonus" name="bonus_14">1</bloc>
					<bloc x="448" y="480" type="bonus" name="bonus_13">1</bloc>
					<bloc x="416" y="480" type="bonus" name="bonus_12">1</bloc>
					<bloc x="384" y="480" type="bonus" name="bonus_11">1</bloc>
					<bloc x="512" y="480" type="bonus" name="bonus_15">1</bloc>
					<bloc x="352" y="160" type="bonus" name="bonus_26">1</bloc>
					<bloc x="384" y="160" type="bonus" name="bonus_27">1</bloc>
					<bloc x="416" y="160" type="bonus" name="bonus_28">1</bloc>
					<bloc x="448" y="160" type="bonus" name="bonus_29">1</bloc>
					<bloc x="480" y="160" type="bonus" name="bonus_30">1</bloc>
					<bloc x="128" y="32" type="bonus" name="bonus_4">1</bloc>
					<bloc x="160" y="32" type="bonus" name="bonus_5">1</bloc>
					<bloc x="448" y="32" type="bonus" name="bonus_35">1</bloc>
					<bloc x="480" y="32" type="bonus" name="bonus_34">1</bloc>
					<bloc x="512" y="32" type="bonus" name="bonus_33">1</bloc>
					<bloc x="544" y="32" type="bonus" name="bonus_32">1</bloc>
					<bloc x="576" y="32" type="bonus" name="bonus_31">1</bloc>
					<bloc x="192" y="576" type="bonus" name="bonus_10">1</bloc>
					<bloc x="160" y="576" type="bonus" name="bonus_9">1</bloc>
					<bloc x="128" y="576" type="bonus" name="bonus_8">1</bloc>
					<bloc x="96" y="576" type="bonus" name="bonus_7">1</bloc>
					<bloc x="64" y="576" type="bonus" name="bonus_6">1</bloc>
					<bloc x="576" y="288" type="bonus" name="bonus_23">1</bloc>
					<bloc x="576" y="224" type="bonus" name="bonus_21">1</bloc>
					<bloc x="576" y="256" type="bonus" name="bonus_22">1</bloc>
					<bloc x="576" y="320" type="bonus" name="bonus_24">1</bloc>
					<bloc x="576" y="352" type="bonus" name="bonus_25">1</bloc>
					<bloc x="32" y="288" type="bonus" name="bonus_18">1</bloc>
					<bloc x="32" y="224" type="bonus" name="bonus_16">1</bloc>
					<bloc x="32" y="256" type="bonus" name="bonus_17">1</bloc>
					<bloc x="32" y="320" type="bonus" name="bonus_19">1</bloc>
					<bloc x="32" y="352" type="bonus" name="bonus_20">1</bloc>
				</niveau>
		}
		
		public static function get instance():Niveau1data
		{
			if (_instance == null)
				_instance = new Niveau1data(new SingletonLock());
			
			return (_instance);
		}
		
		public function get datas():XML
		{
			return _datas;
		}
	
	}

}

internal class SingletonLock
{
}