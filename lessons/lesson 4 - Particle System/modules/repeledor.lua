local Repeledor = {}
Repeledor.__index = Repeledor

function Repeledor:new(x, y, poder,min_distancia, max_distancia)
	local obj = {
		posicion = vmath.vector3(x,y,0),
		poder = poder or 150,
		min_distancia = min_distancia or 5,
		max_distancia = max_distancia or 150
	}
	setmetatable(obj, Repeledor)
	return obj
end

function Repeledor:repeler(pos_particula)
	local fuerza = self.posicion - pos_particula
	local distancia = vmath.length(fuerza)
	if distancia < self.min_distancia then
		distancia = self.min_distancia
	elseif distancia > self.max_distancia then
		distancia = self.max_distancia
	end
	local fuerza_escalar = -1 * (self.poder / (distancia * distancia))
	fuerza = vmath.normalize(fuerza) * fuerza_escalar
	return fuerza
end

return Repeledor