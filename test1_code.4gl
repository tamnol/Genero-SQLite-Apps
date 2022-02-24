IMPORT FGL fgldialog
IMPORT om
IMPORT util
SCHEMA person

MAIN

DEFINE y ui.Window
-- question N1
 CALL helloword()

-- question N2
 DEFER INTERRUPT
    CONNECT TO "person"
    WHENEVER ERROR CONTINUE
    CALL  ui.Interface.loadStyles("stylefile")
    CLOSE WINDOW SCREEN
    OPEN WINDOW persw WITH FORM "Test1_userInterface"

    LET y = ui.Window.forName("")

    MENU "list-commands"
        COMMAND "show"
            CALL  personinfo()
        COMMAND "exit"
            EXIT  MENU
    END MENU
        DISCONNECT CURRENT
 CLOSE WINDOW persw


END MAIN

FUNCTION helloword()

DEFINE hello STRING
LET hello = "Hello World"
CALL fgl_winmessage("Hi", hello,"stop")

END FUNCTION


FUNCTION personinfo()
 --DEFINE sqlstr STRING
 DEFINE person_rec RECORD
         perid LIKE  person.P_id,
         pername LIKE person.p_name,
         perdateOfbirth LIKE person.p_dateOfbirth,
         perstate LIKE person.p_state,
         percity LIKE  person.p_city,
         perzip LIKE person.p_zip_code,
         perjoin LIKE  person.p_dateOfjoin,
         perphone LIKE   person.p_phone,
         perstatus LIKE   person.P_status
    END RECORD
        LET person_rec.perid ="20235"
        LET person_rec.pername = "Sophia Validagana"
        LET person_rec.perdateOfbirth = "01/23/1925"
        LET person_rec.perstate = "Washington"
        LET person_rec.percity = " Delaware"
        LET person_rec.perphone =  "5026351245"
        LET person_rec.perjoin = "02/23/2020"
        LET person_rec.perstatus = "married"
        LET person_rec.perzip = "920653"

    WHENEVER ERROR CONTINUE
    INSERT INTO person VALUES (person_rec.*)
    WHENEVER ERROR STOP
    IF sqlca.sqlcode == 0 THEN
        DISPLAY  " INFO ENTERED SUCCESSFULLY"
        CALL display_data()
    ELSE
        DISPLAY " THIS IS WHAT WHEN WRONG:",  SQLERRMESSAGE
    END IF


END FUNCTION

FUNCTION display_data()
    DEFINE person_dyn DYNAMIC ARRAY OF RECORD
        perid LIKE  person.P_id,
         pername LIKE person.p_name,
         perdateOfbirth LIKE person.p_dateOfbirth,
         perstate LIKE person.p_state,
         percity LIKE  person.p_city,
         perzip LIKE person.p_zip_code,
         perjoin LIKE  person.p_dateOfjoin,
         perphone LIKE   person.p_phone,
         perstatus LIKE   person.P_status
        END RECORD,

        person_rec RECORD
         perid LIKE  person.P_id,
         pername LIKE person.p_name,
         perdateOfbirth LIKE person.p_dateOfbirth,
         perstate LIKE person.p_state,
         percity LIKE  person.p_city,
         perzip LIKE person.p_zip_code,
         perjoin LIKE  person.p_dateOfjoin,
         perphone LIKE   person.p_phone,
         perstatus LIKE   person.P_status
        END RECORD,
          persid LIKE person.P_id,
          persname LIKE person.p_name
       --   act_p SMALLINT

   -- CLOSE WINDOW SCREEN
 --   OPEN WINDOW screndisplay WITH FORM "Test1_userInterface."

    DECLARE  curr_per SCROLL CURSOR FOR SELECT * FROM person ORDER BY P_id

    CALL person_dyn.CLEAR()

    FOREACH curr_per INTO person_rec.*
    CALL person_dyn.appendElement()
    LET person_dyn[person_dyn.getLength()].* = person_rec.*
    END FOREACH

    LET persid = NULL
    LET persname = NULL

    IF person_dyn.getLength() > 0 THEN
        DISPLAY ARRAY person_dyn TO sr_person.*
        IF NOT INT_FLAG THEN
        DISPLAY " CANNOT DISPLAY DATA",  SQLERRMESSAGE
           -- LET act_p = arr_curr()
           -- LET persid = person_dyn[act_p].perid
           -- LET persname = person_dyn[act_p].pername

        END IF
    END IF
-- CLOSE WINDOW screndisplay
  --  RETURN persid, persname

END FUNCTION




