local v_util = require("modules.utilidades_vectores")

local steering = {}
local ancho, alto = window.get_size()

-- 1| seek -> buscar a un objetivo
function steering.seek(vehiculo_cazador, pos_objetivo)
	local velocidad_deseada = pos_objetivo - vehiculo_cazador.posicion
	velocidad_deseada = v_util.limitar(velocidad_deseada, vehiculo_cazador.velocidad_max)
	local steer = velocidad_deseada - vehiculo_cazador.velocidad
	steer = v_util.limitar(steer, vehiculo_cazador.fuerza_max)
	return steer
end

-- 2| flee -> escapar de un objetivo
function steering.flee(vehiculo_cazador, pos_objetivo)
	return -1 * steering.seek(vehiculo_cazador, pos_objetivo)
end

-- 3| Pursue -> perseguir a un objetivo prediciendo a dónde irá según su velocidad
function steering.pursue(vehiculo_cazador, params_obj)
	local prediccion_pos_objetivo = params_obj.pos + params_obj.vel
	local steer = steering.seek(vehiculo_cazador, prediccion_pos_objetivo)
	return steer
end

-- 4| Evade -> evadir a un objetivo prediciendo a dónde irá según su velocidad
function steering.evade(vehiculo_cazador, params_obj)
	return -1 * steering.pursue(vehiculo_cazador, params_obj)
end

-- 5| Arrive -> Ir parando mientras más me acerco al objetivo
function steering.arrive(vehiculo_cazador, pos_objetivo, distancia_llegada)
	local velocidad_deseada = pos_objetivo - vehiculo_cazador.posicion
	local distancia = vmath.length(velocidad_deseada)
	if (distancia < distancia_llegada) then
		local mag_velocidad_mapeada = vmath.lerp(distancia / distancia_llegada, 0, vehiculo_cazador.velocidad_max)
		velocidad_deseada = v_util.limitar(velocidad_deseada, mag_velocidad_mapeada)
	else
		velocidad_deseada = v_util.limitar(velocidad_deseada, vehiculo_cazador.velocidad_max)
	end
	local fuerza_steer = velocidad_deseada - vehiculo_cazador.velocidad
	fuerza_steer = v_util.limitar(fuerza_steer, vehiculo_cazador.fuerza_max)
	return fuerza_steer
end

-- 6| Wander -> Ir avanzando con un objetivo que cambia de posición al azar dentro de un radio
function steering.wander(vehiculo_cazador, distancia_punto, params)
	--if (vehiculo_cazador.velocidad == vmath.vector3(0)) then return vmath.vector3(0) end
	
	local wonder_radio = 100
	local wonder_distancia = distancia_punto
	local cantidad_random = 1
	local cambio_angulo = -cantidad_random * math.random() + (cantidad_random - (-cantidad_random))

	local pos_circulo = vmath.vector3(vehiculo_cazador.velocidad)
	if (vmath.length(pos_circulo) > 0) then 
		pos_circulo = vmath.normalize(pos_circulo) 
	else 
		pos_circulo = vmath.vector3(0) 
	end
	pos_circulo = pos_circulo * wonder_distancia
	pos_circulo = pos_circulo + vehiculo_cazador.posicion
	
	local angulo_velocidad = math.atan2(pos_circulo.y, pos_circulo.x)
	local punto_dentro_de_circulo = vmath.vector3(
		wonder_radio * math.cos(cambio_angulo + angulo_velocidad),
		wonder_radio * math.sin(cambio_angulo + angulo_velocidad),
		0
	)
	
	local objetivo = pos_circulo + punto_dentro_de_circulo
	if(params and params.wander_point) then
		go.set_position(objetivo, params.wander_point)
	end
	return steering.seek(vehiculo_cazador, objetivo)
end

