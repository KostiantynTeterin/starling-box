package KeosTactics.ui 
{
	import KeosTactics.products.structures.Trou;
	import KeosTactics.players.Players;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class TrouDescBox extends AbstractDescBox
	{
		public function TrouDescBox() 
		{
			_GfxObj = new Trou( Players.instance.getMe() )
			_GfxObj.x = (200 - _GfxObj.pivotX) >> 1;
			addChild( _GfxObj );
			
			_desc.text = "Le trou est le piege qui a la plus grande priorité (il bat tous les autres pieges), il bloque le passage mais laisse passer les tirs.";
			addChild( _desc );
		}
		
	}

}