
MAIN


     DEFINE  x, res, c BIGINT,
            i, a, b  BIGINT

    PROMPT" Enter your number to get the Fibonacci result: " FOR x

    CALL fibonacci(x) RETURNING res
    DISPLAY " FIBONACCI RESUlT: "

      LET i = 1
      LET a = 0
      LET c = 0
      WHILE c < res

        IF c <= 1 THEN
            DISPLAY c
            LET c = c+1
        ELSE
            DISPLAY i + a
            LET b  = i+a
            LET a = i
            LET i = b
            LET c = c+1
        END IF

     END WHILE


END MAIN


FUNCTION fibonacci(n)

DEFINE n, result  BIGINT

    IF n <= 0 THEN
       LET  result = 0
       DISPLAY result
       EXIT PROGRAM
    END IF
    IF n == 1 THEN
        LET result = n
        DISPLAY result
        EXIT PROGRAM
    END IF
    IF NOT  n MATCHES "[0-9]*"THEN
            DISPLAY  "NOT VALID NUMBER"
            EXIT PROGRAM
     ELSE
        LET result = n
    END IF

RETURN result
END FUNCTION

