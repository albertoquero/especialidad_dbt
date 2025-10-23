SEEDS
------------------------------------
* Si llamamos a la configuracion "persist_doc", los campos han de estar igual que en el data wareshouse si no no lo detecta


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
SOURCES
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
NOTAS
* Tiene preferencia el freshnes en el source yml y dentro de este las tablas
* El freshness si lo configuramos en el dbt_project no tiene campo loaded_at_field es genérico. Aunque 
podemos meternos en los distintos sources. 
* El source name ha de ser unico, cuidado con mayus y minusculas. Ha de ser IGUAL. El nombre de la tabla 
cuando se pone en el source ha de ser igual tambien. A la hora de hacer el freshnes en el CLI, si
hacemos sobre una tabla ha de coincidir Mayus y Minus
* Por defecto cuando se hace freshness se crea sources.json en el directorio target aunque se puede cambiar con --output o con -o
* Si no se añade nada o se deja vacio el freshnness no calculará nada. Si no se pone loaded_at_field no hara freshness
* Configurar el freshness cada 30 min
* Usar filtro de frescura para evitar costes grandes
* Si no queremos que chekee una tabla ponemos su freshness a NULL
* dbt build no incluye freshness
* El comando freshness se ha de ejecutar frecuentemente acuerdo con los SLAs. 
    - SLA 1 hora hacer freshnesss cada 30 min
    - SLA 1 day hacer freshnesss cada 12 horas
    - SLA 1 semana hacer freshnesss cada dia
* En snowflake usan LAST_ALTERED para el freshness
* En un STG se deberia hacer solo:
    - Renombrado
    - Casteos de tipo
    - cambios mínimos ( pasar de euros a dolareS)
    - Categorizar cosas (case when)
    - NO joins
    - NO agregaciones
    - Materializar como VISTAS
    - Relacion 1-1 con las tablas
    - Cambios siempre lo antes posible
* loaded_at_field puedo poner:
    loaded_at_field: campo
    loaded_at_field: "campo::timestamp"
    loaded_at_field: "CAST(campo as timestamp)"
    loaded_at_field: "convert_timezone...)"
COMANDOS

dbt source freshness --> hace el freshneess de todos los sources
dbt source freshness --output target/source_freshness.json --> saca la salida del freshness a un path distinto
dbt source freshness --select "source:source_name" --> solo hace freshness de un source específico
dbt source freshneess --select "source:source_name.table" --> hace el freshness de la tabla concreta
dbt build --select source_status:fresher+ --> hace build y test de modelos de los a partir de los sources que están SOLO FRESCOS
dbt source freshness --select source:source -->Sin comillas hace freshness de todo el source
dbt source freshness --select source:source_name.table source:source_name.table
dbt source freshness --select tag:cert --> Se llama con un tag concreto


------------------------------------------------------------------------------------------------------------------------------------------
TEST SINGULARES
------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------
TEST GENERICOS
------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------
MACROS
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
SNAPSHOTS
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
JINJA
------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
INCREMENTALES
------------------------------------------------------------------------------------------------------------------------------------------
