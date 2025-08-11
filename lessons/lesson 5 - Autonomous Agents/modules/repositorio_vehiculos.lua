local repositorio_vehiculos = {}

repositorio_vehiculos.cantidad = 0
repositorio_vehiculos.cantidad_maxima = 0
repositorio_vehiculos.esta_lleno = false

function repositorio_vehiculos.agregar(vehiculo)
	repositorio_vehiculos.cantidad = repositorio_vehiculos.cantidad + 1
	repositorio_vehiculos[repositorio_vehiculos.cantidad] = vehiculo
	repositorio_vehiculos.esta_lleno = repositorio_vehiculos.cantidad >= repositorio_vehiculos.cantidad_maxima
end

return repositorio_vehiculos