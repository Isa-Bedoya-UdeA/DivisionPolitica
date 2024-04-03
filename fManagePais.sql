-- NOTA: Ejecutar primero este archivo (fManagePais.sql), claramente después de haber ejecutado el DDL y DML

DROP FUNCTION IF EXISTS fmanagepais();

CREATE OR REPLACE FUNCTION fManagePais()
RETURNS VOID AS $$
BEGIN
	-- Crear tabla Moneda
	CREATE TABLE IF NOT EXISTS Moneda(
        Id SERIAL PRIMARY KEY,
        Nombre VARCHAR(30) NOT NULL,
        Sigla VARCHAR(5) NOT NULL,
        Imagen BYTEA
    );
	
	-- Insertar datos en la tabla Moneda si no existen
	INSERT INTO Moneda (Id, Nombre, Sigla, Imagen)
	SELECT *
	FROM (VALUES
		(1, 'PESO COLOMBIANO', 'COP', NULL::BYTEA), -- ::BYTEA asegura que el dato NULL sea de tipo BYTEA
		(2, 'PESO ARGENTINO', 'ARS', NULL::BYTEA),
		(3, 'PESO BOLIVIANO', 'BOB', NULL::BYTEA),
		(4, 'REAL', 'BRL', NULL::BYTEA),
		(5, 'DOLAR CANADIENSE', 'CAD', NULL::BYTEA),
		(6, 'COLON', 'CRC', NULL::BYTEA),
		(7, 'PESO DOMINICANO', 'DOP', NULL::BYTEA),
		(8, 'DOLAR', 'USD', NULL::BYTEA),
		(9, 'PESO CHILENO', 'CLP', NULL::BYTEA),
		(10, 'QUETZAL', 'GTQ', NULL::BYTEA),
		(11, 'PESO', 'HNL', NULL::BYTEA),
		(12, 'PESO MEXICANO', 'MXN', NULL::BYTEA),
		(13, 'BALBOA', 'PAB', NULL::BYTEA),
		(14, 'GUARANI', 'PYG', NULL::BYTEA),
		(15, 'NUEVO SOL', 'PEN', NULL::BYTEA),
		(16, 'PESO URUGUAYO', 'UYU', NULL::BYTEA),
		(17, 'NUEVO BOLIVAR', 'VEB', NULL::BYTEA),
		(18, 'LIBRA', 'GBP', NULL::BYTEA),
		(19, 'EURO', 'EUR', NULL::BYTEA),
		(20, 'DOLAR AUSTRALIANO', 'AUD', NULL::BYTEA)
	) AS data (Id, Nombre, Sigla, Imagen)
	ON CONFLICT DO NOTHING;
	
	-- Agregar columna IdMoneda si no existe
	ALTER TABLE Pais ADD COLUMN IF NOT EXISTS IdMoneda INTEGER;
	
	-- Actualizar IdMoneda con valores de Moneda si existe la columna Moneda en Pais
	IF EXISTS (
		SELECT 1
        	FROM information_schema.columns 
			WHERE table_name = 'pais' AND column_name = 'moneda'
	) THEN
		UPDATE Pais SET IdMoneda = M.Id
		FROM Moneda M
		WHERE Pais.Moneda = M.Nombre;
  	END IF;
	
	-- Eliminar la columna Moneda en Pais
	ALTER TABLE Pais DROP COLUMN IF EXISTS Moneda;
  
	-- Agregar columna Mapa si no existe
	ALTER TABLE Pais ADD COLUMN IF NOT EXISTS Mapa BYTEA;
	
	-- Agregar columna Bandera si no existe
	ALTER TABLE Pais ADD COLUMN IF NOT EXISTS Bandera BYTEA;
	
	RAISE NOTICE 'Tabla Pais modificada con éxito.';
END;
$$ LANGUAGE plpgsql;