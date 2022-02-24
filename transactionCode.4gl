SCHEMA hrmdb




FUNCTION transac_funct()

     DEFINE insert_value SMALLINT

    CALL ui.Form.setDefaultInitializer("initToolbar")
    CALL ui.Interface.loadStyles("stylefile")

    OPEN WINDOW  transform WITH FORM   "transFormfile"

            MENU
                -- add action
                ON ACTION  ADD
 --                   CALL  add_records() RETURNING insert_value
                    CALL Dialog.setActionActive("search", FALSE)
                ON ACTION ACCEPT
                    CALL Dialog.setActionActive("find", TRUE)
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
 --                       CALL insert_records()
                        CALL Dialog.setActionActive("find", TRUE)
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
    CLOSE WINDOW  transform


END FUNCTION



