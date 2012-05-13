// ========================================================
// v 0.1, 10/02/08
// @auteur: YopSolo
// @mail: mail@yopsolo.fr
// @site: http://www.yopsolo.fr/wp
// ========================================================
// ========================================================
// Evolution de ma classe Array_ext (AS2) qui etait un extends de la classe array
// optim : ici GameMatrix compose avec Array plutot que de l'etendre ( est ce vraiment + performant ?)
// optim : utiliser un vector plutot qu'un tableau
// ========================================================
//
// -- methodes a ajouter ???
// indexOf(obj:*):Object, renvoi un 'vecteur position' du 1er objet trouve dans la GameMatrix ou null si il ne trouve rien
// lastIndexOf(obj:*):Object, renvoi un 'vecteur position' du dernier objet trouve dans la GameMatrix ou null si il ne trouve rien
// allIndexOf(obj:*):Array, renvoi un tableau de 'vecteur position' de tous les index trouves dans la GameMatrix et un tableau vide si il ne trouve rien
// insertColumnAt(), deleteColumnAt()
// compressUP(value)
// compressDW(value)
// compressLF(value)
// compressRG(value)
// getNeighbors(value)
// rotate(CLOCKWISE) 
// rotate(ANTI_CLOCKWISE)

package starlingBox.game.common
{
	public class GameMatrix
	{
		public static const CLOCKWISE:String 		= "clockwise";
		public static const ANTI_CLOCKWISE:String 	= "anti_clockwise";
		
		private var _m:Array;
		private var _c:uint;
		private var _l:uint;
		private var _t:uint;		
		
		public function GameMatrix( col:uint, lig:uint, val:*=null )
		{
			super();			
			_m	= new Array( (_c = col) * (_l = lig) );					
			_t = _l * _c;
			fill( val );			
		}
		
		// =====================================================================
		// == ACCESSEURS		
		
		// -- colonne, largeur de la matrice
		public function get c():uint { return _c; }
		public function set c( newC:uint ):void	{ resize( newC, _l ); }
		
		// -- ligne, hauteur de la matrice
		public function get l():uint { return _l; }
		public function set l( newL:uint ):void { resize(_c, newL ); }
		//-- recupere une valeur
		public function getValeur(colonne:uint, ligne:uint):* { return _m[int(ligne * _c + colonne)]; }
		public function getValeurByIdx(idx:uint):* { return _m[idx]; }
		//-- affecte une valeur						
		public function setValeur(colonne:uint, ligne:uint, valeur:*):void { _m[int(ligne * _c + colonne)] = valeur; }
		public function setValeurByIdx(idx:uint, valeur:*):void { _m[idx] = valeur; }
		
		// -- ecrase la matrice active, attention la taille de la matrice ne varie pas.
		// les valeurs manquantes seront des 'null' et les valeurs supplementaires seront perdues.
		public function set m( ar:Array ):void 
		{
			_m = ar;
		}
		// renvoi la ref vers la matrice
		public function get m():Array
		{ 
			return _m; 
		} 
		
		public function get t():uint { return _t; }
		public function get length():uint { return _t; }
		// renvoi un clone de la matrice
		public function clone():GameMatrix
		{
			var cl:GameMatrix = new GameMatrix( _c, _l); 
			cl._m = _m.concat();
			
			return cl;
		}		
		
		// =====================================================================
		// == MANIPULATION
		
		// echange les valeurs de 2 cases, une case est transmis
		// sous la forme d'un objet qui suit cette syntaxe : 
		// oCase{c:[laColonne],l:[laLigne],v:[laValeur] }		
		public function switchValue(a:Object,b:Object):void
		{
			trace("switch values");			
			var tmp:* = getValeur( a.c, a.l );
			setValeur( a.c, a.l, getValeur(b.c, b.l) );
			setValeur( b.c, b.l, tmp );
		}
		// == LIGNE/COLONNE
		// renvoi ligne a l'index specifie		
		public function getLigneAt(ligne:uint):Array
		{
			var offset:uint = ligne * _c;
			return _m.slice(offset, offset + _c);
		}
		// renvoi la colonne a l'index specifie
		public function getColonneAt( colonne:uint ):Array
		{
			var t:Array = new Array;			
			for (var i:uint = 0; i < _l; i++)
				t[i] = _m[int(i * _c + colonne)];
				
			return t;
		}
		public function setColonneAt(colonne:uint, arr:Array, default_value:uint = 0):void
		{
			if ( colonne < _c) {
				for (var y:int = 0; y < _l; y++)
				{
					if ( arr[y] != null  )
					{
						_m[int(y * _c + colonne)] = arr[y];					
					}else
					{
						_m[int(y * _c + colonne)] = default_value;
					}
				}
			}			
		}
		public function setLigneAt(ligne:uint, arr:Array, default_value:uint = 0):void
		{
			if ( ligne < _l )
			{
				var offset:int = ligne * _c;
				for (var x:int = 0; x < _c; x++)
				{
					if ( arr[x] != null  )
					{
						_m[int(offset + x)] = arr[x];
					}else
					{
						_m[int(offset + x)] = default_value;
					}
				}				
			}
		}		
		// decalle a gauche la matrice
		public function shiftLeft():void
		{
			if (_c == 1) return;
			
			var j:int = _c - 1, k:int;
			for (var i:int = 0; i < _l; i++)
			{
				k = i * _c + j;
				_m.splice(k, 0, _m.splice(k - j, 1));
			}
		}
		// decalle a droite la matrice
		public function shiftRight():void
		{
			if (_c == 1) return;
			
			var j:int = _c - 1, k:int;
			for (var i:int = 0; i < _l; i++)
			{
				k = i * _c + j;
				_m.splice(k - j, 0, _m.splice(k, 1));
			}
		}
		// decalle en haut
		public function shiftUp():void
		{
			if (_l == 1) return;
			
			_m = _m.concat(_m.slice(0, _c));
			_m.splice(0, _c);
		}
		// decalle en bas
		public function shiftDown():void
		{
			if (_l == 1) return;
			
			var offset:int = (_l - 1) * _c;
			_m = _m.slice(offset, offset + _c).concat(_m);
			_m.splice(_l * _c, _c);
		}		
		// ajoute une ligne a la fin
		public function addLigne(ar:Array):void
		{
			ar.length = _c;
			_m = _m.concat(ar);
			_l++;
		}
		// insere une ligne
		public function insertLigne(ar:Array):void
		{
			ar.length = _c;
			_m = ar.concat(_m);
			_l++;
		}
		// [TODO] insere une ligne a l'index choisi
		public function insertLigneAt(ar:Array):void
		{
			// --
		}
		// ajoute une colone a la fin
		public function addColonne(ar:Array):void
		{
			ar.length = _l;
			for (var y:int = 0; y < _l; y++)
				_m.splice(y * _c + _c + y, 0, ar[y]);
			_c++;
		}
		// [TODO] insere une colonne a l'index choisi
		public function insertColonneAt(ar:Array):void
		{	
			// --
		}		
		// insere une colonne au debut
		public function insertColonne(ar:Array):void
		{	
			ar.length = _l;
			for (var y:int = 0; y < _l; y++)
				_m.splice(y * _c + y, 0, ar[y]);
			_c++;
		}		
		// [TODO], resize
		public function resize(newC:uint, newL:uint):void
		{
			if (newC < 1) newC = 1;
			if (newL < 1) newL = 1;
			
			var tmp:Array = _m.concat();
			
			_m.length = 0;
			_m.length = newC * newL;
			
			var minc:int = newC < _c ? newC : _c;
			var minl:int = newL < _l ? newL : _l;
			
			var x:int, y:int, t1:int, t2:int;
			for (y = 0; y < minl; y++)
			{
				t1 = y *  newC;
				t2 = y * _c;
				
				for (x = 0; x < minc; x++)
					_m[int(t1 + x)] = tmp[int(t2 + x)];
			}
			
			_c = newC;
			_l = newL;
		}		
		// melange la matrice
		public function shuffle():void
		{
			if (_t > 0 )
			{
				var i:uint = _t;
				var j:int, tmp1:*, tmp2:*;
				
				while (--i) {
					j =int( Math.random()*(i+1) );
					tmp1 = _m[i];
					tmp2 = _m[j];
					_m[i] = tmp2;
					_m[j] = tmp1;
				}
			}
		}
		// renvoi le total des valeurs de la matrice
		public function checksum():Number
		{
			for (var i:uint = 0, check:Number =0 ; i < _t ; i++)
			{
				check += Number( _m[i] );
			}
			return check;
		}		
 		// (re)initialise la matrice avec une valeur passe en parametre
		public function fill( val:* ):void
		{
			//var _t:uint = _c * _l; 
			for (var i:uint = 0 ; i < _t ; i++)
				_m[i] = val;
		}
		// (re)initialise la matrice avec un seuil maximum passe en parametre 
		public function fillInt( max:int = 0, min:int = 0 ):void
		{
			if (min>max) {
				throw( new Error("#ERREUR POULET: Min > Max") );
			}
			var res:int = ((max+1) - min);
			for (var i:int = 0 ; i < _t ; i++)
				_m[i] = min + int ( Math.random() * res );
		}
		// transpose les lignes en colonnes
		public function transpose():void
		{
			var tmp:Array = _m.concat();
			
			for (var y:uint = 0; y < _l; y++)
			{
				for (var x:int = 0; x < _c; x++)
					_m[int(x * _c + y)] = tmp[int(y * _c + x)];
			}
		}
		
		// collapse la matrice sur une valeur
		public function compressDw(val:* = 0):GameMatrix
		{
			var result:GameMatrix = new GameMatrix(_c, _l, val);
			var v:int;
			for (var c:int = 0 ; c < _c; c++ )
			{
				for (var l:int = _l-1, nl:int =_l-1; l > -1 ; l--) 
				{
					v = getValeur(c, l);
					if (  v != val )
					{
						result.setValeur( c, nl, v);
						nl--;
					}
				}
				
			}
			return result;
			
		}		
		
		// OK
		public function compressUp(val:* = 0):GameMatrix
		{
			var result:GameMatrix = new GameMatrix(_c, _l, val);
			var v:int;
			for (var c:int = 0 ; c < _c; c++ )
			{
				for (var l:int = 0, nl:int =0; l < _l ; l++) 
				{
					v = getValeur(c, l);
					if (  v != val)
					{
						result.setValeur( c, nl, v);
						nl++;
					}
				}
				
			}
			return result;			
		}
		
		public function compressLf(val:* = 0):GameMatrix
		{
			trace("TODO");
			var result:GameMatrix = new GameMatrix(_c, _l, 0);
			var v:int;
			for (var c:int = 0 ; c < _c; c++ )
			{
				for (var l:int = 0, nl:int =0; l < _l ; l++) 
				{
					v = getValeur(c, l);
					if (  v != val)
					{
						result.setValeur( c, nl, v);
						nl++;
					}
				}
				
			}
			return result;			
		}					
		
		
		public function compressRg(val:* = 0):GameMatrix
		{
			trace("TODO");
			var result:GameMatrix = new GameMatrix(_c, _l, 0);
			var v:int;
			for (var c:int = 0 ; c < _c; c++ )
			{
				for (var l:int = 0, nl:int =0; l < _l ; l++) 
				{
					v = getValeur(c, l);
					if (  v != val)
					{
						result.setValeur( c, nl, v);
						nl++;
					}
				}
				
			}
			return result;			
		}
		
		// =====================================================================
		// == RECHERCHE
		public function inArray(obj:*):Boolean
		{
			for (var i:int = 0; i < _t; i++)
			{
				if (_m[i] === obj)
					return true;
			}
			return false;
		}
		// [TODO]
		public function indexOf(obj:*):Object
		{
			// [TODO]
			trace ("En cours...");
			var rs:Object;
			rs.l = null;
			rs.c = null;
			
			return rs;
		}
		// [TODO]		
		public function lastIndexOf(obj:*):Object
		{
			// [TODO]
			trace ("En cours...");
			var rs:Object;
			rs.l = null;
			rs.c = null;
			
			return rs;					
		}
		// [TODO]		
		public function allIndexOf(obj:*):Object
		{
			// [TODO]
			trace ("En cours...");
			var rs:Array = new Array;
			
			return rs;
		}
		// =====================================================================
		// == DEBUG
		// description de ma matrice
		public function toString():String
		{
			return "[GameMatrix, col = " + _c + ", lig = " + _l + "]";
		}
		// dump des valeurs de haut en bas
		public function dumpDw():String
		{
			var s:String = "GameMatrix\n{";
			var offset:int, value:*;
			for (var y:int = 0; y < _l; y++)
			{
				s += "\n" + "\t";
				offset = y * _c;
				for (var x:int = 0; x < _c; x++)
				{
					value = _m[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				}
			}
			
			s += "\n}";			
			
			return s;			
		}
		// dump des valeurs de bas en haut
		/*
		public function dumpUp():String
		{
			var s:String = "GameMatrix(sens du jeu)\n{";
			var offset:int, value:*;
			for (var y:int = _l-1; y > -1; y--)
			{
				s += "\n" + "\t";
				offset = y * _c;
				for (var x:int = 0; x < _c; x++)
				{
					value = _m[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				}
			}
			
			s += "\n}";			
			
			return s;			
		}
		*/
	}
}