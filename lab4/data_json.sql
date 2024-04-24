--EXAMPLES

DECLARE
    cursor_json SYS_REFCURSOR;

    json_create_table_lol CLOB := '
    {
        "query_type": "CREATE TABLE",
        "table": "lol",
        "columns": 
        [
            {
                "name": "id",
                "type": "NUMBER"
            },
            {
                "name": "name",
                "type": "VARCHAR2(200)"
            }
        ],
        "primary_keys": ["id"]
    }
    ';

    json_select_all_table1 CLOB := '
    {
        "query_type": "SELECT",
        "columns": ["*"],
        "tables": ["table1"]
    }
    ';
    
    json_insert_table1 CLOB := '
    {
        "query_type": "INSERT",
        "table": "table1",
        "columns": ["id", "name", "table2_id"],
        "values": ["10", "''ahoha''", "1"]
    }
    ';

    json_delete_table2 CLOB := '
    {
        "query_type": "DROP TABLE",
        "table": "table2",
        "parameters": "purge"
    }
    ';

    json_delete_ahoha CLOB := '
    {
        "query_type": "DELETE",
        "table": "table",
        "filter_conditions": ["name = ahoha"]
    }
    ';   
BEGIN
    -- cursor_json := func_parse_json(json_create_table_lol);
    -- cursor_json := func_parse_json(json_insert_table1);
    -- cursor_json := func_parse_json(json_delete_ahoha);
    -- cursor_json := func_parse_json(json_delete_table2);

    -- cursor_json := func_parse_json(json_select_all_table1);
    -- dbms_sql.return_result(cursor_json);
END;


-- TASK

DECLARE
    cursor_json SYS_REFCURSOR;
    json_create_t1 CLOB := '
    {
        "query_type": "CREATE TABLE",
        "table": "t1",
        "columns": 
        [
            {
                "name": "id",
                "type": "NUMBER"
            },
            {
                "name": "num",
                "type": "NUMBER"
            },
            {
                "name": "val",
                "type": "VARCHAR2(200)"
            }
        ],
        "primary_keys": ["id"]
    }
    ';

    json_create_t2 CLOB := '
    {
        "query_type": "CREATE TABLE",
        "table": "t2",
        "columns": 
        [
            {
                "name": "id",
                "type": "NUMBER"
            },
            {
                "name": "num",
                "type": "NUMBER"
            },
            {
                "name": "val",
                "type": "VARCHAR2(200)"
            },
            {
                "name": "t1_k",
                "type": "NUMBER"
            }
        ],
        "primary_keys": ["id"],
        "foreign_keys": [{"field": "id", "table": "t1", "ref_field": "id"}]
    }
    ';
   
    json_select_t1_t2 CLOB := '
    {
        "query_type": "SELECT",
        "columns": ["*"],
        "tables": ["t1"],
        "join_block":
        [
            "RIGHT",
            "t2",
            "t2.t1_k = t1.id"
        ],
        "filter_conditions": 
        [
            {
                "condition_type": "included",
                "condition": 
                {
                    "query_type": "SELECT",
                    "columns": ["id"],
                    "tables": ["t2"],
                    "filter_conditions": 
                    [
                        {
                            "condition": "num between 2 and 4",
                            "operator": "AND"
                        },
                        {
                            "condition": "val like ''%a%''", 
                            "operator": "AND"
                        }
                    ],
                    "operator": "IN",
                    "search_col": "t1.id"
                },
                "operator": "AND"
            }
        ]
    }
    ';
   
BEGIN
    res := func_parse_json(json_create_t1);
    res := func_parse_json(json_create_t2);
    res := func_parse_json(json_select_t1_t2);
    dbms_sql.return_result(res);
END;