create database Transito_2;

use Transito_2;

/*
TABLA ORIGINAL
*/

SELECT 
	Av.folio,
    date_format(Av.fecha_creacion, "%Y-%m-%d") as fecha_creacion,
    Av.hora_creacion,
    ds.dia,
    date_format(Av.fecha_cierre, "%Y-%m-%d") as fecha_cierre,
    Av.hora_cierre,
    ic4.incidente_c4,
    delegacion.delegacion as delegacion_inicio,
    Av.latitud,
    Av.longitud,
    Av.ano_cierre,
    alarma.clas_con_f_alarma as alarma,
    entrada.tipo_entrada as entrada,
    delegacion_cierre.delegacion as delegacion_cierre,
    mes.mes as mes_cierre,
    cc.codigo_cierre
FROM Accidentes_viales Av
inner join dia ds on Av.dia_semana = ds.id_dia
inner join incidente_c4 ic4 on Av.incidente_c4 = ic4.id_incidente_c4
inner join delegacion on Av.delegacion_inicio = delegacion.id_delegacion
inner join delegacion as delegacion_cierre on Av.delegacion_cierre = delegacion.id_delegacion
inner join clas_con_f_alarma as alarma on Av.clas_con_f_alarma = alarma.id_clas_con_f_alarma
inner join tipo_entrada as entrada on Av.tipo_entrada = entrada.id_tipo_entrada
inner join mes on Av.mes_cierre = mes.id_mes
inner join codigo_cierre as cc on Av.codigo_cierre = cc.id_codigo_cierre
;

/*
DIMENSIONES:
	--> ¿Quién?
	--> ¿Cuándo?
			'dia_semana'
			'year'
			'month',
	--> ¿Dónde?
			'delegacion_inicio'
            
HECHOS
	--> ¿Cuántos incidentes pasaron?
			'incidente_c4'
	--> ¿Cuántos tipos de alarma se activaron?
			'clas_con_f_alarma'
	--> ¿Cuántos medios de comunicación se utilizaron?
			'tipo_entrada'
	--> ¿Qué codigos de cierre se llevaron acabo?
			'codigo_cierre'
*/

SELECT 
    cast(concat(date_format(Av.fecha_creacion, '%Y-%m'),'-01') as date) fecha,
    ds.dia,
    delegacion.delegacion as delegacion,
    ic4.incidente_c4 as incidente,
    alarma.clas_con_f_alarma as alarma,
    entrada.tipo_entrada as entrada,
    cc.codigo_cierre as codigo
FROM Accidentes_viales Av
inner join dia ds on Av.dia_semana = ds.id_dia
inner join delegacion on Av.delegacion_inicio = delegacion.id_delegacion
inner join incidente_c4 ic4 on Av.incidente_c4 = ic4.id_incidente_c4
inner join clas_con_f_alarma as alarma on Av.clas_con_f_alarma = alarma.id_clas_con_f_alarma
inner join tipo_entrada as entrada on Av.tipo_entrada = entrada.id_tipo_entrada
inner join codigo_cierre as cc on Av.codigo_cierre = cc.id_codigo_cierre
inner join mes on MONTH(date_format(Av.fecha_creacion, "%y-%m-%d")) = mes.id_mes
;

/*
	UNA VEZ LA CONSULTA HECHA CREAMOS UNA VISTA POR MOTIVOS DE SEGURIDAD
*/
CREATE VIEW Acidentes_viales_view 
AS (
SELECT 
    cast(concat(date_format(Av.fecha_creacion, '%Y-%m'),'-01') as date) fecha,
    ds.dia,
    delegacion.delegacion as delegacion,
    ic4.incidente_c4 as incidente,
    alarma.clas_con_f_alarma as alarma,
    entrada.tipo_entrada as entrada,
    cc.codigo_cierre as codigo
FROM Accidentes_viales Av
inner join dia ds on Av.dia_semana = ds.id_dia
inner join delegacion on Av.delegacion_inicio = delegacion.id_delegacion
inner join incidente_c4 ic4 on Av.incidente_c4 = ic4.id_incidente_c4
inner join clas_con_f_alarma as alarma on Av.clas_con_f_alarma = alarma.id_clas_con_f_alarma
inner join tipo_entrada as entrada on Av.tipo_entrada = entrada.id_tipo_entrada
inner join codigo_cierre as cc on Av.codigo_cierre = cc.id_codigo_cierre
inner join mes on MONTH(date_format(Av.fecha_creacion, "%y-%m-%d")) = mes.id_mes
);
	

select * from Accidentes_viales;

