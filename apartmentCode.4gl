SCHEMA hrmdb

DEFINE  apartment_rec RECORD LIKE apartment.*

FUNCTION apartment_funct()

    DEFINE insert_value SMALLINT

    CALL ui.Form.setDefaultInitializer("initToolbar")
    CALL ui.Interface.loadStyles("stylefile")


     DEFER INTERRUPT
    CONNECT TO "hrmdb"
    WHENEVER ERROR CONTINUE

    OPEN WINDOW  apartform WITH FORM   "apartFormfile"

            MENU
            -- add action
                ON ACTION  ADD
                    CALL  add_apartment() RETURNING insert_value
                    CALL Dialog.setActionActive("search", FALSE)

                ON ACTION ACCEPT
                    IF (insert_value) THEN
                        CALL insert_records_apartment()
                        CALL Dialog.setActionActive("search", TRUE)
                    ELSE
                        MESSAGE" cannot Handle the Record"
                    END IF

                ON ACTION search
                ON ACTION CANCEL 
                      CLEAR FORM
                ON ACTION FIRST
                ON ACTION PREVIOUS
                COMMAND "next"
                ON ACTION LAST

                 command"update"
                ON ACTION DELETE

                command "quit"
                    EXIT MENU

            END MENU
    CLOSE WINDOW apartform





END FUNCTION

-- add function
FUNCTION add_apartment()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
      LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF
    INPUT BY NAME   apartment_rec.*

    IF NOT (apartment_rec.unit_number is null) THEN

        LET insert_ok = TRUE
    ELSE
        ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION
--insert records function
FUNCTION insert_records_apartment()

        WHENEVER ERROR CONTINUE
        INSERT INTO apartment VALUES(apartment_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase", SQLERRMESSAGE
        END IF

END FUNCTION

