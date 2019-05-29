USE GD1C2019;
GO

CREATE SCHEMA MLJ
GO

IF(OBJECT_ID('MLJ.crear_tablas') IS NOT NULL)
	DROP PROCEDURE MLJ.crear_tablas
GO

IF(OBJECT_ID('MLJ.crear_funciones') IS NOT NULL)
	DROP PROCEDURE MLJ.crear_funciones
GO

IF(OBJECT_ID('MLJ.crear_roles') IS NOT NULL)
	DROP PROCEDURE MLJ.crear_roles
GO

IF(OBJECT_ID('MLJ.crear_usuarios') IS NOT NULL)
	DROP PROCEDURE MLJ.crear_usuarios
GO

IF(OBJECT_ID('MLJ.verificar_viaje') IS NOT NULL)
	DROP PROCEDURE MLJ.verificar_viaje
GO

If (OBJECT_ID('MLJ.login') IS NOT NULL)
	DROP PROCEDURE MLJ.login
GO

CREATE PROCEDURE MLJ.crear_tablas 
AS
BEGIN
	IF OBJECT_ID('MLJ.RolesXFuncionalidades') IS NOT NULL
		DROP TABLE MLJ.RolesXFuncionalidades
	IF OBJECT_ID('MLJ.UsuariosXRoles') IS NOT NULL
		DROP TABLE MLJ.UsuariosXRoles
	IF OBJECT_ID('MLJ.Roles') IS NOT NULL
		DROP TABLE MLJ.Roles
	IF OBJECT_ID('MLJ.Usuarios') IS NOT NULL
		DROP TABLE MLJ.Usuarios
	IF OBJECT_ID('MLJ.Funcionalidades') IS NOT NULL
		DROP TABLE MLJ.Funcionalidades
	IF OBJECT_ID('MLJ.Tramos') IS NOT NULL
		DROP TABLE MLJ.Tramos
	IF OBJECT_ID('MLJ.Puertos') IS NOT NULL
		DROP TABLE MLJ.Puertos
	IF OBJECT_ID('MLJ.Reservas') IS NOT NULL
		DROP TABLE MLJ.Reservas 
	IF OBJECT_ID('MLJ.Cabinas_reservadas') IS NOT NULL
		DROP TABLE MLJ.Cabinas_reservadas 
	IF OBJECT_ID('MLJ.Pasajes') IS NOT NULL
		DROP TABLE MLJ.Pasajes 
	IF OBJECT_ID('MLJ.Viajes') IS NOT NULL
		DROP TABLE MLJ.Viajes
	IF OBJECT_ID('MLJ.Recorridos') IS NOT NULL
		DROP TABLE MLJ.Recorridos
	IF OBJECT_ID('MLJ.Cabinas') IS NOT NULL
		DROP TABLE MLJ.Cabinas
	IF OBJECT_ID('MLJ.Tipo_Cabinas') IS NOT NULL
		DROP TABLE MLJ.Tipo_Cabinas 
	IF OBJECT_ID('MLJ.Bajas_de_servicio') IS NOT NULL
		DROP TABLE MLJ.Bajas_de_servicio
	IF OBJECT_ID('MLJ.Cruceros') IS NOT NULL
		DROP TABLE MLJ.Cruceros
	IF OBJECT_ID('MLJ.Marcas') IS NOT NULL
		DROP TABLE MLJ.Marcas
	IF OBJECT_ID('MLJ.Servicios') IS NOT NULL
		DROP TABLE MLJ.Servicios
	IF OBJECT_ID('MLJ.Fabricantes') IS NOT NULL
		DROP TABLE MLJ.Fabricantes
	IF OBJECT_ID('MLJ.Modelos') IS NOT NULL
		DROP TABLE MLJ.Modelos
	IF OBJECT_ID('MLJ.Pagos') IS NOT NULL
		DROP TABLE MLJ.Pagos
	IF OBJECT_ID('MLJ.Medios_de_Pago') IS NOT NULL
		DROP TABLE MLJ.Medios_de_Pago
	IF OBJECT_ID('MLJ.Clientes') IS NOT NULL
		DROP TABLE MLJ.Clientes

	--Sentencia crea tabla Usuarios
	CREATE TABLE MLJ.Usuarios (
		cod_usuario INTEGER IDENTITY(1,1) PRIMARY KEY,
		usuario varchar(50) UNIQUE NOT NULL,
		hash_contrasenia char(256) NOT NULL,
		habilitado bit NOT NULL DEFAULT(1),
		ingresos_restantes tinyint NOT NULL DEFAULT(3)
	);

	--Sentencia crea tabla UsuariosXRoles
	CREATE TABLE MLJ.UsuariosXRoles (
		cod_usuario INTEGER NOT NULL,
		cod_rol INTEGER NOT NULL
	);

	--Sentencia crea tabla Roles
	CREATE TABLE MLJ.Roles (
		cod_rol INTEGER IDENTITY(1,1) PRIMARY KEY,
		descripcion varchar(255) NOT NULL,
		habilitado bit NOT NULL DEFAULT(1),
		registrable bit NOT NULL DEFAULT(1)		
	);

	--Sentencia crea tabla RolesXFuncionalidades
	CREATE TABLE MLJ.RolesXFuncionalidades (
		cod_rol INTEGER NOT NULL,
		cod_funcionalidad INTEGER NOT NULL		
	);

	--Sentencia crea tabla Funcionalidades
	CREATE TABLE MLJ.Funcionalidades (
		cod_funcionalidad INTEGER IDENTITY(1,1) PRIMARY KEY NOT NULL,
		descripcion varchar(255) NOT NULL	
	);

	--Sentencia crea tabla Viajes
	CREATE TABLE MLJ.Viajes (
		cod_viaje INTEGER IDENTITY(1,1) PRIMARY KEY,
		fecha_inicio datetime NOT NULL,
		fecha_fin_estimada datetime,
		fecha_fin datetime NOT NULL,
		cod_recorrido INTEGER NOT NULL,
		cod_crucero INTEGER NOT NULL,
		retorna bit NOT NULL,
		razon_de_cancelacion varchar(255)
	);

	--Sentencia crea tabla Recorridos
	CREATE TABLE MLJ.Recorridos (
		cod_recorrido INTEGER IDENTITY(1,1) PRIMARY KEY,
		habilitado bit NOT NULL DEFAULT(1),
		cod_viejo DECIMAL(18,0)
	);

	--Sentencia crea tabla Tramos
	CREATE TABLE MLJ.Tramos (
		cod_recorrido INTEGER, --Se coloca luego el constraint NOT NULL, se necesita que permita NULL durante la migracion
		nro_tramo TINYINT NOT NULL,
		cod_puerto_salida INTEGER NOT NULL,
		cod_puerto_llegada INTEGER NOT NULL,
		costo numeric(18,2) NOT NULL,
		primary key(cod_recorrido,nro_tramo)
	);


	--Sentencia crea tabla Puertos
	CREATE TABLE MLJ.Puertos (
		cod_puerto INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL,
		habilitado bit NOT NULL DEFAULT(1)	
	);

	--Sentencia crea tabla Marcas
	CREATE TABLE MLJ.Marcas (
		cod_marca INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Servicios
	CREATE TABLE MLJ.Servicios (
		cod_servicio INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Fabricantes
	CREATE TABLE MLJ.Fabricantes (
		cod_fabricante INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Modelos
	CREATE TABLE MLJ.Modelos (
		cod_modelo INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Cruceros
	CREATE TABLE MLJ.Cruceros (
		cod_crucero INTEGER IDENTITY(1,1) PRIMARY KEY,
		identificador varchar(50) NOT NULL,
		fecha_alta datetime,
		cod_marca INTEGER,	
		cod_servicio INTEGER,
		cod_fabricante INTEGER NOT NULL,
		cod_modelo INTEGER NOT NULL
	);

	--Sentencia crea tabla Bajas_de_servicio
	CREATE TABLE MLJ.Bajas_de_servicio (
		cod_baja INTEGER IDENTITY(1,1) PRIMARY KEY,
		cod_crucero INTEGER NOT NULL,
		permanente bit NOT NULL DEFAULT(0),
		fecha_baja datetime NOT NULL,
		fecha_alta datetime,
		CHECK(NOT permanente = 1 OR fecha_alta IS NULL)
	);

	--Sentencia crea tabla Cabinas
	CREATE TABLE MLJ.Cabinas (
		cod_cabina INTEGER IDENTITY(1,1),
		cod_crucero INTEGER NOT NULL,
		nro decimal(18,0) NOT NULL,
		cod_tipo INTEGER NOT NULL,
		piso decimal(18,0) NOT NULL,
		primary key(cod_cabina)
	);

	--Sentencia crea tabla Tipo_Cabinas
	CREATE TABLE MLJ.Tipo_Cabinas (
		cod_tipo INTEGER IDENTITY(1,1) PRIMARY KEY,
		valor numeric(4,2) NOT NULL,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Reservas
	CREATE TABLE MLJ.Reservas (
		cod_reserva INTEGER IDENTITY(1,1) PRIMARY KEY,
		fecha_reserva datetime NOT NULL,
		cod_pasaje INTEGER NOT NULL,
		cod_viejo decimal(18,0)
	);

	--Sentencia crea tabla Pasajes
	CREATE TABLE MLJ.Pasajes (
		cod_pasaje INTEGER IDENTITY(1,1) PRIMARY KEY,
		cod_cliente INTEGER NOT NULL,
		cod_viaje INTEGER NOT NULL,
		cod_pago INTEGER,
		cantidad numeric(18,2) NOT NULL,
		cod_viejo DECIMAL(18,0)
	);

	--Sentencia crea tabla Cabinas_reservadas
	CREATE TABLE MLJ.Cabinas_reservadas (
		cod_pasaje INTEGER NOT NULL,
		cod_cabina INTEGER NOT NULL,
		primary key(cod_pasaje, cod_cabina)
	);

	--Sentencia crea tabla Pagos
	CREATE TABLE MLJ.Pagos (
		cod_pago INTEGER IDENTITY(1,1) PRIMARY KEY,
		fecha datetime NOT NULL,
		cod_medio INTEGER,
		hash_nro_tarjeta char(255),
		ultimos_digitos char(4),
		cod_seguridad char(4)
	);

	--Sentencia crea tabla Medios_de_Pago
	CREATE TABLE MLJ.Medios_de_Pago (
		cod_medio INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL
	);

	--Sentencia crea tabla Clientes
	CREATE TABLE MLJ.Clientes (
		cod_cliente INTEGER IDENTITY(1,1) PRIMARY KEY,
		nombre varchar(255) NOT NULL,
		apellido varchar(255) NOT NULL,
		dni decimal(18,0) NOT NULL,
		direccion varchar(255) NOT NULL,
		telefono INTEGER NOT NULL,
		mail varchar(255),
		nacimiento datetime NOT NULL
	
	);

	/*----Aca creamos foreign keys------*/
	ALTER TABLE MLJ.UsuariosXRoles ADD
	CONSTRAINT fk_usuariorol_usuario FOREIGN KEY (cod_usuario) REFERENCES MLJ.Usuarios(cod_usuario)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_usuariorol_rol FOREIGN KEY (cod_rol) REFERENCES MLJ.Roles(cod_rol)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.RolesXFuncionalidades ADD
	CONSTRAINT fk_rolfuncionalidad_rol FOREIGN KEY (cod_rol) REFERENCES MLJ.Roles(cod_rol)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_rolfuncionalidad_func FOREIGN KEY (cod_funcionalidad) REFERENCES MLJ.Funcionalidades(cod_funcionalidad)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Viajes ADD
	CONSTRAINT fk_viajes_recorrido FOREIGN KEY (cod_recorrido) REFERENCES MLJ.Recorridos(cod_recorrido)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_viajes_crucero FOREIGN KEY (cod_crucero) REFERENCES MLJ.Cruceros(cod_crucero)
	ON DELETE NO ACTION ON UPDATE NO ACTION;

	ALTER TABLE MLJ.Tramos ADD
	CONSTRAINT fk_tramos_recorrido FOREIGN KEY (cod_recorrido) REFERENCES MLJ.Recorridos(cod_recorrido)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_tramos_puerto_salida FOREIGN KEY (cod_puerto_salida) REFERENCES MLJ.Puertos(cod_puerto)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_tramos_puerto_llegada FOREIGN KEY (cod_puerto_llegada) REFERENCES MLJ.Puertos(cod_puerto)
	ON DELETE NO ACTION ON UPDATE NO ACTION;

	ALTER TABLE MLJ.Cruceros ADD
	CONSTRAINT fk_cruceros_marca FOREIGN KEY (cod_marca) REFERENCES MLJ.Marcas(cod_marca)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_cruceros_servicio FOREIGN KEY (cod_servicio) REFERENCES MLJ.Servicios(cod_servicio)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_cruceros_fabricante FOREIGN KEY (cod_fabricante) REFERENCES MLJ.Fabricantes(cod_fabricante)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_cruceros_modelo FOREIGN KEY (cod_modelo) REFERENCES MLJ.Modelos(cod_modelo)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Bajas_de_servicio ADD
	CONSTRAINT fk_bajas_crucero FOREIGN KEY (cod_crucero) REFERENCES MLJ.Cruceros(cod_crucero)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Cabinas ADD
	CONSTRAINT fk_cabinas_crucero FOREIGN KEY (cod_crucero) REFERENCES MLJ.Cruceros(cod_crucero)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_cabinas_tipo FOREIGN KEY (cod_tipo) REFERENCES MLJ.Tipo_Cabinas(cod_tipo)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Reservas ADD
	CONSTRAINT fk_reservas_pasaje FOREIGN KEY (cod_pasaje) REFERENCES MLJ.Pasajes(cod_pasaje)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Pasajes ADD
	CONSTRAINT fk_pasajes_cliente FOREIGN KEY (cod_cliente) REFERENCES MLJ.Clientes(cod_cliente)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_pasajes_viaje FOREIGN KEY (cod_viaje) REFERENCES MLJ.Viajes(cod_viaje)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_pasajes_pago FOREIGN KEY (cod_pago) REFERENCES MLJ.Pagos(cod_pago)
	ON DELETE NO ACTION ON UPDATE CASCADE;

	ALTER TABLE MLJ.Cabinas_reservadas ADD
	CONSTRAINT fk_cabinas_reservadas_cliente FOREIGN KEY (cod_pasaje) REFERENCES MLJ.Pasajes(cod_pasaje)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_cabinas_reservadas_cabina FOREIGN KEY (cod_cabina) REFERENCES MLJ.Cabinas(cod_cabina)
	ON DELETE NO ACTION ON UPDATE NO ACTION;

	ALTER TABLE MLJ.Pagos ADD
	CONSTRAINT fk_pagos_medio FOREIGN KEY (cod_medio) REFERENCES MLJ.Medios_de_Pago(cod_medio)
	ON DELETE NO ACTION ON UPDATE CASCADE;
	/*--------------------------------*/
END
GO

--Este procedure se encarga de crear funcionalidades del tp
CREATE PROCEDURE MLJ.crear_funciones
AS
BEGIN
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('Compra y/o Reserva de Viaje');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('Pago Reserva');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ABM Puertos');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ABM Rol');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ABM Usuarios');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ABM Recorridos');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ABM Cruceros');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('Generar Viaje');
	INSERT INTO MLJ.Funcionalidades (descripcion) VALUES ('ListadosTOP');
END
GO

--Este procedure se encarga de crear roles del tp
CREATE PROCEDURE MLJ.crear_roles
AS
BEGIN
	INSERT INTO MLJ.Roles (descripcion, habilitado, registrable) VALUES ('Administrador', 1, 0)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 1)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 2)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 3)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 4)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 5)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 6)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 7)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 8)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (1, 9)
	INSERT INTO MLJ.Roles (descripcion, habilitado, registrable) VALUES ('Usuario', 1, 1)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (2, 1)
	INSERT INTO MLJ.RolesXFuncionalidades (cod_rol, cod_funcionalidad) VALUES (2, 2)
