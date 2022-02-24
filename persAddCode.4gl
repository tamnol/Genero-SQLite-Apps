DATABASE person


DEFINE addr_rec, rec1 RECORD LIKE personAddress.*
MAIN


CONNECT TO "person"
    WHENEVER ERROR CONTINUE
    CALL  ui.Interface.loadStyles("stylefile")
    CALL  personinsert()
    CLOSE WINDOW SCREEN
    OPEN WINDOW address WITH FORM "addrssform"
    MENU
        ON ACTION SHOW
          IF validation("H") THEN
            CALL  displayData()
        END IF
          ON ACTION DELETE
          IF INT_FLAG THEN
            DISPLAY " you cancel the current operation"
        END IF

        ON ACTION QUIT
            EXIT  MENU
    END MENU

    DISCONNECT CURRENT
CLOSE WINDOW address


END MAIN

FUNCTION personinsert()

 DEFINE address_rec RECORD LIKE personAddress.*,
         perid LIKE  personAddress.id,
         perfname LIKE personAddress.first_name,
         perlname LIKE personAddress.last_name,
         perphone LIKE personAddress.phone_no,
         peremail LIKE personAddress.email,
         perzid LIKE personAddress.zip_code,
         percomment LIKE  personAddress.comment

        LET perid   = 1
        LET perfname = "Emma"
        LET perlname = "Tomson"
        LET perphone = "5026351245"
        LET peremail =" mysel@costy.com"
        LET perzid = "920653"
        LET percomment = " I have provided comment for the assignment"
        WHENEVER ERROR CONTINUE
            INSERT INTO personAddress VALUES(address_rec.*)
        WHENEVER ERROR STOP
         IF sqlca.sqlcode == 0 THEN
        MESSAGE " INFO ENTERED SUCCESSFULLY"
        ELSE
        DISPLAY " THIS IS WHAT WHEN WRONG:",  SQLERRMESSAGE
        END IF

END FUNCTION

FUNCTION validation(t_key)

      DEFINE   t_key CHAR(1),
              checker SMALLINT



        LET  checker = TRUE
        INITIALIZE addr_rec.* TO  NULL

        IF t_key = "H"  THEN
            LET addr_rec.* =  rec1.*
        END IF
        LET checker = FALSE
INPUT BY NAME addr_rec.* WITHOUT DEFAULTS ATTRIBUTES (UNBUFFERED)

      BEFORE INPUT
        MESSAGE"  pay attention of some the input fields"
            NEXT FIELD id

            BEFORE FIELD id
                    MESSAGE " Enter a Number only"

            AFTER FIELD id
                IF addr_rec.id IS NULL THEN
                    NEXT FIELD CURRENT
                END IF
                IF addr_rec.id < 0 THEN
                       LET addr_rec.id =  0
                END IF
                 IF NOT  addr_rec.id  MATCHES "[1-9]*" THEN
                     ERROR  " That is a wrong number"
                     NEXT FIELD id
                END IF


            ON CHANGE id
            IF (t_key = "H") THEN
            WHENEVER ERROR CONTINUE
                SELECT * INTO addr_rec.* FROM personAddress ORDER BY id
            WHENEVER ERROR STOP
                IF SQLCA.SQLCODE <= 0 THEN
                    ERROR " NOT RECORD FOUND IN THE TABLE"
                    LET  checker = FALSE
                    EXIT INPUT
                END IF
            END IF

            AFTER FIELD first_name
                IF addr_rec.first_name is NULL THEN
                    ERROR  " cannot be empty"
                    NEXT FIELD CURRENT
                END IF

            AFTER FIELD last_name
                IF addr_rec.last_name is NULL THEN
                    ERROR  "cannot be empty"
                    NEXT FIELD CURRENT
                END IF

            AFTER FIELD phone_no
                IF addr_rec.phone_no is NULL THEN
                    LET addr_rec.phone_no = 0
                END IF
                IF NOT  addr_rec.phone_no  MATCHES "[1-9]?????????" THEN
                    ERROR  "HAS TO BE DIGITS"
                    NEXT FIELD CURRENT
                 END IF


            AFTER FIELD email
                IF not  addr_rec.email  MATCHES "[a-zA-Z1-9]@[a-zA-Z].com" THEN
                    ERROR  "Enter correct email"
                    NEXT FIELD CURRENT
                END IF


            AFTER FIELD zip_code
                 IF NOT  addr_rec.zip_code  MATCHES "[1-9]?????" THEN
                    ERROR  "Wrong zipcode"
                    NEXT FIELD CURRENT
                 END IF

        AFTER INPUT
            message  " Data enter have been recorded"
END INPUT
RETURN t_key
END FUNCTION

FUNCTION displayData()

DISPLAY BY NAME addr_rec.*

END FUNCTION

