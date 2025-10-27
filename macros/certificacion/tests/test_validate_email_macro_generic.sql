--TEST PARA VALIDAR EL EMAIL QUE TIENE @ CREADO DENTRO DE MACROS/CERTIFICACION/TESTS
--El test se puede anidar al nivel deseado
{% test validate_email_macro_generic(model,column_name) %}
    
    {{ config(severity = 'warn') }} --Se indica que este test si falla salga warning y no falle
    with seleccion_informacion as (

        select
            {{ column_name }} as campo_email
        from {{ model }}

    ),validacion_errores as (

        select
            campo_email

        from seleccion_informacion
        WHERE campo_email NOT LIKE '%@%' --Si hay algún registro que no tiene @ el test ha de fallar

    )

    select *
    from validacion_errores


{% endtest %}