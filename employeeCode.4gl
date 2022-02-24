SCHEMA searchme


DEFINE employee_rec, rec1 RECORD LIKE employee.*

MAIN
DEFINE  insert_value SMALLINT



     DEFER INTERRUPT
        CONNECT TO "searchme"
        WHENEVER ERROR CONTINUE
        CLOSE WINDOW SCREEN

    OPEN WINDOW search1 WITH FORM "employeeFormSearch" ATTRIBUTES (STYLE="important" )

         MENU " Add or Search Employee Information"

-- add action
            ON ACTION  ADD
                CALL  add_records() RETURNING insert_value

                CALL Dialog.setActionActive("search", FALSE)
               ON ACTION ACCEPT
                    CALL Dialog.setActionActive("find", TRUE)
                    CALL Dialog.setActionActive("Delete", TRUE)
                    IF (insert_value) THEN
                        CALL insert_records()
                        CALL Dialog.setActionActive("find", TRUE)
                    END IF
---search action
             ON ACTION find
                   CALL  query_search()

-- delete command
                COMMAND "Delete"
                    CALL DIALOG.setActionActive("add", TRUE)
                    CALL DIALOG.setActionActive("find", TRUE)
                    CALL clear_input()
-- exit action
            ON ACTION exit
                EXIT MENU
          END MENU
      DISCONNECT CURRENT
 CLOSE WINDOW search1


END MAIN



-- add function
FUNCTION add_records()
    DEFINE insert_ok, int_flag SMALLINT
    LET insert_ok = FALSE
    INPUT BY NAME employee_rec.*
    LET  int_flag = FALSE

    IF  int_flag = TRUE THEN
        MESSAGE " Operation was cancelled"
        CLEAR FORM
    END IF

    IF NOT (employee_rec.id is null AND  employee_rec.ename is NULL) THEN

              --  IF (employee_rec.dateOfbirth > employee_rec.dateOfjoin ) THEN
                       LET insert_ok = TRUE
                ELSE
                     ERROR   "WRONG INFO PROVIDED"
    END IF

 RETURN insert_ok
END FUNCTION

--function to clear fileds

FUNCTION clear_input()

 CLEAR SCREEN ARRAY  sr_employee.*

END FUNCTION
--insert records function
FUNCTION insert_records()

        WHENEVER ERROR CONTINUE
        INSERT INTO employee VALUES(employee_rec.*)
        WHENEVER ERROR STOP

        IF sqlca.sqlcode = 0 THEN

            MESSAGE " 1 Row Was Successfully ADDED :)"
        ELSE
            MESSAGE " Row Found in the DataBase"
        END IF

END FUNCTION
-- function search employee records
FUNCTION query_search()

DEFINE   row_found SMALLINT,
        where_clause STRING,
        in_flag SMALLINT



   CONSTRUCT BY NAME where_clause ON employee.id, employee.ename

        LET  INT_FLAG = FALSE
        INITIALIZE rec1.* TO  NULL


        IF ( INT_FLAG = TRUE  ) THEN
        LET employee_rec.* = rec1.*
            Message" The OPERATION WAS CANCELED"
            CALL clear_input()
            LET in_flag = true
        ELSE
            CALL record_counter(where_clause) RETURNING row_found

            IF (row_found > 0) THEN
                Message" rows were found "
                CALL record_fetcher(where_clause)

            ELSE
                MESSAGE "NO ROW FOUND"
            END IF
        END IF

END FUNCTION
-- function to count
FUNCTION record_counter(pos_where_clause)

DEFINE pos_where_clause STRING,
       sql_txt STRING,
       row_cnt SMALLINT


       WHENEVER ERROR CONTINUE
        LET  sql_txt = "SELECT count(*)  FROM employee where "||
                        pos_where_clause CLIPPED ||" order by id"

        PREPARE rows_stmt FROM  sql_txt
        EXECUTE rows_stmt INTO row_cnt

      IF sqlca.sqlcode = 0 THEN
         MESSAGE " Successfully counted"
       END IF

       IF sqlca.sqlcode = 100  THEN
            MESSAGE " NO RECORD TO COUNT"

        ELSE
                ERROR "Something Went Wrong: ", SQLERRMESSAGE
        END IF
        
RETURN row_cnt
END FUNCTION

--function to fetch
FUNCTION record_fetcher(ps_where_clause)

DEFINE ps_where_clause STRING,
                 sqltxt STRING




        LET  sqltxt = "SELECT id, ename, dateOfbirth, city, "||
                      "state, salary, dateOfjoin, department " ||
                      "FROM employee where " || ps_where_clause CLIPPED ||" order by id"
        PREPARE r_stmt FROM  sqltxt
    --    EXECUTE r_stmt INTO employee_rec.*
      DECLARE emp_cur CURSOR FOR r_stmt
      OPEN emp_cur
      FETCH emp_cur INTO employee_rec.*
      FREE emp_cur
-- To Display over a New Window
CALL ui.Interface.loadStyles("stylefile")
OPEN WINDOW disp WITH FORM "employeeFormDisplay"
      DISPLAY BY NAME employee_rec.*

    MENU"<<<SEARCH RESULTS>> "
        ON ACTION QUIT
                EXIT MENU
    END MENU
CLOSE WINDOW disp



END FUNCTION



