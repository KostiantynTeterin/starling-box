package KeosTactics.ui 
{
	import KeosTactics.players.Players;
	import KeosTactics.products.structures.Mur;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class MurDescBox extends AbstractDescBox
	{
		public function MurDescBox() 
		{
			_GfxObj = new Mur( Players.instance.getMe() );
			_GfxObj.x = (200 - _GfxObj.pivotX) >> 1;
			addChild( _GfxObj );
			
			_desc.text = "Le mur bloque le passage et le champ de vision des snipers";
			addChild( _desc );
		}
		
	}

}