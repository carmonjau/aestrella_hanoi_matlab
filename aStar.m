% Realizado por: Carlos Montoto Jáuregui

classdef aStar
	methods (Static)
		function r = ejercicio1()
            %Realiza el problema de la Torre de Hanoi
			r = aStar.aStarr(Juegos.Hanoi);
		end
	
		function r = ejercicio3(ciudad, DoA)
            %Realiza el problema de la busqueda de Mapa
			r = aStar.aStarr(Juegos.Mapa, ciudad, DoA);
		end
		
		function r = aStarr(exercise, ciudad, DoA)
            %Creamos el nodo inicial.
			nodoini = Nodo(exercise);
			if (exercise == Juegos.Mapa)
				nodoini.CiudadObj = ciudad;
			else
				DoA = false;
            end
            %Iniciamos la frontera y la lista de explorados añadiendo el nodoinicial
			frontier = [];
			explored = [];
			frontier = [frontier, nodoini];
			explored = [explored, nodoini.Estado];
			%Llamamos a la ejecución del programa.
			r = aStar.ejecucion(frontier, explored, DoA);
        end
		
		function r = ejecucion(frontier, explored, DoA)
			%Mientras que no esté vacía la frontera sigue buscando el objetivo.
            while ~isempty(frontier)
				%Cogemos el primer elemento de la frontera y lo eliminamos de ella.
                actual = frontier(1);
                frontier(1) = [];
				%Comprobamos que el nodo actual sea el objetivo.
				%Si no lo es expandimos el nodo.
				%Si es el objetivo lo devolvemos.
                fin = aStar.objetivo (actual);
				if (fin == false)
					[frontier, explored] = aStar.expandir(actual, frontier, explored, DoA);
				else
					r = actual;
					return
				end
            end
			%En caso de que se haya vaciado la frontera y no se haya encontrado el objetivo devolvemos fallo.
			r = null(0);
        end
			
		function r = objetivo(nodo)
			%Comprueba si el nodo es el objetivo.
			%Devuelve true en caso de serlo, false de lo contrario.
			r = false;
            FinalHanoi = [[0,0,1];[0,0,2];[0,0,3]];
			if (nodo.Juego == Juegos.Hanoi)
				if (aStar.equalHanoi(nodo.Estado, FinalHanoi))
					r = true;
				end
			elseif (nodo.Juego == Juegos.Mapa)
				if (aStar.equalMapa(nodo.Estado, nodo.CiudadObj))
					r = true;
				end
			end
		end

		function si = equalHanoi(estado1, estado2)
		%Compara dos estados del problema de Hanoi.
		%Devuelve true si son iguales, false de lo contrario.
            si = true;
            for i=1:3
                for j=1:3
                    if(estado1(i,j)~=estado2(i,j))
                        si=false;
                    end
                end
            end
		end
		
		function si = equalMapa(estado1, estado2)
        %Compara dos estados del problema del Mapa.
		%Devuelve true si son iguales, false de lo contrario.
			si = true;
            if (estado1 ~= estado2)
				si = false;
			end
		end
			
		function [r, s] = expandir(nodo, frontier, explored, DoA)
			%Comprueba los posibles operadores aplicables del nodo y, en caso de ser posibles, crea el hijo resultante.
			if (nodo.Juego == Juegos.Hanoi)
				[si, hijo] = aStar.moveAB(nodo); 
				if (si)
					%Comprobamos que el estado del hijo este en explored.
					esta = aStar.explorado(hijo.Estado, explored);
					%Si no lo está lo añadimos a frontera y a explored.
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
				
				[si, hijo] = aStar.moveAC(nodo); 
				if (si)
					esta = aStar.explorado(hijo.Estado, explored);
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
				
				[si, hijo] = aStar.moveBA(nodo); 
				if (si)
					esta = aStar.explorado(hijo.Estado, explored);
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
				
				[si, hijo] = aStar.moveBC(nodo); 
				if (si)
					esta = aStar.explorado(hijo.Estado, explored);
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
				
				[si, hijo] = aStar.moveCA(nodo); 
				if (si)
					esta = aStar.explorado(hijo.Estado, explored);
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
				
				[si, hijo] = aStar.moveCB(nodo); 
				if (si)
					esta = aStar.explorado(hijo.Estado, explored);
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end

			elseif (nodo.Juego == Juegos.Mapa)
				%Buscamos la posición en el mapa de la ciudad.
				indice = aStar.buscar(nodo, nodo.Estado);
				%Creamos sus hijos
				[m, n] = size(nodo.Mapa(indice).Hijos);
				for i=1 : n
					%Si se ha decidido usar A* utilizamos heurística.
					if (DoA == true)
						h = aStar.heuristicaMapa(nodo, indice);
					else
						h = 0;
                    end
					hijo = Nodo(1, nodo, nodo.Mapa(indice).Hijos(i), h, nodo.Mapa(indice).DistanciaHijos(i));
					esta = aStar.explorado(hijo.Estado, explored);
					%Si el hijo no está en explored se le añade a la frontera y a explored.
					if ~esta
						explored = [explored, hijo.Estado];
						frontier = [frontier, hijo];
					end
				end
			end

			%Ordenamos la frontera de menos a mayor según el coste.
			[~, ind] = sort([frontier.F]);
			frontier = frontier(ind);
			r = frontier;
			s = explored;
		end
		
		function esta = explorado(estado, explored)
		%Comprueba si el estado está en la lista de explorados.
		%Devuelve true si está, false si no.
			[n, m] = size(explored);
			esta = false;
			i = 1;
			while i < m && ~esta
				if (explored(i) == estado)
					esta = true;
				else
					i = i+1;
				end
			end
		end
		
		function ind = buscar(nodo, nombre)
		%Busca la ciudad en el Mapa.
		%Devuelve la posición.
			aqui = false;
			i = 1;
			[m, n] = size(nodo.Mapa);
			while i <= n && ~aqui
				if (nodo.Mapa(i).Nombre == nombre)
					aqui = true;
				else
					i = i+1;
				end
			end
			ind = i;
		end

		function [si, hijo] = moveAB(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,1) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,2) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,1) < nodo.Estado(j,2))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,2) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 2) = copia(i, 1);
				copia(i, 1) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
            else
                hijo = [];
            end
		end

		function [si, hijo] = moveAC(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,1) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,3) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,1) < nodo.Estado(j,3))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,3) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 3) = copia(i, 1);
				copia(i, 1) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
			else
                hijo = [];
            end
		end

		function [si, hijo] = moveBA(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,2) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,1) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,2) < nodo.Estado(j,1))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,1) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 1) = copia(i, 2);
				copia(i, 2) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
			else
                hijo = [];
            end
		end

		function [si, hijo] = moveBC(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,2) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,3) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,2) < nodo.Estado(j,3))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,3) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 3) = copia(i, 2);
				copia(i, 2) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
			else
                hijo = [];
            end
		end
		
		function [si, hijo] = moveCA(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,3) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,1) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,3) < nodo.Estado(j,1))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,1) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 1) = copia(i, 3);
				copia(i, 3) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
			else
                hijo = [];
            end
		end

		function [si, hijo] = moveCB(nodo)
			%Comprobar que pueda usarse el operador, si se puede crea el hijo.
			%Devuelve si se puede realizar y el hijo.
			i = 1;
			si = false;
			salir = false;
			sigue = true;
            while i <= 3 && ~salir
				if (nodo.Estado(i,3) ~= 0)
					j = 1;
					while j <= 3 && sigue
						if (nodo.Estado(j,2) ~= 0)
							sigue = false;
							pos = j -1;
							if (pos >= 1 && nodo.Estado(i,3) < nodo.Estado(j,2))
								si = true;
							end
							salir = true;
						else
							j = j+1;
						end
					end
					if j>3 && nodo.Estado(3,2) == 0
						si = true;
						pos = j-1;
						salir = true;
					end
				else
					i = i+1;
				end
            end

            if (si)
				%Copiamos el estado del padre
				copia = nodo.Estado;
				%Generamos el estado del hijo
				copia(pos, 2) = copia(i, 3);
				copia(i, 3) = 0;
				%Calculamos la heuristica
				h = aStar.heuristica(copia);
				%Creamos el nodo hijo
				hijo = Nodo(1, nodo, copia, h);
			else
                hijo = [];
            end
		end

		function h = heuristica(estado)
		%Calcula la heuristica del problema de Hanoi.
			h = 0;
			if (estado(1,3) ~= 1)
				h = h+1;
			end
			if (estado(2,3) ~= 2)
				h = h+1;
			end
			if (estado(3,3) ~= 3)
				h = h+1;
			end
        end
		
		function h = heuristicaMapa(nodo, indice)
		%Calcula la heuristica del problema del Mapa.
			hijos = nodo.Mapa(indice).Hijos;
			[m, n] = size(hijos);
			h = 0;
			si = false;
			for i=1:n
				if (hijos(i) == "Arad")
					si = true;
				end
			end
			if (~si)
				%h = aStar.comprobarNietos(nodo, hijos, n);
				h = h+1;
			end
			
		end
		
		function h = comprobarNietos(nodo, hijos, n)
		%Función auxiliar de heuristicaMapa(nodo, indice).
			si = false;
			h = 0;
			for i = 1: n
				indice = buscar(nodo, hijos(i));
				nietos = nodo.Mapa(indice).Hijos;
				[l,k] = size(nietos);
				for j=1:k
					if (nietos(i) == "Arad")
						si = true;
					end
				end
				if (~si)
					h = h+1;
				end
			end
		end
		
		function m = generarMapa()
		%Genera el Mapa con las ciudades.
			m = Ciudad("Bucharest", ["Giurgiu", "Urziceni", "Pitesti", "Fagaras"], [90, 85, 101, 211]);
			m = [m , Ciudad("Giurgiu", ["Bucharest"], [90])];
			m = [m , Ciudad("Urziceni", ["Bucharest", "Vaslui", "Hirsova"], [85, 142, 98])];
			m = [m , Ciudad("Hirsova", ["Urziceni", "Eforie"], [98, 86])];
			m = [m , Ciudad("Eforie", ["Hirsova"], [86])];
			m = [m , Ciudad("Vaslui", ["Urziceni", "Iasi"], [142, 92])];
			m = [m , Ciudad("Iasi", ["Vaslui", "Neamt"], [92, 87])];
			m = [m , Ciudad("Neamt", ["Iasi"], [87])];
			m = [m , Ciudad("Pitesti", ["Bucharest", "Craiova", "Rimnicu Viicea"], [101, 138, 97])];
			m = [m , Ciudad("Craiova", ["Pitesti", "Rimnicu Viicea", "Dobreta"], [138, 146, 120])];
			m = [m , Ciudad("Fagaras", ["Bucharest", "Sibiu"], [211, 99])];
			m = [m , Ciudad("Rimnicu Viicea", ["Sibiu", "Pitesti", "Craiova"], [80, 97, 146])];
			m = [m , Ciudad("Sibiu", ["Fagaras", "Rimnicu Viicea", "Oradea", "Arad"], [99, 80, 151, 140])];
			m = [m , Ciudad("Oradea", ["Sibiu", "Zerind"], [151, 71])];
			m = [m , Ciudad("Zerind", ["Oradea", "Arad"], [71, 75])];
			m = [m , Ciudad("Arad", ["Zerind", "Sibiu", "Timisoara"], [75, 140, 118])];
			m = [m , Ciudad("Timisoara", ["Arad", "Lugoj"], [118, 111])];
			m = [m , Ciudad("Lugoj", ["Timisoara", "Mehadia"], [111, 70])];
			m = [m , Ciudad("Mehadia", ["Lugoj", "Dobreta"], [70, 75])];
			m = [m , Ciudad("Dobreta", ["Mehadia", "Craiova"], [75, 120])];
		end
    end
end