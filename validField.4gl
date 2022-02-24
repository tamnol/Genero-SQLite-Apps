
SCHEMA searchme

DEFINE student_rec, rec1 RECORD LIKE student_mast.*
MAIN

    DEFINE gud_2_go SMALLINT,
           ket_struck CHAR(1),
           ket_struck_chk CHAR(1),
            IN_FLAG BOOLEAN

    CONNECT TO "searchme"

        WHENEVER ERROR CONTINUE
        CALL ui.Interface.loadToolBar("tolbarform")
        CLOSE WINDOW SCREEN
        OPEN WINDOW w1 WITH FORM "validField"
        MENU


-- action to add information
        ON ACTION ADD
        CALL add_records() RETURNING gud_2_go, IN_FLAG
           IF (gud_2_go) THEN
            CALL  validation( ket_struck) RETURNING ket_struck_chk
                    IF (ket_struck_chk) THEN
                        CALL Dialog.setActionActive("ok", TRUE)
                        CALL Dialog.setActionActive("cancel", false)
                   END  IF
            END IF
            COMMAND "ok"
                CALL insert_info()
-- action to add information

            ON ACTION DELETE
                IF IN_FLAG THEN
                error " you've canceled the current operation"
            END IF
-- action to quit everything
            ON ACTION QUIT
                EXIT  MENU
        END MENU

    DISCONNECT CURRENT
    CLOSE WINDOW w1

END MAIN


-- function Decision making to add data in the system
    FUNCTION add_records()
         DEFINE insert_ok, IN_FLAG SMALLINT
         LET insert_ok = FALSE
         INPUT BY NAME student_rec.*

            IF NOT (student_rec.student_id is null) THEN
                        LET insert_ok = TRUE

            ELSE
                ERROR   "SOMETHING WENT WRONG"
                LET IN_FLAG = true
            END IF

    RETURN insert_ok, IN_FLAG
    END FUNCTION

--function to insert data in the system
    FUNCTION insert_info()

     WHENEVER ERROR CONTINUE
            INSERT INTO student_mast VALUES(student_rec.*)
            WHENEVER ERROR STOP

            IF sqlca.sqlcode == 0 THEN

                MESSAGE " 1 Row Was Successfully ADDED :)"
            ELSE
                MESSAGE " Row Found in the DataBase"
            END IF

    END FUNCTION

-- Implementation of the validation uer interface
    FUNCTION validation(t_key)

        DEFINE   t_key CHAR(1),
                  checker SMALLINT

            LET  checker = TRUE
            INITIALIZE student_rec.* TO  NULL

            IF t_key = "A"  THEN
                LET student_rec.* =  rec1.*
            END IF
            LET checker = FALSE
        INPUT BY NAME student_rec.* WITHOUT DEFAULTS ATTRIBUTES (UNBUFFERED)

          BEFORE INPUT
            MESSAGE"  pay attention to each input field"
                NEXT FIELD student_id

                BEFORE FIELD student_id
                        MESSAGE " Enter digits only"

                AFTER FIELD student_id
                    IF student_rec.student_id IS NULL THEN
                        NEXT FIELD CURRENT
                    END IF
                    IF student_rec.student_id < 0 THEN
                           LET student_rec.student_id =  0
                    END IF
                     IF NOT  student_rec.student_id  MATCHES "[1-9]*" THEN
                         ERROR  " That is a wrong number"
                         NEXT FIELD current
                    END IF


                ON CHANGE student_id
                IF (t_key = "A") THEN
                WHENEVER ERROR CONTINUE
                    SELECT * INTO student_rec.* FROM student_mast ORDER BY student_id
                WHENEVER ERROR STOP
                    IF SQLCA.SQLCODE <= 0 THEN
                        ERROR " NOT RECORD FOUND IN THE TABLE"
                        LET  checker = FALSE
                        EXIT INPUT
                    END IF
                END IF

                AFTER FIELD student_name
                    IF student_rec.student_name is NULL THEN
                        ERROR  " cannot be empty"
                        NEXT FIELD CURRENT
                    END IF

                AFTER FIELD school_id
                    IF student_rec.school_id is NULL THEN
                        ERROR  "cannot be empty"
                        NEXT FIELD CURRENT
                    END IF

                AFTER FIELD phone_no
                    IF (student_rec.phone_no is NULL OR  student_rec.phone_no < 0) THEN
                        LET student_rec.phone_no = 0
                    END IF
                    IF NOT  student_rec.phone_no  MATCHES "[1-9]?????????" THEN
                        ERROR  "HAS TO BE DIGITS"
                        NEXT FIELD CURRENT
                     END IF


                AFTER FIELD date_of_join
                    IF not  student_rec.date_of_join  MATCHES "[1-9]*" THEN
                        ERROR  "Enter correct email"
                        NEXT FIELD CURRENT
                    END IF

                AFTER FIELD zip_code
                     IF NOT  student_rec.zip_code  MATCHES "[1-9]*" THEN
                        ERROR  "Wrong zipcode"
                        NEXT FIELD CURRENT
                     END IF

            AFTER INPUT
                message  " Validation Completed successfully"
    END INPUT
    RETURN t_key
    END FUNCTION


