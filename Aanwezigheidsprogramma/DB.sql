-- Maak de databank als hij nog niet bestaat
IF DB_ID('Aanwezigheidsprogramma') IS NULL
    CREATE DATABASE Aanwezigheidsprogramma;
GO

USE Aanwezigheidsprogramma;
GO

-- Verwijder alle fk's als ze bestaan
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Groep_id')
    ALTER TABLE [dbo].[Gebruiker] DROP CONSTRAINT [FK_Groep_id];

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_group_id')
    ALTER TABLE [dbo].[Event_groep] DROP CONSTRAINT [FK_group_id];

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_event_id')
    ALTER TABLE [dbo].[Event_groep] DROP CONSTRAINT [FK_event_id];

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_gebruiker_id')
    ALTER TABLE [dbo].[Aanwezigheid] DROP CONSTRAINT [FK_gebruiker_id];

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_event_id_Aanwezigheid')
    ALTER TABLE [dbo].[Aanwezigheid] DROP CONSTRAINT [FK_event_id_Aanwezigheid];

-- Verwijder tabellen als ze bestaan
IF OBJECT_ID('[dbo].[Aanwezigheid]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Aanwezigheid];
IF OBJECT_ID('[dbo].[Event_groep]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Event_groep];
IF OBJECT_ID('[dbo].[Gebruiker]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Gebruiker];
IF OBJECT_ID('[dbo].[Event]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Event];
IF OBJECT_ID('[dbo].[Groep]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Groep];

-- Maak de tabel Groep
CREATE TABLE [dbo].[Groep]
(
    [id] INT NOT NULL,
    [naam] NVARCHAR(255) NOT NULL,
    PRIMARY KEY ([id])
);

-- Maak de tabel Gebruiker
CREATE TABLE [dbo].[Gebruiker]
(
    [id] INT NOT NULL,
    [naam] NVARCHAR(255) NOT NULL,
    [voornaam] NVARCHAR(255) NOT NULL,
    [adres] NVARCHAR(255) NOT NULL,
    [email] NVARCHAR(255) NOT NULL,
    [passwoord] NVARCHAR(255) NOT NULL,
    [is_admin] BIT NOT NULL,
    [groep_id] INT NOT NULL,
    PRIMARY KEY ([id]),
    CONSTRAINT [FK_Groep_id] FOREIGN KEY ([groep_id]) REFERENCES Groep([id])
);

-- Maak de tabel Event
CREATE TABLE [dbo].[Event]
(
    [id] INT NOT NULL,
    [naam] NVARCHAR(255) NOT NULL,
    [plaats] NVARCHAR(255) NOT NULL,
    [startDatumTijd] DATETIME NOT NULL,
    [eindDatumTijd] DATETIME NOT NULL,
    PRIMARY KEY ([id])
);

-- Maak de tabel Event_groep
CREATE TABLE [dbo].[Event_groep]
(
    [group_id] INT NOT NULL,
    [event_id] INT NOT NULL,
    CONSTRAINT [FK_group_id] FOREIGN KEY ([group_id]) REFERENCES Groep([id]),
    CONSTRAINT [FK_event_id] FOREIGN KEY ([event_id]) REFERENCES Event([id]),
    PRIMARY KEY ([group_id], [event_id])
);

-- CMaak de tabel Aanwezigheid
CREATE TABLE [dbo].[Aanwezigheid]
(
    [gebruiker_id] INT NOT NULL,
    [event_id] INT NOT NULL,
    [is_aanwezig] BIT NOT NULL,
    CONSTRAINT [FK_gebruiker_id] FOREIGN KEY ([gebruiker_id]) REFERENCES Gebruiker([id]),
    CONSTRAINT [FK_event_id_Aanwezigheid] FOREIGN KEY ([event_id]) REFERENCES Event([id]),
    PRIMARY KEY ([gebruiker_id], [event_id])
);
