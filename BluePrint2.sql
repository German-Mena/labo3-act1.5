Create database BluePrint2

Go

Use BluePrint2

GO

CREATE TABLE TiposClientes(
  ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  Descripcion VARCHAR(50) NOT NULL
)

GO

CREATE TABLE Clientes(
  ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  RazonSocial VARCHAR(50) NOT NULL,
  IDTipoCliente INT NOT NULL FOREIGN KEY REFERENCES TiposClientes(ID),
  Cuit VARCHAR(12) NOT NULL UNIQUE,
  Email VARCHAR(50) NULL,
  TelefonoFijo VARCHAR(20) NULL,
  TelefonoMovil VARCHAR(20) NULL
    
)

GO

CREATE TABLE Proyectos(
  ID VARCHAR(5) NOT NULL PRIMARY KEY,
  Nombre VARCHAR(40) NOT NULL,
  Descripcion VARCHAR(100) NULL,
  Costo MONEY NOT NULL,
  FechaInicio DATE NOT NULL,
  FechaFin DATE NULL,
  IDCliente INT NOT NULL FOREIGN KEY REFERENCES Clientes(ID),
  Estado BIT NOT NULL
)

create table Modulos(
	ID int primary key identity(1,1) not null,
	Nombre varchar(50) not null,
	Descripcion varchar(512) null,
	CostoEstimado money not null check(CostoEstimado > 0),  
	TiempoEstimado smallint not null check(TiempoEstimado > 0),
	FechaInicio date null, 
	FechaEstimadaFin date null,
	FechaFin date null,
	IDProyecto varchar(5) not null foreign key references Proyectos(ID)
)

GO

/* Esto lo hago aca porque la restriccion aplica a mas de 1 columna */

ALTER TABLE Modulos add constraint CHK_FechaFin check (FechaFin >= FechaInicio)
ALTER TABLE Modulos add constraint CHK_FechaEstimadaFin check (FechaEstimadaFin >= FechaInicio)

GO

CREATE TABLE Paises(
	ID SMALLINT primary key identity(1,1) not null,
	Nombre varchar(50) not null
)

CREATE TABLE Ciudades(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Nombre VARCHAR(100) NOT NULL,
	IDPais SMALLINT not null foreign key references Paises(ID)
)

CREATE TABLE Colaboradores(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	Nombre VARCHAR(100) NOT NULL,
	Apellido VARCHAR(100) NOT NULL, 
	FechaNacimiento DATE NOT NULL CHECK(FechaNacimiento < GETDATE()),
	Tipo CHAR(1) NOT NULL CHECK(Tipo = 'I' OR Tipo = 'E'),
	Domicilio VARCHAR(250) NULL,
	IDCiudad INT NULL foreign key references Ciudades(ID),
	EMail VARCHAR(250) NULL,
	Celular VARCHAR(50) NULL,
	CONSTRAINT CHK_EMailCelular CHECK(EMail IS NOT NULL OR Celular IS NOT NULL)
)

GO

ALTER TABLE Clientes
	ADD IDCiudad INT NULL foreign key references Ciudades(ID)

GO

create table tareas(
	ID int identity(1,1),
	IDmodulo int not null,
	tipoTarea varchar(100) not null,
	fechaInicio date null,
	fechaFin date null,
	estado bit default(1),
	primary key(ID),

)

GO

create table tareasColaboradores(
	IDcolaborador int not null,
	IDtarea int not null,
	horasTrabajadas smallint not null check(horasTrabajadas>0),
	valorHora money not null check(valorHora>0),
	estado bit default(0),
	primary key(IDcolaborador, IDtarea),
	foreign key (IDcolaborador) references Colaboradores(ID),
	foreign key (IDtarea) references tareas(ID)
)
