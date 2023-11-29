create database rede_social;
use rede_social;

CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY,
    Nome VARCHAR(50)
);

CREATE TABLE Postagens (
    PostagemID INT PRIMARY KEY,
    UsuarioID INT,
    Texto TEXT,
    DataPostagem DATE,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Comentarios (
    ComentarioID INT PRIMARY KEY,
    PostagemID INT,
    UsuarioID INT,
    Texto TEXT,
    DataComentario DATE,
    FOREIGN KEY (PostagemID) REFERENCES Postagens(PostagemID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Amizades (
    AmizadeID INT PRIMARY KEY,
    Usuario1ID INT,
    Usuario2ID INT,
    DataCriacao DATE,
    FOREIGN KEY (Usuario1ID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (Usuario2ID) REFERENCES Usuarios(UsuarioID)
);

SELECT *
FROM Postagens
WHERE UsuarioID = (SELECT UsuarioID FROM Usuarios WHERE Nome = 'João');

SELECT c.*
FROM Comentarios c
JOIN Postagens p ON c.PostagemID = p.PostagemID
WHERE p.Texto = 'Bom dia, mundo!';

SELECT
    u.Nome as Usuario,
    COUNT(DISTINCT p.PostagemID) as TotalPostagens,
    COUNT(DISTINCT c.ComentarioID) as TotalComentarios
FROM Usuarios u
LEFT JOIN Postagens p ON u.UsuarioID = p.UsuarioID
LEFT JOIN Comentarios c ON u.UsuarioID = c.UsuarioID
GROUP BY u.UsuarioID, u.Nome;

SELECT *
FROM Amizades
WHERE DataCriacao >= CURDATE() - INTERVAL 30 DAY;

SELECT
    u.Nome as Usuario,
    p.Texto as Postagem,
    a.AmizadeID,
    u2.Nome as Amigo
FROM Usuarios u
LEFT JOIN Postagens p ON u.UsuarioID = p.UsuarioID
LEFT JOIN Amizades a ON u.UsuarioID = a.Usuario1ID OR u.UsuarioID = a.Usuario2ID
LEFT JOIN Usuarios u2 ON u.UsuarioID = a.Usuario2ID AND u2.UsuarioID <> u.UsuarioID
WHERE u.Nome = 'Maria';