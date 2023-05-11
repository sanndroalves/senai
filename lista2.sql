create database DumpLicenses;
use DumpLicenses;

-- FUNÇÕES 
-- (a)
select count(*) as TOTAL from lcliente;

-- (b)
select * from llicenca WHERE MONTH(dtAquisicao) = 10;

-- (c)
select * from llicenca WHERE MONTH(dtAquisicao) = 05 and YEAR(dtAquisicao) = 2007;

-- (d)
select idTIPO_Empresa, DescricaoTipo, LEFT(DescricaoTipo, 5) as LETRAS from lTIPO_EMPRESA ORDER BY DescricaoTipo ASC;

-- (e)
select idTIPO_Empresa, DescricaoTipo, RIGHT(DescricaoTipo, 5) as LETRAS from lTIPO_EMPRESA ORDER BY DescricaoTipo DESC;

-- (f)
select idTIPO_Empresa, DescricaoTipo, substr(DescricaoTipo, 6,1) as 6pos, substr(DescricaoTipo, 10,1) as 10pos from lTIPO_EMPRESA;

-- (g)
select Nome_RazaoSocial, LENGTH(Nome_RazaoSocial) as Bytes from lCLIENTE order by Nome_RazaoSocial;

-- (h)
select NumLicenca as Num, DtAquisicao as Data, DATEDIFF(NOW(), DtAquisicao) as dias_decorreram from llicenca;

-- (i)
select UPPER(NomeSetor) as ALTO, LOWER(NomeSetor) as BAIXO from lSETOR;

-- (j)
select * from lSoftware as sf
INNER JOIN lversao as ve ON sf.idSOFTWARE = ve.idSOFTWARE_FK;

-- (k)
select cl.Nome_RazaoSocial, em.DescricaoTipo, se.NomeSetor from lcliente as cl
INNER JOIN ltipo_empresa as em ON em.idTIPO_EMPRESA = cl.idTIPO_EMPRESA_FK
INNER JOIN lsetor as se ON se.idSETOR = cl.idSETOR_FK
ORDER BY se.idSETOR ASC;

-- (l)
select cl.idCLIENTE as ID, cl.Nome_RazaoSocial as NOME, li.NumLicenca, li.DtAquisicao, li.ValorAquisicao from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK;

-- (m)
select cl.Nome_RazaoSocial, sf.NomeSoftware from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK
INNER JOIN lsoftware as sf ON sf.idSOFTWARE = li.idSOFTWARE_FK_FK
ORDER BY cl.idCliente AND sf.idSoftware;

-- (n)
select cl.Nome_RazaoSocial, cl.uf, em.DescricaoTipo, se.NomeSetor from lcliente as cl
INNER JOIN ltipo_empresa as em ON em.idTIPO_EMPRESA = cl.idTIPO_EMPRESA_FK
INNER JOIN lsetor as se ON se.idSETOR = cl.idSETOR_FK
WHERE cl.uf = "SP" or cl.uf ="RJ" or cl.uf ="PR" or cl.uf ="MG";

-- (o)
select cl.Nome_RazaoSocial, em.DescricaoTipo, se.NomeSetor, sf.NomeSoftware, ve.Versao, li.NumLicenca, li.dtAquisicao, li.ValorAquisicao from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK
INNER JOIN lsoftware as sf ON sf.idSOFTWARE = li.idSOFTWARE_FK_FK
INNER JOIN lversao as ve ON ve.idSOFTWARE_FK = sf.idSOFTWARE
INNER JOIN ltipo_empresa as em ON em.idTIPO_EMPRESA = cl.idTIPO_EMPRESA_FK
INNER JOIN lsetor as se ON se.idSETOR = cl.idSETOR_FK
ORDER BY sf.idSoftware AND ve.versao AND li.dtAquisicao AND cl.idCliente;

-- (p)
select count(*) as Licencas_Vendias from llicenca;

-- (q)
SELECT SUM(ValorAquisicao) as TOTAL, AVG(ValorAquisicao) as MEDIO, MAX(ValorAquisicao) as MAX, MIN(ValorAquisicao) as MIN FROM llicenca;

-- (r)
select count(*) from lcliente as cl
INNER JOIN lsetor as se ON se.idSETOR = cl.idSETOR_FK
WHERE se.NomeSetor = 'Farmacautica';

-- (s)
select cl.Nome_RazaoSocial as NOME, count(li.NumLicenca) as TOTAL from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK
group by cl.nome_razaosocial;

-- (t)
select cl.Nome_RazaoSocial as NOME, AVG(li.ValorAquisicao) as MEDIO, SUM(li.ValorAquisicao) as TOTAL from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK
group by cl.nome_razaosocial;

-- (u)
select se.NomeSetor, SUM(li.ValorAquisicao) as TOTAL from llicenca as li
INNER JOIN lcliente as cl ON cl.idCliente = li.idCliente_FK
INNER JOIN lsetor as se ON cl.idSETOR_FK = se.idSETOR
group by se.NomeSetor;

-- (v)
select em.idTIPO_EMPRESA, em.DescricaoTipo, SUM(li.ValorAquisicao) as TOTAL from llicenca as li
INNER JOIN lcliente as cl ON cl.idCliente = li.idCliente_FK
INNER JOIN lsetor as se ON cl.idSETOR_FK = se.idSETOR
INNER JOIN ltipo_empresa as em ON cl.idTIPO_EMPRESA_FK = em.idTIPO_EMPRESA
group by se.NomeSetor;

-- (w)
select sf.NomeSoftware, SUM(li.ValorAquisicao) as TOTAL from llicenca as li
INNER JOIN lversao as ve ON li.versao_fk = ve.versao
INNER JOIN lsoftware as sf ON sf.idSOFTWARE = li.idSOFTWARE_FK_FK
group by sf.NomeSoftware;

-- (x)

-- (y)
select cl.Nome_RazaoSocial as NOME, count(li.NumLicenca) as TOTAL from lcliente as cl
INNER JOIN llicenca as li ON cl.idCliente = li.idCliente_FK
INNER JOIN ltipo_empresa as em ON cl.idTIPO_EMPRESA_FK = em.idTIPO_EMPRESA
where = 10
group by cl.nome_razaosocial;

