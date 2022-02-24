SCHEMA hrmdb

DEFINE tenant_rec RECORD LIKE tenant.*


FUNCTION tenant_funct()

    DEFINE insert_value SMALLINT

     DEFER INTERRUPT
    CONNECT TO "hrmdb"
    WHENEVER ERROR CONTINUE

    CALL ui.Form.setDefaultInitializer("initToolbar")
     CALL ui.Interface.loadStyles("stylefile")
    OPEN WINDOW  tenantform WITH FORM   "tenantFormfile"

            MENU

                -- add action
                ON ACTION  ADD
                    CALL  add_tenant() RETURNING insert_value
                    CALL Dialog.setActionActive("search", FALSE)
                ON ACTION ACCEPT
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
                        CALL insert_records_tenant()
                        CALL Dialog.setActionActive("search", TRUE)
                        END IF

                ON ACTION search

                ON ACTION CANCEL

                ON ACTION FIRST
                ON ACTION PREVIOUS
                COMMAND "next"
                ON ACTION LAST
                 command"update"
                ON ACTION DELETE

                command "quit"
                    EXIT MENU

            END MENU
    CLOSE WINDOW  tenantform



END FUNCTION

-- add function
FUNCTION add_tenant()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
    INPUT BY NAME tenant_rec.*
    LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF

    IF NOT (tenant_rec.unit_number is null AND  tenant_rec.tenant_name is NULL) THEN

              --  IF (employee_rec.dateOfbirth > employee_rec.dateOfjoin ) THEN
                       LET insert_ok = TRUE
                ELSE
                     ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION
--insert records function
FUNCTION insert_records_tenant()

        WHENEVER ERROR CONTINUE
        INSERT INTO tenant VALUES(tenant_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase"
        END IF

END FUNCTION