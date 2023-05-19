create database universitySystem;
use universitySystem;

create table evento (
	idEvento int auto_increment primary key,
	nomeEvento varchar(100) NOT NULL,
	data DATE NOT NULL,
    local_FK int NOT NULL,
	inicio time NOT NULL,
    fim time NOT NULL,
    responsavel varchar(50),
    n_participantes int not null,
    dtAbertura datetime NOT NULL,
    dtFinal datetime not null,
    idUsuario_FK int not null,
    foreign key (local_FK) references local(idLocal),
    foreign key (idUsuario_FK) references usuario(idUsuario)
);

insert into evento (nomeEvento, data, local_FK, inicio, fim, responsavel, n_participantes, dtAbertura, dtFinal, idUsuario_FK) VALUES
	('ajudaSOS', '2023-05-19', 1, '10:00', '11:00', 'ale', 10, '2023-05-15 18:00', '2023-05-18 18:00', 1),
	('comidas', '2023-06-20', 3, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2),
	('festa', '2023-06-20', 1, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2),
	('macarrao', '2023-06-20', 3, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2);

create table email(
	idEmail int primary key auto_increment,
    destinario varchar(255) not null,
    titulo varchar(255) not null,
    assunto varchar(255) not null,
    idEvento_FK int not null,
    foreign key (idEvento_FK) references evento(idEvento)
);

create table usuario (
	idUsuario int primary key auto_increment, 
	nome varchar(255) not null,
    email varchar(255) not null,
    dtNasc date not null,
    senha varchar(255) not null,  
	dataCadastro datetime not null,
    ocupacao_FK int not null, 
    ativo bool not null,
    
    foreign key(ocupacao_FK) references ocupacao(idOcupacao)
);

insert into usuario (nome, email, dtNasc, senha, dataCadastro, ocupacao_FK, ativo) values
	('ale', 'ale@gmailcom', '2004-10-23', '456', '2023-05-18 02:15', 1, TRUE),
	('pato', 'pato@gmailcom', '2005-01-23', '123', '2023-05-18 03:15', 5, TRUE),
	('ju', 'ju@gmailcom', '2006-11-23', '789', '2023-05-18 04:15', 6, TRUE);
    
create table ocupacao(
	idOcupacao int primary key auto_increment,
    tipo varchar(50) not null,
	nivel_FK int not null,
    foreign key(nivel_FK) references niveis(idNivel)
);
-- add já os exsistentes, coordenador, orientador, assistente socual, secretaria, diretor, aluno, visitante

insert into ocupacao (tipo, nivel_FK) values
	('Coordenador', 2),
	('Orientador', 2),
	('Assistente Social', 2),
	('Secretaria', 2),
	('Diretor', 1),
	('Aluno', 3),
	('Visitante', 4);
    
create table niveis(
	idNivel int auto_increment primary key,
    tipo varchar(50) not null
);

insert into niveis (tipo) values
	('admin'),
	('gestor'),
	('usuario'),
	('visitante');
    
-- admin, gestor, usuario, visitante
create table local(
	idLocal int auto_increment primary key,
    nome varchar(100) not null,
    bloco char(1) not null,
    ocupacao_pessoas int not null
);

insert into local (NOME, BLOCO, OCUPACAO_PESSOAS) VALUES 
	('teatro', 'A', 20),
	('sala', 'B', 20),
	('campo', 'C', 20),
	('quadra', 'D', 20);
    
create table material(
	idMaterial int auto_increment primary key,
    nome varchar(50) not null
);

create table checklist(
	idChecklist int auto_increment primary key,
    idLocal_FK int not null,
    idMaterial_FK int not null,
    situação bool not null,
    
    foreign key(idLocal_FK) references local(idLocal),
    foreign key(idMaterial_FK) references material(idMaterial)
);

create table checkin (
	idCheckin int auto_increment primary key,
    dt datetime not null,
    idUsuario_FK int not null,
    idEvento_FK int not null,
    
    foreign key(idUsuario_FK) references usuario(idUsuario),
    foreign key(idEvento_FK) references evento(idEvento)
);