END
GO

--Este procedure se encarga de crear usuarios con roles
CREATE PROCEDURE MLJ.crear_usuarios
AS
BEGIN
	INSERT MLJ.Usuarios (usuario, hash_contrasenia) VALUES ('admin','e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7')
	INSERT MLJ.UsuariosXRoles (cod_usuario, cod_rol) VALUES (1, 1)
	INSERT MLJ.Usuarios (usuario, hash_contrasenia) VALUES ('admin2','e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7')
	INSERT MLJ.UsuariosXRoles (cod_usuario, cod_rol) VALUES (2, 1)
	INSERT MLJ.Usuarios (usuario, hash_contrasenia) VALUES ('admin3','e6b87050bfcb8143fcb8db0170a4dc9ed00d904ddd3e2a4ad1b1e8dc0fdc9be7')
	INSERT MLJ.UsuariosXRoles (cod_usuario, cod_rol) VALUES (3, 1)
END
GO

CREATE PROCEDURE MLJ.verificar_viaje @codigo_recorrido int, @cod_crucero int, @fechaSalida datetime, @fechaLlegada datetime, @fechaActual datetime, @retorno bit, @resultado int output
AS
BEGIN
	IF (@fechaActual >= @fechaSalida)
		BEGIN
		SET @resultado = -1
		END
	ELSE IF NOT EXISTS(SELECT cod_crucero FROM MLJ.Cruceros WHERE cod_crucero NOT IN (select cod_crucero FROM MLJ.Bajas_de_servicio WHERE permanente = 1) AND cod_crucero NOT IN (SELECT viajes.cod_crucero FROM MLJ.Viajes viajes WHERE (viajes.fecha_inicio BETWEEN @fechaSalida AND @fechaLlegada) AND (viajes.fecha_fin BETWEEN @fechaSalida AND @fechaLlegada)))
		BEGIN
		SET @resultado = -2
		END
	ELSE IF EXISTS(SELECT * FROM MLJ.Cruceros cruceros JOIN MLJ.Bajas_de_servicio bajas ON (bajas.cod_crucero = @cod_crucero ) WHERE permanente = 1)
		BEGIN
		SET @resultado = -3
		END
	ELSE IF EXISTS(SELECT * FROM MLJ.Recorridos WHERE cod_recorrido = @codigo_recorrido AND habilitado = 0)
		BEGIN
		SET @resultado = -4
		END
	ELSE 
		BEGIN
		INSERT INTO MLJ.Viajes(fecha_inicio, fecha_fin, cod_recorrido, cod_crucero,retorna)
			VALUES (@fechaSalida, @fechaLlegada, @codigo_recorrido,@cod_crucero, @retorno)
		SET @resultado = 1
		END
