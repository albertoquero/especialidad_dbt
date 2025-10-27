SEEDS
------------------------------------
* Si llamamos a la configuracion "persist_doc", los campos han de estar igual que en el data wareshouse si no no lo detecta

COMANDOS

dbt seed
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
TEST
------------------------------------------------------------------------------------------------------------------------------------------
* Ahora se llaman "data test" en vez de "test" para no liarse con los unit test --> Se usa data_test aunque aun se puede usar test
* Usar --store-failures flag o "store_failures /store_failures_as" configuraciones para guardar el resultado de los test fallidos en el warehouse
test fallidos se crean en el schema "dbt_test_audit" se puede cambiar el esquema
* Con el mismo recurso no puedo usar test y data_test
* Para ver como falla un test, se coge el codigo generado y se prueba en el warehouse
* Se recomienda usar para los modelos que tengan PK usar unique y not_null obligatorio
* Se recomienda ejecutar test cada vez que se cree nuevo codigo para asegurar que no se rompe nada.
* se pueden poner nivels de error "threshold" usando "error_if y "warn_if" tambien poner severidad "warn" o "error"
* Hacer unicas dos columnas se puede crear una clave subrrogada, poner una expresion o usar algun metodo de dbtutils
* store_failures en la config tendrá mas prioridad que el flak --store-failures. Si el config esta a none o omitido usara el de la bandera
*Los test en el DW se sobrescriben si son los mismos.
* Se puede cambiar el schema donde se guardan los test con la macro "should_store_failures()"
*store_failures_as tiena mas prioridad que store_failures 
* La severidad indica si sale un war o error en un test.
    - serverity: error/warn --> por defecto es error   
    - error_if: condicional -->esta condicion es la primera que valida si pasa mira la de warn. Si no se pone la de error mira la de warn 
    - warn_if: condicional
    Si no se indica la de error_if el test pasa a warn_if sino se indica el test pasa.
* Si se usa la severidad a warn y el test "falla", pasa de el y ejecuta correctamente, pero SI crea la tabla con el error en la base de datos
* Un test con severity:warn solo devolveran un warning no un error.Sin embargo un warning lo podemos poner como errores:
    - warn-error pasan de ser warning a errores.
    - warn-error-options
* Para que error_if funcione, la severity ha de estar en error. Si esta en warn, pasará del test y lo dará por bueno

COMANDOS

dbt test --select "source:*" --> ejecuta todos los test de los sources
dbt test -s source:<source_name> --> ejecuta test de un source concreto
dbt test -s source:<source_name>.<table> --> ejecuta test de una tabla concreta


-------------------------------------------------------------------------------------------------------------------
TEST SINGULARES
------------------------------------------------------------------------------------------------------------------------------------------
* Se crean dentro del directorio de test
* Usados para un solo proposito 
* Se puede usar ref y source
* definidos en .sql  definicos en el test-path
* Nombre empiece por "assert_"
* No poner ";" al final de la query. Puede hacer que falle
* No se referencian en los yml para no ser tratados como genericos.
* Si queremos descripciones de los test, se crea en el dir test un yml  con la descripcion 
* SOLO se puede configurar con config dentro del fichero .sql y en el dbt_project.yml no dentro del schema.yml.
Tiene preferencia la configuracion a nivel de SQL y luego a nivel de dbt_project

CONFIGURACIONES POSIBLES DENTRO DE SQL y DBT PROJECT SOLO
{{ config(
    fail_calc = "<string>",
    limit = <integer>,
    severity = "error | warn",
    error_if = "<string>",
    warn_if = "<string>",
    store_failures = true | false,
    where = "<string>"
    --globales
    enabled=true | false,
    tags="<string>" | ["<string>"]
    meta={dictionary},
    database="<string>",
    schema="<string>",
    alias="<string>",
) }}

COMANDOS
dbt test -s tag:test_singular_sql --> Ejecuta a partir de un tag
dbt test -s test_x
-------------------------------------------------------------------------------------------------------------------
TEST GENERICOS
------------------------------------------------------------------------------------------------------------------------------------------
- test parametrizados que aceptan argumentos. Se crean como una macro. Se llama dentro de un yml.
* Definidos dentro del directorio macros o dentro de test/generic
* Test definidos por defecto: not_null, unique, relationships, accepted_values. También llamados "test de esquema"
* Se definen como una macro. Se crean en "macros" o "tests/generic"
*Los argumentos son "model" y "column_name"
* Se puede crear un fichero schema.yml dentro de generics que tenga descripciones de los test. 
*Poner prefijo "TEST_<nombre test"
* Si un test necesita más argumentos poner "field", to. Ejemplo test relationships(mdel,column_name, field,to)
* Se puede poner bloque "config" dentro del test generico
* poner como argument "warn_if_odd" indica que el test siempre sera warning l no ser que se indique otra severidad.
	data_tests:
          - warn_if_odd:
              arguments:
                severity: error   # overrides
* error_threshold: 10 (umbral de error) indica que fallará si hay más de 10 errores
* Si se pone dentro de macros puedo usar subcarpetas como macros/tests/test pero si lo pongo en tests/ ha de ser solo tests/generic 
* Si me creo dentro de macros/certificacion/tests un schema.yml o dentro de tests/generic/ un schema.yml para documentar los test saldran en la documentacion
independientemente de que ponga en el source.yml o models.yml dentro de un campo la descripcion. Si pongo por cada campo una descripción también saldra en la documentacion sino indicará que no hay 
--------------------------------------------------------------------------------------------
----------------------------------------------
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
