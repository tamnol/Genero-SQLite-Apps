SCHEMA hrmdb

DEFINE association_rec RECORD LIKE association.*

FUNCTION associat_funct()

     DEFINE insert_value SMALLINT

    CALL ui.Form.setDefaultInitializer("initToolbar")
    CALL ui.Interface.loadStyles("stylefile")

    DEFER INTERRUPT
    CONNECT TO "hrmdb"
    WHENEVER ERROR CONTINUE

    OPEN WINDOW  associatform WITH FORM   "associatFormfile"

            MENU
                -- add action
                ON ACTION  ADD
                    CALL  add_association() RETURNING insert_value
                    CALL Dialog.setActionActive("search", FALSE)

                ON ACTION ACCEPT
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
                        CALL insert_records_association()
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

    CLOSE WINDOW  associatform
END FUNCTION

-- add function
FUNCTION add_association()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
    INPUT BY NAME  association_rec.*
    LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF

    IF NOT (association_rec.unit_number is null) THEN

              --  IF (employee_rec.dateOfbirth > employee_rec.dateOfjoin ) THEN
                       LET insert_ok = TRUE
                ELSE
                     ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION
--insert records function
FUNCTION insert_records_association()

        WHENEVER ERROR CONTINUE
        INSERT INTO association VALUES(association_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase"
        END IF

END FUNCTION