END
GO

--Este procedure se encarga de comprobar la password, el estado del usuario y devuelve el resultado
CREATE PROCEDURE MLJ.login @usuario varchar(50), @password varchar(256), @resultado int OUTPUT
AS
BEGIN
	
	/*
	0 -> Usuario Deshabilitado
	1 -> Password ok
	2 -> Password no ok
	3 -> User not found
	*/

	SET @resultado = ISNULL((SELECT 
								CASE 
								WHEN ingresos_restantes = 0 THEN 0
								WHEN (CONVERT(CHAR(256),HASHBYTES('SHA2_256',@password),2) = hash_contrasenia) THEN 1
								ELSE 2
								END
							FROM MLJ.Usuarios
							WHERE usuario = @usuario),3)
	/*Si la passwrod no es correcta resto la cantidad de intentos*/
	IF(@resultado = 2) 
	BEGIN
		UPDATE MLJ.Usuarios SET ingresos_restantes = ingresos_restantes - 1 WHERE usuario=@usuario; 
	END
	/*Si la loguea bien reinicio la cant de intentos, si esta deshabilitado no loguea ni reinicio cant de intentos*/
	IF (@resultado = 1)
	BEGIN
		UPDATE MLJ.Usuarios SET ingresos_restantes = 3 WHERE usuario = @usuario;
	END
