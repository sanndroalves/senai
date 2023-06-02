

create table niveis(
	idNivel int auto_increment primary key,
    tipo varchar(50) not null
);

create table ocupacao(
	idOcupacao int primary key auto_increment,
    tipo varchar(50) not null,
	nivel_FK int not null,
    foreign key(nivel_FK) references niveis(idNivel)
);

create table local(
	idLocal int auto_increment primary key,
    nome varchar(100) not null,
    bloco char(1) not null,
    ocupacao_pessoas int not null
);

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

create table email(
	idEmail int primary key auto_increment,
    destinario varchar(255) not null,
    titulo varchar(255) not null,
    assunto varchar(255) not null,
    idEvento_FK int not null,
    foreign key (idEvento_FK) references evento(idEvento)
);

create table checkin (
	idCheckin int auto_increment primary key,
    dt datetime not null,
    idUsuario_FK int not null,
    idEvento_FK int not null,
    
    foreign key(idUsuario_FK) references usuario(idUsuario),
    foreign key(idEvento_FK) references evento(idEvento)
);


DELIMITER $$
	CREATE TRIGGER tgr_checkin_updateEvento AFTER INSERT
    ON checkin
    FOR EACH ROW
    BEGIN
		UPDATE evento as e SET n_participantes = (n_participantes-1) WHERE idEvento = NEW.idEvento_FK;
    END $$
DELIMITER ;

insert into local (NOME, BLOCO, OCUPACAO_PESSOAS) VALUES 
	('teatro', 'A', 20),
	('sala', 'B', 20),
	('campo', 'C', 20),
	('quadra', 'D', 20);


insert into niveis (tipo) values
	('admin'),
	('gestor'),
	('usuario'),
	('visitante');
    
insert into ocupacao (tipo, nivel_FK) values
	('Coordenador', 2),
	('Orientador', 2),
	('Assistente Social', 2),
	('Secretaria', 2),
	('Diretor', 1),
	('Aluno', 3),
	('Visitante', 4);
    
insert into usuario (nome, email, dtNasc, senha, dataCadastro, ocupacao_FK, ativo) values
	('ale', 'ale@gmailcom', '2004-10-23', '456', '2023-05-18 02:15', 1, TRUE),
	('pato', 'pato@gmailcom', '2005-01-23', '123', '2023-05-18 03:15', 5, TRUE),
	('ju', 'ju@gmailcom', '2006-11-23', '789', '2023-05-18 04:15', 6, TRUE);

insert into local (NOME, BLOCO, OCUPACAO_PESSOAS) VALUES 
	('teatro', 'A', 20),
	('sala', 'B', 20),
	('campo', 'C', 20),
	('quadra', 'D', 20);
    
    
insert into evento (nomeEvento, data, local_FK, inicio, fim, responsavel, n_participantes, dtAbertura, dtFinal, idUsuario_FK) VALUES
	('ajudaSOS', '2023-05-19', 1, '10:00', '11:00', 'ale', 10, '2023-05-15 18:00', '2023-05-18 18:00', 1),
	('comidas', '2023-06-20', 3, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2),
	('festa', '2023-06-20', 1, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2),
	('macarrao', '2023-06-20', 3, '09:00', '11:00', 'pato', 20, '2023-05-15 18:00', '2023-05-18 18:00', 2);

insert into checkin (dt, idUsuario_FK, idEvento_FK) values
	('2023-05-18', 1,2),
	('2023-05-18', 1,3);

create table telefone(
	id INT primary key auto_increment,
    ddd varchar(3) not null,
    numero varchar(9) not null,
    idUsuario_FK int not null,
    foreign key(idUsuario_FK) references usuario(idUsuario)
);

ALTER TABLE usuario ADD COLUMN img varchar(255) not null;


create table status_tarefa(
	idStatus int primary key auto_increment,
    descricao varchar(25) not null
);

create table tarefa(
	idTarefa int primary key auto_increment,
    nome varchar(50) not null,
    descricao varchar(255) not null,
    dtPrazo DATE not null,
    dtAbertura DATETIME not null,
    dtFinalizacao DATE null,
    idLocal_FK int not null,
    idUsuario_FK int not null,
    idStatus_FK int not null,
    
    foreign key(idLocal_FK) references local(idLocal),
    foreign key(idUsuario_FK) references usuario(idUsuario),
    foreign key(idStatus_FK) references status_tarefa(idStatus)
);

create table tarefa_responsaveis(
	idResponsavel int primary key auto_increment,
    idTarefa_FK int not null,
    idResponsavel_FK int not null,
    
    foreign key(idResponsavel_FK) references usuario(idUsuario),
    foreign key(idTarefa_FK) references tarefa(idTarefa)
);

create table tarefa_andamento(
	idComentario int primary key auto_increment,
    idTarefa_FK int not null,
    idStatus_FK int not null,
    comentario varchar(255) not null,
    
    foreign key(idTarefa_FK) references tarefa(idTarefa),
    foreign key(idStatus_FK) references status_tarefa(idStatus)
);

create table tarefa_fotos(
	idFotoTarefa int primary key auto_increment,
    idTarefa_FK int not null,
    idStatus_FK int not null,
    data_upload DATETIME not null,
    idUsuario_FK int not null,
    
    foreign key(idTarefa_FK) references tarefa(idTarefa),
    foreign key(idStatus_FK) references status_tarefa(idStatus),
    foreign key(idUsuario_FK) references usuario(idUsuario)
);
    
    
    
