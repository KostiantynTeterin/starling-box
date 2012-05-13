/*
exemple d'utilisation :


@expression:String,  l'expression a parser du type 3d6+2; 2d3; 2d4-2 etc...
@optimum:String, [AUCUN|MIN|MAX] selon votre choix, renvoi le score min/max possible, le param par defaut est no

import fr.yopsolo.game.De;
var jet_bouleDeFeu:Object = De.jet("20d6+10");
trace ( De.toString( jet_bouleDeFeu ) );

*/


package starlingBox.game.utils
{
	public class De 
	{
		public static const OPTIMAX:String 		= "max";
		public static const OPTIMIN:String 		= "min";
		
		public static function jet( expression:String, optimum:String = "AUCUN" ):Object 
		{
			// ====================================
			// gabarit de retour du resultat
			var rs:Object = new Object;
			rs.expression = expression;
			rs.detail = new Array();
			rs.modificateur = 0;
			rs.valeur = 0;
			// ====================================
			// Isole le nombre de des
			var sp:Array = new Array;
			
			if(expression.indexOf("d")>-1)
				sp = expression.split("d");
			else if (expression.indexOf("D")>-1)
				sp = expression.split("D");
			else
				return rs
			
			var nombre_de:Number = Number( sp[0] );
			// Isole le modificateur
			var modificateur_sp:Array = new Array();
			if ( sp[1].indexOf("+") > - 1) {
				modificateur_sp		= sp[1].split("+");
				rs.modificateur		= modificateur_sp[1];
			} else if ( sp[1].indexOf("-") > - 1 ) {
				modificateur_sp		= sp[1].split("-");
				rs.modificateur		= -modificateur_sp[1];
			} else {
				modificateur_sp[0]	= sp[1];
				rs.modificateur		= 0;
			}
			// Isole le type de Des
			var type:Number = modificateur_sp[0];
			// ====================================
			// les des sont jetes :)
			if (type>0) {
				// lance les des et additionne le resultats
				for (var i:int=0 ; i<nombre_de ; i++) 
				{
					var resultat:int;
					if(optimum == OPTIMAX)
					{// le seuil max
						resultat = type;
					}else if(optimum == OPTIMIN)
					{// le seuil minimum
						resultat = 1;									
					}else{
						// min <= un nombre aléatoire <= le max
						resultat = int( Math.random() * type) + 1;
					}
					rs.detail.push(resultat); 
					rs.valeur +=  resultat;
				}
				rs.valeur += Number( rs.modificateur );
			}			
			
			// ====================================
			// Debug
			/*
			trace ("Nombre de des : "+nombre_de);
			trace ("Type de des : "+type);
			trace ("Modificateur : "+modificateur);
			*/			
			
			return rs;
		}
		
		// renvoi une chaine de 4 ligne detaillant tout le contenu d'un jet de des : expression, chaque lancé, modificateur global, et bien sur le total
		public static function toString( jet:Object ):String
		{
			var str:String = "";
			str += "expression : "+jet.expression;
			str += "\ndetail : "+jet.detail;
			str += "\nmodificateur : "+jet.modificateur;
			str += "\ntotal : "+jet.valeur;
			
			return str;			
		}
		
		// TODO !
		public static function checkExpression( expression:String ):Boolean
		{
			return false;
		}		
	}
}