IMPORT util
SCHEMA hrmdb

DEFINE amenity_rec RECORD LIKE amenity.*

FUNCTION amenity_funct()

--extended owner type form field
DEFINE cb ui.ComboBox,
        dt DATETIME HOUR  TO SECOND,
        insert_value SMALLINT

    DEFER INTERRUPT
    CONNECT TO "hrmdb"
    WHENEVER ERROR CONTINUE


    OPEN WINDOW  amenityform WITH FORM   "amenityFormfile"
        LET cb = ui.ComboBox.forName("amenity.owner_Type")
        CALL owner_type(cb)
       LET dt = util.Datetime.parse("amenity.timing", "%H:%M:%S")


            MENU

-- add action
                ON ACTION  ADD
                    CALL  add_amenity() RETURNING insert_value

                    CALL Dialog.setActionActive("search", FALSE)
                ON ACTION ACCEPT
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
                        CALL insert_records_amenity()
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

    CLOSE WINDOW amenityform
END FUNCTION

-- add type type of amenity owner
FUNCTION owner_type(cb)
    DEFINE cb ui.ComboBox
    CALL cb.clear()
    CALL cb.addItem(3,"Corporation")
    CALL cb.addItem(4,"Community")
    CALL cb.addItem(5,"other")
END FUNCTION

-- add function
FUNCTION add_amenity()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
    INPUT BY NAME  amenity_rec.*
    LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF

    IF NOT (amenity_rec.unit_number is null AND    amenity_rec.amenity_name is NULL) THEN

              --  IF (employee_rec.dateOfbirth > employee_rec.dateOfjoin ) THEN
                       LET insert_ok = TRUE
                ELSE
                     ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION
--insert records function
FUNCTION insert_records_amenity()

        WHENEVER ERROR CONTINUE
        INSERT INTO apartment VALUES(amenity_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase"
        END IF

END FUNCTION


