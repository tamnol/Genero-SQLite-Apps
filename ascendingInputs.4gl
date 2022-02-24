


MAIN

    DEFINE a, b, c, x, y, z INTEGER,
                    i  SMALLINT,
           arr DYNAMIC ARRAY OF INTEGER
      PROMPT" Enter 1st Number: " FOR a
      LET arr[1]  = a
      PROMPT" Enter 2nd Number: " FOR b
      LET arr[2] = b

      PROMPT" Enter 1st Number: " FOR c
    LET arr[3] = c
    LET i = 1

    WHILE i < arr.getLength()
        LET x = arr[i]
        LET y = arr[i+1]
      IF x < 0 AND y < 0 THEN
           LET x = -1*x
           LET y = -1*y
           IF x < y THEN
                LET a = y
                LET y = x
                LET x = a
            END IF
        END IF

    IF x < 0 AND y > 0 THEN
            LET x = -1*x
            IF x > y THEN
              LET a = y
              LET y = -x
              LET x = a
            END IF
    END IF


    IF y < 0 AND x > 0 THEN
            LET y = -1*y
            IF y > x THEN
              LET a = x
              LET x = -y
              LET y = a
            END IF
    END IF


        IF x > y THEN
            LET z = x
            LET x = y
            LET y = z
            LET i = i+1
        ELSE
            let i = i+1
        END IF

    END WHILE

-- ascending outputs
    FOR x = 1 TO 3

        DISPLAY arr[ arr.getLength()+1 - x]

    END FOR

END MAIN


