local Camino = {}
Camino.__index = Camino

function Camino:new(params)
	local obj = {
		inicio	= params.inicio or vmath.vector3(0,100,0),
		fin 	= params.fin or vmath.vector3(100,100,0),
		radio	= params.radio or 50
	}
	setmetatable(obj, Camino)
	return obj
end

function Camino:mostrar_puntos(id_a, id_b)
	go.set_position(self.inicio, id_a)
	go.set_position(self.fin, id_b)
end

return Camino