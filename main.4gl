IMPORT FGL amenityCode
IMPORT FGL apartmentCode
IMPORT FGL ownerCode
IMPORT FGL helpdeskCode
IMPORT FGL paymentCode
IMPORT FGL tenantCode
IMPORT FGL transactionCode
IMPORT FGL associationCode
SCHEMA hrmdb
MAIN
DEFINE w ui.Window


CLOSE WINDOW SCREEN

    OPEN WINDOW m WITH FORM "main"
    CALL ui.Interface.loadStyles("stylefile")
    LET w = ui.Window.getCurrent()
    CALL w.setImage("../homepage.jfif")
    CALL w.setText("Application Main Page")


        MENU

            ON ACTION Owner
                CALL owner_funct()

            ON ACTION Apartment
                CALL apartment_funct()

            ON ACTION Tenant
                CALL tenant_funct()

            ON ACTION Helpdesk
                CALL helpdesk_funct()

            ON ACTION Association
                CALL  associat_funct()

            ON ACTION Amenity
                CALL amenity_funct()

            ON ACTION Transaction
                CALL transac_funct()

            ON ACTION Payment
                CALL payment_funct()

            COMMAND "quit"
                EXIT MENU

        END MENU

    CLOSE WINDOW m

END MAIN
--
FUNCTION initToolbar(m)
    DEFINE m ui.Form
    CALL m.loadToolBar("mytoolbar")
END FUNCTION





