local utilidades_vectores = {}

function utilidades_vectores.limitar(v, max)
	if (vmath.length(v) > max) then
		return vmath.normalize(v) * max;
	end
	return v;
end

function utilidades_vectores.proyectar(a, b)
	local b_normalizado = vmath.normalize(b)
	local proyeccion_escalar = vmath.dot(a, b_normalizado)
	return (b_normalizado * proyeccion_escalar)
end

function utilidades_vectores.random_entre(a, b)
	return a + (math.random() * (b - a))
end

function utilidades_vectores.vector_random()
	return vmath.normalize(vmath.vector3(
		utilidades_vectores.random_entre(-1, 1),
		utilidades_vectores.random_entre(-1, 1),
		0
	))
end

return utilidades_vectores