END
GO 

--Ejecuto procedure creado anteriormente que crea las tablas
BEGIN
	EXEC MLJ.crear_tablas;
	EXEC MLJ.crear_funciones;
	EXEC MLJ.crear_roles;
	EXEC MLJ.crear_usuarios;
END
GO

IF(OBJECT_ID('MLJ.BajaLogicaROL') IS NOT NULL)
	DROP TRIGGER MLJ.BajaLogicaROL
GO

CREATE TRIGGER MLJ.BajaLogicaROL 
ON MLJ.Roles AFTER UPDATE
AS
BEGIN

BEGIN TRANSACTION
DELETE FROM MLJ.UsuariosXRoles WHERE cod_rol IN (SELECT i.cod_rol FROM inserted i WHERE i.habilitado = 0);
COMMIT TRANSACTION

END
GO

IF(OBJECT_ID('MLJ.BajaLogicaPuerto') IS NOT NULL)
	DROP TRIGGER MLJ.BajaLogicaPuerto
GO

CREATE TRIGGER MLJ.BajaLogicaPuerto 
ON MLJ.Puertos AFTER UPDATE
AS
BEGIN
	
	SELECT i.cod_puerto
	into #PuertosBaja 
	FROM inserted i 
	WHERE i.habilitado = 0

	select cod_recorrido 
	into #RecorridosTemp
	FROM MLJ.Tramos 
	WHERE cod_puerto_salida IN (select * FROM #PuertosBaja) OR cod_puerto_llegada IN (select * FROM #PuertosBaja)
	
	BEGIN TRANSACTION
	UPDATE MLJ.Recorridos SET habilitado = 0 
	WHERE cod_recorrido IN (select * FROM #RecorridosTemp)
	UPDATE MLJ.Viajes SET razon_de_cancelacion = 'VIAJE CANCELADO POR PUERTO DADO DE BAJA, HAY QUE PRODUCIR REEMBOLSO DE LOS PASAJES' 
	WHERE cod_recorrido IN (select * FROM #RecorridosTemp)
	COMMIT TRANSACTION

END
GO