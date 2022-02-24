SCHEMA hrmdb

DEFINE payment_rec RECORD LIKE payment.*

FUNCTION payment_funct()

     DEFINE insert_value SMALLINT

    CALL ui.Form.setDefaultInitializer("initToolbar")

    OPEN WINDOW  payform WITH FORM   "payFormfile"

    CALL ui.Form.setDefaultInitializer("initToolbar")
    CALL ui.Interface.loadStyles("stylefile")

            MENU
                -- add action
                ON ACTION  ADD
                    CALL  add_payment() RETURNING insert_value
                    CALL Dialog.setActionActive("search", FALSE)
                ON ACTION ACCEPT
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
                        CALL insert_records_payment()
                        CALL Dialog.setActionActive("search", TRUE)
                        END IF

                ON ACTION search

                ON ACTION CANCEL
                ON ACTION FIRST
                ON ACTION PREVIOUS
                ON ACTION  NEXT
                ON ACTION LAST

                ON ACTION  UPDATE
                ON ACTION DELETE

                ON ACTION QUIT
                    EXIT MENU

            END MENU
    CLOSE WINDOW payform

END FUNCTION

-- add function
FUNCTION add_payment()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
    INPUT BY NAME  payment_rec.*
    LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF

    IF NOT ( payment_rec.unit_number is null AND   payment_rec.Amount is NULL) THEN

              --  IF (employee_rec.dateOfbirth > employee_rec.dateOfjoin ) THEN
                       LET insert_ok = TRUE
                ELSE
                     ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION
--insert records function
FUNCTION insert_records_payment()

        WHENEVER ERROR CONTINUE
        INSERT INTO payment VALUES( payment_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase"
        END IF

END FUNCTION