insert into checkin (dt, idUsuario_FK, idEvento_FK) values
	('2023-05-18', 1,2),
	('2023-05-18', 1,3);

DELIMITER $$
	CREATE TRIGGER tgr_checkin_updateEvento AFTER INSERT
    ON checkin
    FOR EACH ROW
    BEGIN
		UPDATE evento as e SET n_participantes = (n_participantes-1) WHERE idEvento = NEW.idEvento_FK;
    END $$
DELIMITER ;

-- CONSULTAS

-- (a)
SELECT count(lo.idLocal) as TOTAL_EVENTOS, lo.nome FROM local as lo
INNER JOIN evento as ev ON lo.idLocal = ev.local_FK
group by lo.idLocal;

-- (b)
SELECT lo.idLocal, lo.nome FROM local as lo where lo.idLocal not in (select local_FK from evento);

-- (c)
select * from evento
WHERE data >= '2023-05-20' and data <= '2023-08-14';

-- (d)
SELECT count(us.idUsuario) as TOTAL_EVENTOS, us.nome FROM usuario as us
INNER JOIN checkin as ch ON ch.idUsuario_FK = us.idUsuario
group by us.idUsuario;

-- (e)
SELECT ev.idEvento, ev.nomeEvento, ch.idUsuario_FK, us.nome as USER FROM evento as ev
INNER JOIN checkin as ch ON ch.idEvento_FK = ev.idEvento
INNER JOIN usuario as us ON us.idUsuario = ch.idUsuario_FK;

-- (f)
SELECT us.nome, count(us.idUsuario) as TOTAL_EVENTOS from usuario as us
INNER JOIN checkin as ch ON us.idUsuario = ch.idUsuario_FK
group by us.idUsuario;

-- (g?)
select ev.idEvento, ev.nomeEvento from evento as ev
INNER JOIN checkin as ch ON ch.idEvento_FK = ev.idEvento
GROUP BY ch.idEvento_FK HAVING COUNT(*) >= 1
ORDER BY COUNT(*) DESC
LIMIT 1;

-- (h)
select AVG(ev.n_participantes) as MEDIA, lo.nome FROM local as lo
INNER JOIN evento as ev ON lo.idLocal = ev.local_FK
GROUP by ev.local_FK;

-- (i)
select us.idUsuario, us.nome, nv.idNivel, nv.tipo from usuario as us
inner join ocupacao as oc ON oc.idOcupacao = us.ocupacao_FK
inner join niveis as nv ON nv.idNivel = oc.nivel_FK;

-- (j)
select ev.idEvento, ev.nomeEvento, ev.n_participantes FROM evento as ev
WHERE n_participantes > 0 AND dtAbertura < NOW() AND dtFinal != NOW();

-- (k)
select ev.idEvento, ev.nomeEvento FROM evento as ev
WHERE n_participantes = 0 AND data > NOW();

-- (l)
select ev.idEvento, ev.nomeEvento, ev.n_participantes FROM evento as ev
WHERE n_participantes > 0 AND dtAbertura < NOW() AND dtFinal != NOW();

-- (m)
select us.idUsuario, us.nome from usuario as us
inner join checkin as ch on ch.idUsuario_FK = us.idUsuario
group by us.idUsuario HAVING count(us.idUsuario) >= 2;

-- PARTE 2
-- (a)
use DumpIDESP;
select * from escola;

-- (a)
select id_municipio, AVG(nota_idesp_ef_iniciais) as MEDIA_INICIAIS, AVG(nota_idesp_ef_finais) as MEDIA_FINAIS, AVG(nota_idesp_em) as MEDIA_EM from escola
GROUP by id_municipio;

-- (b)
select ano, id_municipio, AVG(nota_idesp_ef_iniciais) as MEDIA_INICIAIS, AVG(nota_idesp_ef_finais) as MEDIA_FINAIS, AVG(nota_idesp_em) as MEDIA_EM from escola
GROUP by id_municipio, ano;

-- (c)
select id_municipio, AVG(nota_idesp_ef_iniciais + nota_idesp_ef_finais + nota_idesp_em) as MEDIA_GERAL from escola
GROUP by id_municipio;