-- 7| Containment -> Evitar que el vehículo se salga de las paredes (de los límites de la pantalla)
function steering.stay_within_walls(vehiculo_cazador, distancia_pared)
	local velocidad_deseada = nil
	
	if (vehiculo_cazador.posicion.x < distancia_pared) then
		velocidad_deseada = vmath.vector3(vehiculo_cazador.velocidad_max, vehiculo_cazador.velocidad.y, 0)
	elseif (vehiculo_cazador.posicion.x > ancho - distancia_pared) then
		velocidad_deseada = vmath.vector3(-vehiculo_cazador.velocidad_max, vehiculo_cazador.velocidad.y, 0)
	end
	
	if(vehiculo_cazador.posicion.y < distancia_pared) then
		velocidad_deseada = vmath.vector3(vehiculo_cazador.velocidad.x, vehiculo_cazador.velocidad_max, 0)
	elseif(vehiculo_cazador.posicion.y > alto - distancia_pared) then
		velocidad_deseada = vmath.vector3(vehiculo_cazador.velocidad.x, -vehiculo_cazador.velocidad_max, 0)
	end

	local steer = nil
	if velocidad_deseada then
		velocidad_deseada = v_util.limitar(velocidad_deseada, vehiculo_cazador.velocidad_max)
		steer = velocidad_deseada - vehiculo_cazador.velocidad
	else
		steer = vmath.vector3(vehiculo_cazador.velocidad)
	end
	steer = v_util.limitar(steer, vehiculo_cazador.fuerza_max)
	return steer
	
end

-- 8| Flow Field -> Seguir un "campo" de vectores con las direcciones que debe seguir el vehículo
function steering.follow_flow_field(vehiculo_cazador, direccion)
	local velocidad_deseada = vmath.normalize(direccion) * vehiculo_cazador.velocidad_max
	local steer = velocidad_deseada - vehiculo_cazador.velocidad
	steer = v_util.limitar(steer, vehiculo_cazador.fuerza_max)
	return steer
end

local function encontrarPuntoProyectado(camino, pos_futura)
	local vector_a = pos_futura - camino.inicio
	local vector_b = camino.fin - camino.inicio
	local vector_proyectado = v_util.proyectar(vector_a, vector_b)
	return camino.inicio + vector_proyectado
end

-- 9| Path Following -> Seguir un camino definido, usando un radio para evitar que sea en línea recta
function steering.path_follow(vehiculo_cazador, camino, params)
	--{1} calcular la posición futura del vehículo
	local pos_futura = vmath.vector3(vehiculo_cazador.velocidad)
	pos_futura = pos_futura * 20
	pos_futura = pos_futura + vehiculo_cazador.posicion
	if (params and params.futuro) then
		go.set_position(pos_futura, params.futuro)
	end

	local objetivo = encontrarPuntoProyectado(camino, pos_futura)
	local diferencia_objetivo = camino.fin - camino.inicio
	diferencia_objetivo = vmath.normalize(diferencia_objetivo)
	diferencia_objetivo = diferencia_objetivo * 25
	objetivo = objetivo + diferencia_objetivo
	if(params and params.objetivo) then
		go.set_position(objetivo, params.objetivo)
	end
	local distancia_entre_objetivo_pos_futura = vmath.length(pos_futura - objetivo)

	if (distancia_entre_objetivo_pos_futura < camino.radio) then
		return vmath.vector3(0)
	else
		return steering.seek(vehiculo_cazador, objetivo)
	end
end

-- 10| Separation -> Calcular el promedio de los vehículos que se encuentren cerca a mi para obtener la velocidad deseada y alejarse del grupo
function steering.separate(vehiculo_cazador, vehiculos, params)
	local separacion_deseada = params and params.separacion or 25
	local suma_fuerza = vmath.vector3(0)
	local cantidad = 0
	for i, v in ipairs(vehiculos) do
		if(vehiculo_cazador.id ~= v.id) then
			
			local distancia = vmath.length(vehiculo_cazador.posicion - v.posicion)
			-- print("cazador: "..vehiculo_cazador.id.." otro: "..v.id.." distancia: "..distancia)
			-- print("id: "..vehiculo_cazador.id.." pos: "..vehiculo_cazador.posicion)
			
			
			if(distancia < separacion_deseada) then
				local diferencia = vehiculo_cazador.posicion - v.posicion
				diferencia = vmath.normalize(diferencia) * (1/distancia) -- Hacer que mientras más cerca esté, más me afecte
				suma_fuerza = suma_fuerza + diferencia
				cantidad = cantidad + 1
			end
		end
	end

	if(cantidad > 0) then
		suma_fuerza = vmath.normalize(suma_fuerza) * vehiculo_cazador.velocidad_max
		local steer = suma_fuerza - vehiculo_cazador.velocidad
		steer = v_util.limitar(steer, vehiculo_cazador.fuerza_max)
		return { steer = steer, en_accion = true }
	end
	
	local steer_recto = vmath.vector3(0)
	if vmath.length(vehiculo_cazador.velocidad) ~= 0 then
		steer_recto = vmath.normalize(vehiculo_cazador.velocidad) * vehiculo_cazador.velocidad_max
	end
	return { steer = steer_recto, en_accion = false }
