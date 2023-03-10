USE [master]
GO
/****** Object:  Database [hramos_db]    Script Date: 1/9/2023 12:15:59 AM ******/
CREATE DATABASE [hramos_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hramos_db', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HJONATHANR\MSSQL\DATA\hramos_db.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hramos_db_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.HJONATHANR\MSSQL\DATA\hramos_db_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [hramos_db] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hramos_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hramos_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hramos_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hramos_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hramos_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hramos_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [hramos_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hramos_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hramos_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hramos_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hramos_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hramos_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hramos_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hramos_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hramos_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hramos_db] SET  ENABLE_BROKER 
GO
ALTER DATABASE [hramos_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hramos_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hramos_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hramos_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hramos_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hramos_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hramos_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hramos_db] SET RECOVERY FULL 
GO
ALTER DATABASE [hramos_db] SET  MULTI_USER 
GO
ALTER DATABASE [hramos_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hramos_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hramos_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hramos_db] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [hramos_db] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [hramos_db] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'hramos_db', N'ON'
GO
ALTER DATABASE [hramos_db] SET QUERY_STORE = ON
GO
ALTER DATABASE [hramos_db] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [hramos_db]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscarNuevoCodEquivalente]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Henry Ramos>
-- Create date: <08/01/2023>
/* Description:	<Recibir 3 parametros (Codigo Antiguo, Talla y Color),
				 Concatenar los parametros en el formato estandar para referencia cruzada,
				 Buscar el valor en la tabla de referencia cruzada y devolver el nuevo codigo equivalente> */
-- =============================================
CREATE FUNCTION [dbo].[fn_BuscarNuevoCodEquivalente] 
(
	@CodAntiguo varchar(13),
	@Talla varchar(1),
	@Color varchar(15)
)
RETURNS varchar(13)
AS
BEGIN
	DECLARE @CodigoItem varchar(13);
	DECLARE @CodSKU varchar(13);

	Select @CodSKU = CONCAT(@CodAntiguo, '.', @Talla, '.', @Color);

	SELECT @CodigoItem = Codigo_Item from CodigosRefCruzada where Codigo_SKULegacy = @CodSKU

	-- Return the result of the function
	RETURN @CodigoItem

END
GO
/****** Object:  Table [dbo].[CodigosRefCruzada]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CodigosRefCruzada](
	[Codigo_SKULegacy] [varchar](13) NOT NULL,
	[Codigo_Item] [varchar](13) NOT NULL,
 CONSTRAINT [PK_CodigosRefCruzada] PRIMARY KEY CLUSTERED 
(
	[Codigo_SKULegacy] ASC,
	[Codigo_Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Items]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Items](
	[Codigo_Item] [varchar](13) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Codigo_Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Produccion]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Produccion](
	[ProduccionId] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NULL,
	[Codigo_Seccion] [varchar](6) NULL,
	[Codigo_Item] [varchar](13) NULL,
	[Cant_Unidades] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProduccionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CodigosRefCruzada] ([Codigo_SKULegacy], [Codigo_Item]) VALUES (N'2727.M.BLACK', N'SG.2727.M.301')
INSERT [dbo].[CodigosRefCruzada] ([Codigo_SKULegacy], [Codigo_Item]) VALUES (N'3930.L.WHITE', N'SG.3930.L.309')
GO
INSERT [dbo].[Items] ([Codigo_Item]) VALUES (N'SG.2727.M.301')
INSERT [dbo].[Items] ([Codigo_Item]) VALUES (N'SG.3930.L.309')
GO
SET IDENTITY_INSERT [dbo].[Produccion] ON 

INSERT [dbo].[Produccion] ([ProduccionId], [Fecha], [Codigo_Seccion], [Codigo_Item], [Cant_Unidades]) VALUES (1, CAST(N'2023-01-08T00:00:00.000' AS DateTime), N'SECC01', N'SG.3930.L.309', 60)
SET IDENTITY_INSERT [dbo].[Produccion] OFF
GO
ALTER TABLE [dbo].[CodigosRefCruzada]  WITH CHECK ADD  CONSTRAINT [FK_CodigosRefCruzada_Items] FOREIGN KEY([Codigo_Item])
REFERENCES [dbo].[Items] ([Codigo_Item])
GO
ALTER TABLE [dbo].[CodigosRefCruzada] CHECK CONSTRAINT [FK_CodigosRefCruzada_Items]
GO
ALTER TABLE [dbo].[Produccion]  WITH CHECK ADD  CONSTRAINT [FK_Produccion_Items] FOREIGN KEY([Codigo_Item])
REFERENCES [dbo].[Items] ([Codigo_Item])
GO
ALTER TABLE [dbo].[Produccion] CHECK CONSTRAINT [FK_Produccion_Items]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarProduccion]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Henry Ramos>
-- Create date: <08/01/2023>
/* Description:	<Almacena la produccion recibiendo como parametro los datos pertenecientes a la tabla [dbo].[Produccion] y 
				 utilizando la funcion [dbo].[fn_BuscarNuevoCodEquivalente] para obtener el nuevo codigo equivalente>
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_InsertarProduccion] 
	-- Add the parameters for the stored procedure here
	@Fecha datetime,
	@CodSeccion varchar(6),
	@CantidadUnid int,
	@CodSKU varchar(13),
	@Talla varchar(1),
	@Color varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CodItem varchar(13) 
	SET @CodItem = [dbo].[fn_BuscarNuevoCodEquivalente](@CodSKU, @Talla, @Color)

	INSERT INTO Produccion
	(
		[Fecha], [Codigo_Seccion], [Codigo_Item], [Cant_Unidades]
	)
	VALUES
	(
		@Fecha, @CodSeccion, @CodItem, @CantidadUnid
	)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_MostrarProduccion]    Script Date: 1/9/2023 12:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Henry Ramos>
-- Create date: <08/01/2023>
-- Description:	<Mostrar la informacion de la tabla [dbo].[Produccion]>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MostrarProduccion]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT Fecha, Codigo_Seccion, Codigo_Item, Cant_Unidades FROM [dbo].[Produccion]
END
GO
USE [master]
GO
ALTER DATABASE [hramos_db] SET  READ_WRITE 
GO
