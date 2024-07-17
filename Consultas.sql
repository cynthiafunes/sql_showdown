-- Consulta 1: Seleccionar usuarios con mayor reputación
SELECT TOP 200 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;


-- Consulta 2: Seleccionar títulos de posts con sus autores
SELECT TOP 200 Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id


-- Consulta 3: Calcular el promedio de Score de los Posts por usuario
SELECT TOP 200 Users.DisplayName, AVG(Posts.Score) AS Promedio
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;


-- Consulta 4: Encontrar usuarios con más de 100 comentarios
SELECT TOP 200 DisplayName 
FROM Users
WHERE id IN (
	SELECT UserId 
	FROM Comments 
	GROUP BY UserId HAVING COUNT(*) > 100
)
ORDER BY Users.DisplayName;


-- Consulta 5: Actualizar ubicaciones vacías
-- Paso 1: Revisar antes de la actualización
SELECT TOP 200 ID, Location
FROM Users
WHERE Location IS NULL OR Location = '';
-- Paso 2: Ejecutar la actualización
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';
SELECT 'Actualización realizada correctamente' AS Mensaje;
-- Paso 3: Revisar después de la actualización
SELECT TOP 200 ID, Location
FROM Users
WHERE Location = 'Desconocido';



-- Consulta 6: Eliminar comentarios de usuarios con menos de 100 de reputación
-- Paso 1: Revisar antes de la eliminación
SELECT TOP 200 Id, UserId, Text
FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);
-- Paso 2: Ejecutar la eliminación
DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);
SELECT @@ROWCOUNT AS ComentariosEliminados;
-- Paso 3: Revisar después de la eliminación
SELECT TOP 200 Id, UserId, Text
FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);


-- Consulta 7: Mostrar el número total de publicaciones, comentarios y badges por usuario
WITH 
TotalPublicacionesPorUsuario AS (
    SELECT OwnerUserId, COUNT(*) AS TotalPosts
    FROM Posts
    GROUP BY OwnerUserId),
TotalComentariosPorUsuario AS (
    SELECT UserId, COUNT(*) AS TotalComments
    FROM Comments
    GROUP BY UserId),
TotalMedallasPorUsuario AS (
    SELECT UserId, COUNT(*) AS TotalBadges
    FROM Badges
    GROUP BY UserId)

SELECT TOP 200 
    Users.DisplayName,
    ISNULL(TotalPublicacionesPorUsuario.TotalPosts, 0) AS TotalPublicaciones,
    ISNULL(TotalComentariosPorUsuario.TotalComments, 0) AS TotalComentarios,
    ISNULL(TotalMedallasPorUsuario.TotalBadges, 0) AS TotalMedallas
FROM Users
LEFT JOIN TotalPublicacionesPorUsuario ON Users.Id = TotalPublicacionesPorUsuario.OwnerUserId
LEFT JOIN TotalComentariosPorUsuario ON Users.Id = TotalComentariosPorUsuario.UserId
LEFT JOIN TotalMedallasPorUsuario ON Users.Id = TotalMedallasPorUsuario.UserId
ORDER BY Users.DisplayName;



-- Consulta 8: Mostrar las 10 publicaciones más populares
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;


-- Consulta 9: Mostrar los 5 comentarios más recientes
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;


