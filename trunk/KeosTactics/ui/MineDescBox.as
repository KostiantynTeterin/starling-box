package KeosTactics.ui 
{
	import KeosTactics.players.Players;
	import KeosTactics.products.structures.Mine;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class MineDescBox extends AbstractDescBox
	{
		public function MineDescBox() 
		{
			_GfxObj = new Mine( Players.instance.getMe() )
			_GfxObj.x = (200 - _GfxObj.pivotX) >> 1;
			addChild( _GfxObj );
			
			_desc.text = "La mine est invisible aux yeux de votre adversaire.";
			addChild( _desc );
		}
		
	}

}