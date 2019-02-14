classdef Nodo

	properties
		Estado
		Camino
		Coste
		F
		Juego
		Mapa
		CiudadObj
	end
	methods (Static)
		function obj = Nodo(exercise, nodo, estado, h, mapa)
			if nargin == 1
				if (exercise == Juegos.Hanoi)
					obj.Estado = [[1,0,0];[2,0,0];[3,0,0]];
					obj.Juego = Juegos.Hanoi;
				elseif (exercise == Juegos.Mapa)
					obj.Estado = "Bucharest";
					obj.Mapa = aStar.generarMapa();
					obj.Juego = Juegos.Mapa;
				end
				obj.Camino = [];
				obj.Coste = 0;
				obj.F = 0;
			elseif nargin == 2
				obj.Estado = nodo.Estado;
				obj.Camino = nodo.Camino;
				obj.Coste = nodo.Coste;
				obj.Juego = nodo.Juego;
				obj.F = nodo.F;
			elseif nargin == 4
				obj.Estado = estado;
                obj.Camino = [nodo.Camino, nodo];
				obj.Coste = nodo.Coste + 1;
				obj.F = obj.Coste + h;
				obj.Juego = nodo.Juego;
			elseif nargin == 5
				obj.Estado = estado;
				obj.Camino = [nodo.Camino, nodo];
				obj.Coste = nodo.Coste + mapa;
				obj.F = obj.Coste + h;
				obj.Juego = nodo.Juego;
				obj.Mapa = nodo.Mapa;
				obj.CiudadObj = nodo.CiudadObj;
			end
		end
	end
end	