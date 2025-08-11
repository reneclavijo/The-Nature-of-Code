local v_util = require("modules.utilidades_vectores")

local Vehiculo = {}
Vehiculo.__index = Vehiculo

local ancho, alto = window.get_size()

local function revisar_limites(self)
	
	if (self.posicion.x > ancho) then
		self.posicion.x = 0;
	elseif (self.posicion.x < 0) then
		self.posicion.x = ancho;
	end

	if (self.posicion.y > alto) then
		self.posicion.y = 0;
	elseif (self.posicion.y < 0) then
		self.posicion.y = alto;
	end

	go.set_position(self.posicion);
end

local function no_salir_de_la_pantalla(self)
	if (self.posicion.x > ancho or self.posicion.x < 0) then
		self.velocidad.x = self.velocidad.x * -1
	end

	if (self.posicion.y > alto or self.posicion.y < 0) then
		self.posicion.y = self.posicion.y * -1
	end
end

function Vehiculo:new(params)
	local obj = {
		id = params.id or nil,
		posicion = params.posicion,
		velocidad = params.velocidad,
		aceleracion = params.aceleracion,
		velocidad_max = params.velocidad_max,
		fuerza_max = params.fuerza_max
	}
	setmetatable(obj, Vehiculo)
	return obj
end

function Vehiculo:mover(params)
	self.velocidad = self.velocidad + self.aceleracion
	self.velocidad = v_util.limitar(self.velocidad, self.velocidad_max)
	self.posicion = self.posicion + self.velocidad
	self.aceleracion = self.aceleracion * 0
	go.set_position(self.posicion)

	if params and params.no_salir_pantalla then
		no_salir_de_la_pantalla(self)
	else
		revisar_limites(self)
	end
end

function Vehiculo:girar()
	local angulo_velocidad = math.atan2(self.velocidad.y, self.velocidad.x) - (math.pi / 2)
	go.set_rotation(vmath.quat_rotation_z(angulo_velocidad))
end

function Vehiculo:aplicar_fuerza(fuerza)
	self.aceleracion = self.aceleracion + fuerza
end

return Vehiculo