classdef Ciudad
	properties
		Nombre
		Hijos
		DistanciaHijos
	end
	
	methods
		function obj = Ciudad(nombre, hijos, dist)
			obj.Nombre = nombre;
			obj.Hijos = hijos;
            obj.DistanciaHijos = dist;
		end
	end	
end