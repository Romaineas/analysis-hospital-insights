
--Base hospital ANÁLISES MÉDICAS  E DE PACIENTES

--Objetivo: Compreender o perfil dos pacientes, eficiência dos atendimentos, desempenho dos médicos e padrões de saúde.

--Perfil e comportamento dos pacientes

--Perguntas de negócio:



--Objetivo: entender o perfil demográfico dos pacientes e seus padrões de atendimento

select 
	p.genero,               -- Agrupa por gênero
	AVG(DATEDIFF(YEAR, p.data_nascimento, GETDATE())) AS idade_media,   -- Calcula idade média por gênero
	COUNT(DISTINCT f.id_paciente) AS qtd_pacientes,  -- Conta pacientes únicos
	COUNT(f. id_atendimento) AS total_atendimento   -- Conta quantos atendimentos no total

from fato_atendimento f
Join [dbo].[dim_paciente (1)] p ON f.id_paciente = p.id_paciente  -- Liga a fato com os dados dos pacientes
group by p.genero;


-- EFICIÊNCIA MÉDICA E O TEMPO DE ATENDIMENTO

--Objetivo: identificar produtividade dos médicos e tempo médio gasto em cada atendimento.


SELECT 
	m.nome AS nome_medico,
	m.especialidade,
	COUNT(*) AS total_atendimnetos,
	AVG(f.tempo_atendimento_min) AS tempo_medio_min,
	ROUND(AVG(f.satisfacao_paciente), 2) AS satisfacao_media
FROM [dbo].[fato_atendimento] f
JOIN dbo.dim_medico m ON f.id_medico = m.id_medico
group by m.nome, m.especialidade
order by total_atendimnetos desc;


--PROCEDIMENTOS MAIS REALIZADOS E RENTÁVEIS
--Objetivo: descobrir os procedimentos mais comuns e com maio retorno financeiro.

SELECT 
	pr.tipo_procedimento AS procedimento,
	COUNT(*) AS total_procedimentos,     -- Quantas vezes foi realizado
	SUM(f.valor_atendimento) AS receita_total,  -- receita  total gerada
	ROUND(AVG(f.valor_atendimento), 2) AS valor_medio -- valor médio cobrado
FROM fato_atendimento f
JOIN dim_procedimento pr ON f.id_procedimento = pr.id_procedimento
group by pr.tipo_procedimento
order by receita_total desc;

--EFICIÊNCIA MÉDICA E TEMPO MÉDIO DE ATENDIMENTO
--Objetivo: Identificar produtividade dos médicos e tempo médio gasto em cas atendimento.

SELECT 
	m.nome AS nome_atendimento,
	m.especialidade,
	COUNT(*) AS total_atendimentos,  -- total de procedimentos feitos pelo médico
	AVG(f.tempo_atendimento_min) AS tempo_medio_min, -- tempo médio em minutos
	ROUND(AVG(f.satisfacao_paciente), 2) AS satisfacao_media  -- Médis das notas de satisfação
FROM [dbo].[fato_atendimento] f
JOIN dbo.dim_medico m ON f.id_medico = m.id_medico
group by m.nome, m.especialidade
order by total_atendimentos desc;

--ANÁLISE FINANCEIRAS E DE CUSTOS
--Objetivo: entender qual a especialidade traz mais faturamento ao hospital.

SELECT
	m.especialidade,
	SUM(f.valor_atendimento) AS receita_total,
	COUNT(*)  AS qtd_atendimentos,
	ROUND(AVG(f.valor_atendimento), 2) AS ticket_medio
FROM fato_atendimento f
JOIN dim_medico m ON f.id_medico = m.id_medico
group by especialidade
order by receita_total desc;


--MARGEM DE LUCRO E RENTABILIDADE
--Objetivo: avaliar lucro e eficiência operacional de cada procedimento.

SELECT
	pr.tipo_procedimento AS procedimento,
	SUM(f.valor_atendimento) AS receita_total, -- Total cobrado
	SUM(f.custo_operacional) AS custo_total,  --Custos totais 
	SUM(f.valor_atendimento - f.custo_operacional) AS lucro_total, --Receita de custo
	ROUND(AVG((f.valor_atendimento - f.custo_operacional)/NULLIF(f.valor_atendimento, 0)) * 100, 2 ) AS margem_media
FROM fato_atendimento f
JOIN dim_procedimento pr ON f.id_procedimento = pr.id_procedimento
group  by pr.tipo_procedimento
order by margem_media desc;

--select * from dim_procedimento


--RECEITA DE CUSTO POR MÊS
--Objetivo Acompanhar desempenho financeiro mensal.


SELECT
	t.ano,
	t.mes,
	DATENAME(MONTH, t.data) AS nome_mes,
	SUM(f.valor_atendimento) AS receita_total,
	SUM(f.custo_operacional) AS custo_total,
	SUM(f.valor_atendimento - f.custo_operacional) AS lucro_total,
	COUNT(*) AS qtd_atendimento
FROM  fato_atendimento f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
GROUP by t.ano, t.mes, DATENAME(MONTH, t.data)
order by t.ano, t.mes desc;