end

-- 11| Cohere (Cohesion) -> Mantenerse cerca de un vehículo o grupo de vehículos dentro de un radio definido
function steering.cohere(vehiculo_cazador, vehiculos, params)
	local separacion_deseada_min = params and params.separacion_deseado_min or 20
	local separacion_deseada_max = params and params.separacion_deseado_min or 25
	local suma_posiciones = vmath.vector3(0)
	local cantidad = 0
	for i, v in ipairs(vehiculos) do
		if(vehiculo_cazador.id ~= v.id) then
			local distancia = vmath.length(vehiculo_cazador.posicion - v.posicion)
			-- print("cazador: "..vehiculo_cazador.id.." otro: "..v.id.." distancia: "..distancia)
			-- print("id: "..vehiculo_cazador.id.." pos: "..vehiculo_cazador.posicion)
			-- print("calculando")
			if(distancia > separacion_deseada_min and distancia < separacion_deseada_max) then
				suma_posiciones = suma_posiciones + v.posicion
				cantidad = cantidad + 1
			end
		end
	end

	if(cantidad > 0) then
		suma_posiciones = suma_posiciones / cantidad
		local steer = steering.seek(vehiculo_cazador, suma_posiciones)
		return { steer = steer, en_accion = true }
	end

	local steer_recto = vmath.vector3(0)
	if vmath.length(vehiculo_cazador.velocidad) ~= 0 then
		steer_recto = vmath.normalize(vehiculo_cazador.velocidad) * vehiculo_cazador.velocidad_max
	end
	return { steer = steer_recto, en_accion = false }
end

-- 12| Alignment -> Alinear la velocidad de mi vehículo con el del promedio de los vecinos
function steering.align(vehiculo_cazador, vehiculos, params)
	local separacion_deseada_min = params and params.separacion_deseado_min or 20
	local separacion_deseada_max = params and params.separacion_deseado_max or 80
	local suma_velocidades = vmath.vector3(0)
	local cantidad = 0
	for i, v in ipairs(vehiculos) do
		if(vehiculo_cazador.id ~= v.id) then

			local distancia = vmath.length(vehiculo_cazador.posicion - v.posicion)
			-- print("cazador: "..vehiculo_cazador.id.." otro: "..v.id.." distancia: "..distancia)
			-- print("id: "..vehiculo_cazador.id.." pos: "..vehiculo_cazador.posicion)
			-- print("calculando")
			if(distancia > separacion_deseada_min and distancia < separacion_deseada_max) then
				suma_velocidades = suma_velocidades + v.velocidad
				cantidad = cantidad + 1
			end
		end
	end

	if(cantidad > 0) then
		suma_velocidades = vmath.normalize(suma_velocidades) * vehiculo_cazador.velocidad_max
		local steer = suma_velocidades - vehiculo_cazador.velocidad
		steer = v_util.limitar(steer, vehiculo_cazador.fuerza_max)
		return { steer = steer, en_accion = true }
	end

	-- return { steer = steering.wander(vehiculo_cazador, 200), esquivando = false }
	local steer_recto = vmath.vector3(0)
	if vmath.length(vehiculo_cazador.velocidad) ~= 0 then
		steer_recto = vmath.normalize(vehiculo_cazador.velocidad) * vehiculo_cazador.velocidad_max
	end
	return { steer = steer_recto, en_accion = false }
end

-- 13| Flocking (bandada de aves) -> Mezclar cohesión + alineación + separación para crear el efecto bandada
function steering.flocking(vehiculo_cazador, vehiculos, params)
	local separacion	= steering.separate(vehiculo_cazador, vehiculos, params)
	local cohesion		= steering.cohere(vehiculo_cazador, vehiculos, params)
	local alineacion	= steering.align(vehiculo_cazador, vehiculos, params)
	return { 
		steer = (separacion.steer * 1.5) + cohesion.steer + alineacion.steer,
		en_accion = separacion.en_accion or cohesion.en_accion or alineacion.en_accion
	}
end

return steering