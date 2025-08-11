local Particula = {}
Particula.__index = Particula

function Particula:new(posicion, velocidad, aceleracion, emisor, tiempo_vida, velocidad_muerte)
	local obj = {
		posicion				= posicion or vmath.vector3(0),
		velocidad				= velocidad or vmath.vector3(0),
		aceleracion				= aceleracion or vmath.vector3(0),
		emisor					= emisor or "",
		tiempo_vida				= tiempo_vida or 100,
		tiempo_vida_original	= tiempo_vida,
		velocidad_muerte		= velocidad_muerte or 2
	}
	setmetatable(obj, Particula)
	return obj
end

function Particula:update()
	self.velocidad = self.velocidad + self.aceleracion
	self.posicion = self.posicion + self.velocidad
	self.tiempo_vida = self.tiempo_vida - self.velocidad_muerte
	self.aceleracion = self.aceleracion * 0
end

function Particula:aplicar_fuerza(fuerza)
	self.aceleracion = self.aceleracion + fuerza
end

function Particula:estoy_muerta()
	return self.tiempo_vida < 0 and self.emisor
end

return Particula
