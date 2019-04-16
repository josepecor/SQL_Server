
use DB_Destino
go

/******************** Copiar tablas de una base de datos a otra  del mismo Servidor **********************************/

declare @existe int = 0 


--Reviso si existe la tabla en destino ya que no deja volcarla si ya existe
select @existe=count(*) from sys.objects where name='Tabla'


--Si existe la borro para posteriormente volverla a volcar
IF @existe > 0 BEGIN
	drop Table [dbo].[Tabla]
END

set @existe = 0

SELECT *
INTO [DB_Destino].[dbo].[Tabla]
FROM [DB_Origen].[dbo].[Tabla]
