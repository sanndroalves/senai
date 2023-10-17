create database SistemaFarmacia;
use SistemaFarmacia;


-- CRIANDO AS TABELAS
create table fabricante (
  idFabricante int primary key auto_increment,
  nome varchar(100),
);

create table tipo (
  idTipo int primary key auto_increment ,
  tipo varchar(100) not null
);

create table produto(
  idProduto int primary key auto_increment,
  designacao varchar(100) not null,
  preco_venda decimal(5,2) not null,
  composicao varchar(100) not null,
  idFabricanteFK bigint not null,
  idTipoFK int not null,
  
  foreign key (idFabricante) references fabricante(idFabricanteFK),
  foreign key (idTipoFK) references tipo(idTipo)
);

create table cliente(
  idCliente int auto_increment primary key,
  nome varchar(100) not null,
  cpf char(11) not null,
  endereco varchar(100) not null,
  telefone varchar(100) not null
);

create table medico (
  idMedico int primary key auto_increment,
  nome varchar(100) not null
);


create table receita(
  idReceita int primary key auto_increment ,
  descricao varchar(100) not null,
  idMedicoFK int not null,
  idClienteFK int not null,

  foreign key (idMedicoFK) references medico(idMedico),
  foreign key (idClienteFK) references cliente(idCliente)
);

create table compra(
  idCompra int primary key auto_increment,
  total_venda decimal(5,2) not null,
  data date not null,
  idClienteFK int not null,
  idReceitaFK int null,

  foreign key (idClienteFK) references cliente(idCliente),
  foreign key (idReceitaFK) references receita(idReceita)
); 

create table ItemCompra (
  id bigint not null auto_increment primary key,
  qtd int not null

  idCompraFK int not null,
  idProdutoFK int not null,

  foreign key (idCompraFK) references compra(idCompra),
  foreign key (idProdutoFK) references produto(idProduto)
);

-- INSERINDO DADOS NAS TABELAS
INSERT INTO fabricante (nome) VALUES
  ('Fabricante 1'),
  ('Fabricante 2'),
  ('Fabricante 3');

INSERT INTO tipo (tipo) VALUES
  ('Tipo 1'),
  ('Tipo 2'),
  ('Tipo 3');

INSERT INTO produto (designacao, preco_venda, composicao, idFabricanteFK, idTipoFK) VALUES
  ('Produto 1', 10.99, 'Composição 1', 1, 1),
  ('Produto 2', 15.99, 'Composição 2', 2, 2),
  ('Produto 3', 20.99, 'Composição 3', 3, 3);

INSERT INTO cliente (nome, cpf, endereco, telefone) VALUES
  ('Cliente 1', '12345678901', 'Endereço 1', 'Telefone 1'),
  ('Cliente 2', '23456789012', 'Endereço 2', 'Telefone 2'),
  ('Cliente 3', '34567890123', 'Endereço 3', 'Telefone 3');

INSERT INTO medico (nome) VALUES
  ('Médico 1'),
  ('Médico 2'),
  ('Médico 3');

INSERT INTO receita (descricao, idMedicoFK, idClienteFK) VALUES
  ('Descrição 1', 1, 1),
  ('Descrição 2', 2, 2),
  ('Descrição 3', 3, 3);

INSERT INTO compra (total_venda, data, idClienteFK, idReceitaFK) VALUES
  (50.00, '2023-01-15', 1, 1),
  (75.00, '2023-02-20', 2, 2),
  (100.00, '2023-03-25', 3, 3);

INSERT INTO ItemCompra (qtd, idCompraFK, idProdutoFK) VALUES
  (2, 1, 1),
  (3, 2, 2),
  (4, 3, 3);

-- FAZENDO AS CONSULTAS
-- A
SELECT nome, cpf, telefone FROM cliente;
SELECT * FROM compra;

-- B
SELECT cl.idCliente, cl.nome, co.idCompra, co.total_venda, co.data
FROM cliente AS cl
INNER JOIN compra AS co ON cl.idCliente = co.idCliente
INNER JOIN ItemCompra AS ic ON co.idCompra = ic.idCompra;

-- C
SELECT cl.idCliente, cl.nome, ic.idProduto, pd.designacao, ic.qtd, pd.preco_venda, co.total_venda
FROM cliente AS cl
INNER JOIN compra AS co ON cl.idCliente = co.idCliente
INNER JOIN ItemCompra AS ic ON co.idCompra = ic.idCompra
INNER JOIN produto AS pd ON pd.idProduto = ic.idProduto;

-- D
SELECT cl.nome, COUNT(co.idCliente) AS total_vendas
FROM cliente AS cl
INNER JOIN compra AS co ON cl.idCliente = co.idCliente
GROUP BY cl.idCliente 
ORDER BY cl.idCliente DESC;

-- E
SELECT me.nome, COUNT(co.idMedico) AS total_compras
FROM medico AS me
INNER JOIN compra AS co ON me.idMedico = co.idMedico
GROUP BY me.idMedico 
ORDER BY me.idMedico ASC;

-- F
SELECT data, SUM(total_venda) AS faturamento_por_dia
FROM compra
GROUP BY data;

-- G
SELECT SUM(total_venda) AS faturamento_total
FROM compra;

-- H
UPDATE produto SET preco_venda = 25 WHERE idProduto = 3;
INSERT INTO produto (designacao, preco_venda, composicao, idFabricanteFK, idTipoFK)
VALUES ('Novo Produto', 40.00, 'Composição Nova', 2, 2);
SELECT * FROM produto;

-- I
DELETE FROM ItemCompra WHERE idCompraFK = 6;
DELETE FROM compra WHERE idCompra = 6;

